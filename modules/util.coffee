exports = module.exports = (app) ->
	app.util = {}

	app.util.email = require './utils/email'
	app.util.slugify = require './utils/slugify'
	app.util.Workflow = require './utils/workflow'
