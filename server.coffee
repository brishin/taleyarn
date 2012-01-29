# Setup Dependencies
connect = require('connect')
express = require('express')
io = require('socket.io')
mongoose = require('mongoose')

# Twilio Config
TwilioClient = require('twilio').Client
client = new TwilioClient(process.env.ACCOUNT_SID, 
  process.env.AUTH_TOKEN, process.env.HOSTNAME)
phone = client.getPhoneNumber(process.env.PHONE_NUMBER)

# DB - host, database, port, options
mongoose.connect(process.env.DB_HOST, process.env.DB_NAME,
  process.env.DB_PORT)

port = (process.env.PORT or 8081)

# Setup Express
server = express.createServer()
server.configure ->
  server.set 'views', __dirname + '/views'
  server.use connect.bodyParser()
  server.use express.cookieParser()
  server.use express.session(secret: process.env.SECRET)
  server.use connect.static(__dirname + '/static')
  server.use server.router

#Setup the Errors
server.error (err, req, res, next) ->
  if err instanceof NotFound
    res.render '404.jade',
      locals:
        title: '404 - Not Found'
        description: ''
        author: ''
        analyticssiteid: 'XXXXXXX'
      status: 404
  else
    res.render '500.jade',
      locals: 
        title: 'The Server Encountered an Error'
        description: ''
        author: ''
        analyticssiteid: 'XXXXXXX'
        error: err
      status: 500
server.listen port

# Setup Socket.IO
io = io.listen(server)
io.sockets.on 'connection', (socket) ->
  console.log 'Client Connected'
  socket.on 'message', (data) ->
    socket.broadcast.emit 'server_message', data
    socket.emit 'server_message', data
  socket.on 'disconnect', ->
    console.log 'Client Disconnected.'

# Routes
server.get '/', (req, res) ->
  res.render 'index.jade',
    locals:
      title: 'Your Page Title'
      description: 'Your Page Description'
      author: 'Your Name'
      analyticssiteid: 'XXXXXXX'

# Route for 500 Error
server.get '/500', (req, res) ->
  throw new Error('This is a 500 Error')

#Route for 404 Route (Keep as last route.)
server.get '/*', (req, res) ->
  throw new NotFound

NotFound = (msg) ->
  @name = 'NotFound'
  Error.call this, msg
  Error.captureStackTrace this, arguments.callee