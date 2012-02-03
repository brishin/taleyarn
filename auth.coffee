exports.setup = (conf, port) ->
  UserSchema = new Schema({})
  mongooseAuth = require 'mongoose-auth'

  UserSchema.plugin mongooseAuth,
    everymodule:
  	  everyauth:
  		  User: () ->
  		    return User
    facebook:
  	  everyauth:
  		  myHostname: 'http://localhost:' + port
  		  appId: conf.fb.appId
  		  appSecret: conf.fb.appSecret
  		  redirectPath: '/'
    twitter:
  	  everyauth:
  		  myHostname: 'http://localhost:' + port
  		  consumerKey: conf.twit.consumerKey
  		  consumerSecret: conf.twit.consumerSecret
  		  redirectPath: '/'
    password:
  	  loginWith: 'email'
  	  extraparams:
  		  phone: String
  		  name:
  			  first: String
  			  last: String
  		  email: String
  	  everyauth:
  		  getLoginPath: '/login'
  		  postLoginPath: '/login'
  		  loginView: 'login.jade'
  		  getRegisterPath: '/register'
  		  postRegisterPath: '/register'
  		  registerView: 'register.jade'
  		  loginSuccessRedirect: '/'
  		  registerSuccessRedirect: '/'
    github:
  	  everyauth:
  		  myHostname: 'http://localhost:' + port
  		  appId: conf.github.appId
  		  appSecret: conf.github.appSecret
  		  redirectPath: '/'
    instagram:
  	  everyauth:
  		  myHostname: 'http://localhost:' + port
  		  appId: conf.instagram.clientId
  		  appSecret: conf.instagram.clientSecret
  		  redirectPath: '/'
    google:
  	  everyauth:
  		  myHostname: 'http://localhost:' + port
  		  appId: conf.google.clientId
  		  appSecret: conf.google.clientSecret
  		  redirectPath: '/'
  		  scope: 'https://www.google.com/m8/feeds'

  mongoose.model 'User', UserSchema
  mongoose.connect conf.dbHost, conf.dbName, conf.dbPort

  User = mongoose.model 'User'