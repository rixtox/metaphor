express = require 'express'
mongoose = require 'mongoose'
path = require 'path'

settings =
  'port'              : process.env.PORT or 
  'app-path'          : __dirname
  'dest-path'         : path.join __dirname, 'public'
  'public-path'       : path.join __dirname, 'public'
  'source-path'       : path.join __dirname, 'src'
  'source-uri'        : '/'
  'view engine'       : 'jade'
  'strict routing'    : true
  'mongo-uri'         : process.env.MONGOLAB_URI or
                        process.env.MONGOHQ_URL or
                        'localhost/metaphor'
  'project-name'      : 'Metaphor'
  'company-name'      : 'Metacoder'
  'admin-email'       : 'admin@example.com'
  'crypto-key'        : 'yoi3dfg8sen'
  'x-powered-by'      : false
  'email-from-name'   : 'Metaphor Admin'
  'email-from-address': 'admin@example.com'
  # SMTP Config for Nodemailer
  # See More on http://www.nodemailer.com/
  'email-credentials' :
    "auth":
      'user'    : 'admin'
      'pass'    : 'password'
    # "service"         : 'Gmail'
    'host'            : 'smtp.example.com'
    'port'            : 465
    'secureConnection': true
    "ignoreTLS"       : false
  'userInfo':
    'departments':
      'dp': 'Diploma Program'
      'alevel': 'Alevel'
      'ify': 'IFY'
      'myp': 'MYP'
      'pyp': 'PYP'
    'grade':
      'min': 1
      'max': 12
    'class':
      'min': 1
      'max': 20

module.exports = (app) ->
  # Add configuration to app
  for key, val of settings
    app.set key, val

  # Connect Mongodb with Mongoose
  app.db = mongoose.createConnection settings['mongo-uri']

  # Configure environments
  app.configure 'development', ->
    app.enable 'force compile'
    app.disable 'compress'
    app.locals.pretty = true
    app.use express.errorHandler()
  app.configure 'production', ->
    app.disable 'force compile'
    app.enable 'compress' 
    app.locals.pretty = false

  # Set locals
  app.locals.app = app
  app.locals.site =
    name: app.get 'project-name'
