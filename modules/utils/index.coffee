exports = module.exports = (app) ->
  app.util = {}

  app.util.log      = require './log'
  app.util.email    = require './email'
  app.util.slugify  = require './slugify'
  app.util.Workflow = require './workflow'
  app.util.string   = require './string'