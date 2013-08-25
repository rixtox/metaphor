express    = require 'express'
mongoStore = require('connect-mongo') express
validator  = require 'express-validator'
compiler   = require './compiler'
path       = require 'path'

module.exports = (app) ->

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
  app.use compiler app
  app.use express.static app.get 'public-path'
  app.use express.favicon path.join app.get('public-path'), 'favicon.ico'
  app.use require('./slash')
  app.use app.router
  app.use require('../../routes/http').http500