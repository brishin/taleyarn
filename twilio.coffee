#Story = mongoose.model('Story')
#Snippet = mongoose.model('Snippet')
#User = mongoose.model('User')

exports.setup = (server) ->
  # Config
  TwilioClient = require('twilio').Client
  client = new TwilioClient(process.env.ACCOUNT_SID, 
    process.env.AUTH_TOKEN, process.env.TW_HOSTNAME)
  phone = client.getPhoneNumber(process.env.PHONE_NUMBER)

  phone.setup () ->
    phone.on 'incomingSms', (req, res) ->
      console.log('Received incoming SMS with text: ' + reqParams.Body)
      console.log('From: ' + reqParams.From)