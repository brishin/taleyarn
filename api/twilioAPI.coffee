mongoose = require('mongoose')
conf = require('../conf')
sys = require('sys')

exports.setup = () ->
  mongoose.connect conf.db.host, conf.db.name, conf.db.port

  Story = mongoose.model('Story')
  Snippet = mongoose.model('Snippet')
  User = mongoose.model('User')
  AbstractUser = mongoose.model('AbstractUser')

  # Twilio
  TwilioClient = require('twilio').Client
  client = new TwilioClient(conf.twilio.accountSID, 
    conf.twilio.authToken, conf.twilio.twHostname)
  phone = client.getPhoneNumber(conf.twilio.phoneNumber)

  phone.setup () ->
    console.log 'Twilio server up at ' + conf.twilio.twHostname
    phone.on 'incomingSms', (req, res) ->
      console.log('Received incoming SMS with text: ' + req.Body)
      console.log('From: ' + req.From)
      currentUser = User.findOne {'password.extraparams.phone': req.From}, (err, doc) ->
        if err
          throw new Error
        if !doc
          newUser = new User
            'password.extraparams.phone': req.From
          newUser.save()
          console.log 'New user created.'
          # Send welcome message.
          phone.sendSms req.From, conf.copy.twilioNew, null, (mess) ->
            console.log 'Welcome message sent.'
            addToStory(newUser)
        else
          console.log 'User found.'

addToStory = (newUser, callback) ->
  Story
    .findOne({})
    .sort('currentNumUsers': 1)
    .run(err, doc) ->
      userId = newUser._id
      doc.userList.push
        new AbstractUser(userId, doc.sizeUserList)
      doc.nextUser = userId
      doc.sizeUserList.$inc
      doc.save()
        user: userId
        
sendToNextUser = (currentNumber, callback) ->
  findUserByNumber currentNumber, (doc) ->
    Story
      .find()

findUserByNumber = (number, callback) ->
  User.findOne {'password.extraparams.phone': req.From}, (err, doc) ->
    if err
      throw new Error
    if doc
      callback(doc)
    return undefined
