express    = require 'express'
mongoStore = require('connect-mongo') express
coffee     = require 'connect-coffee-script'
validator  = require 'express-validator'
stylus     = require 'stylus'
path       = require 'path'

exports = module.exports = (app) ->

  # Configure Middlewares
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use express.session
    secret: '54c3'
    store: new mongoStore
      url: app.get 'mongo-uri'
  app.use app.auth.init
  app.use validator.middleware
  app.use validator()
  app.use coffee
    src  : "src"
    dest : "public"
    bare : true
    force: app.get 'force compile'
  app.use stylus.middleware
    src     : "src"
    dest    : "public"
    force   : app.get 'force compile'
    compress: app.get 'compress'
  app.use express.static path.join __dirname
    , '../../public'
  app.use express.favicon path.join __dirname
    , '../../public/favicon.ico'
  app.use require('./slash')
  app.use app.router
  app.use require('../../routes/http').http500