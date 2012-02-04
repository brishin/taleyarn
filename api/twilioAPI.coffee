conf = require('../conf')

exports.setup = (server, client, mongoose) ->
  mongoose.connect conf.db.host, conf.db.name, conf.db.port
  Story = mongoose.model('Story')
  Snippet = mongoose.model('Snippet')
  User = mongoose.model('User')

  # Twilio
  TwilioClient = require('twilio').Client
  client = new TwilioClient(conf.twilio.accountSID, 
    conf.twilio.authToken, conf.twilio.twHostname)
  phone = client.getPhoneNumber(conf.twilio.phoneNumber)

  phone.setup () ->
    console.log 'Twilio server up.'
    phone.on 'incomingSMS', (req, res) ->
      smsHandler(req, res)

smsHandler = (req, res) ->
  console.log('Received incoming SMS with text: ' + req.Body)
  console.log('From: ' + req.From)