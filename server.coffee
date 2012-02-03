# Setup Dependencies
connect = require('connect')
express = require('express')
io = require('socket.io')
mongoose = require('mongoose')
mongooseAuth = require('mongoose-auth')
coffeeScript = require('coffee-script')
conf = require(__dirname + '/conf')

port = (conf.server.port or 8081)

# Setup Express
server = express.createServer()
server.configure ->
  server.set 'views', __dirname + '/views'
  server.use connect.bodyParser()
  server.use express.cookieParser()
  server.use express.session(secret: conf.server.secret)
  server.use server.router

server.configure 'development', ->
  server.use connect.static(__dirname + '/static')
  server.use express.errorHandler
    dumpExceptions: true
    showStack: true

server.configure 'production', ->
  # DB - host, database, port, options
  mongoose.connect(conf.db.host, conf.db.name, conf.db.port)
  server.use mongooseAuth.middleware
  server.use express.errorHandler

# Setup MongooseAuth
mongooseAuth.helpExpress
auth = require(__dirname + '/auth')
auth.setup conf, port

# Error setup
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
  socket.on 'message', (data) ->
    socket.emit 'server_message', data
  socket.on 'list', () ->
    socket.emit ''

# Twilio
twilioAPI = require(__dirname + '/api/twilio')
twilioAPI.setdown()

# Routes
server.get '/', (req, res) ->
  res.render 'index.jade',
    locals:
      title: 'Title'
      analyticssiteid: 'XXXXXXX'

# require(__dirname + './api')

# Route for logout
server.get '/logout', (req, res) ->
  req.logout
  res.redirect '/'

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