#Story = mongoose.model('Story')
#Snippet = mongoose.model('Snippet')
#User = mongoose.model('User')

exports.setup = (server, client, conf) ->
  # Twilio
  TwilioClient = require('twilio').Client
  client = new TwilioClient(conf.twilio.accountSID, 
    conf.twilio.authToken, conf.twilio.twHostname)
  phone = client.getPhoneNumber(conf.twilio.phoneNumber)

  phone.setup () ->
    console.log 'Started.'
    phone.on 'incomingSMS', (req, res) ->
      console.log('Received incoming SMS with text: ' + req.Body)
      console.log('From: ' + req.From)