# Setup Dependencies
connect = require('connect')
express = require('express')
io = require('socket.io')
mongoose = require('mongoose')
mongooseAuth = require('mongoose-auth')
coffeeScript = require('coffee-script')
everyauth = require 'everyauth'
conf = require(__dirname + '/conf')

port = (conf.server.port or 8081)

everyauth.debug = true

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
  mongooseAuth.middleware
  server.use express.errorHandler

  # Setup MongooseAuth
  mongooseAuth.helpExpress
  auth = require(__dirname + '/auth')
  auth.setup()

  # Load Schema
  Schema = require __dirname + '/models/schema'

# Error setup
server.error (err, req, res, next) ->
  if err instanceof NotFound
    res.render '404.jade',
      locals:
        title: '404 - Not Found'
        description: ''
        author: ''
        analyticssiteid: conf.analytics.id
      status: 404
  else
    res.render '500.jade',
      locals: 
        title: 'The Server Encountered an Error'
        description: ''
        author: ''
        analyticssiteid: conf.analytics.id
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
require(__dirname + '/api/twilioAPI').setup()

# Routes
server.get '/', (req, res) ->
  res.render 'index.jade',
    locals:
      title: 'Title'
      analyticssiteid: conf.analytics.id

require(__dirname + '/api/rest')

# Route for logout
server.get '/logout', (req, res) ->
  req.logout
  res.redirect '/'

# Route for login
server.get '/login', (req, res) ->
  res.render 'login'
    locals:
      title: 'Login'
      analyticssiteid: conf.analytics.id

# Route for registering
server.get '/register', (req, res) ->
  res.render 'register'
    locals:
      title: 'Register'
      analyticssiteid: conf.analytics.id

# Route for login testing
server.get '/home', (req, res) ->
  res.render 'home'
    locals:
      title: 'Home'
      analyticssiteid: conf.analytics.id

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