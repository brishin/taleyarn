mongoose = require('mongoose')
conf = require('../conf')

exports.setup = () ->
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
    console.log 'Twilio server up at ' + conf.twilio.twHostname
    phone.on 'incomingSMS', (req, res) ->
      console.log('Received incoming SMS with text: ' + req.Body)
      console.log('From: ' + req.From)