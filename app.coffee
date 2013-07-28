zappa      = require 'zappajs'
express    = require 'zappajs/node_modules/express'
mongoStore = require('connect-mongo')(express)
coffee     = require 'connect-coffee-script'
stylus     = require 'stylus'
passport   = require 'passport'
path       = require 'path'
mongoose   = require 'mongoose'
trace      = require 'coffee-trace'

# Mongodb Connection URI
MONGODB_URI = process.env.MONGOLAB_URI or
	process.env.MONGOHQ_URL or
	'localhost/metaphor'

# Iitialize express server with zappa
zappa ->

	# Connect Mongodb with Mongoose
	@app.db = mongoose.createConnection MONGODB_URI
	@app.db.on 'error', (err) ->
		console.log err.message
	@app.db.once 'open', ->
		console.log 'mongoose open for business'

	# Load schemas and modules
	require('./models').apply @, [@app, mongoose, passport]

	# Configure server
	@disable 'x-powered-by'
	@configure
		development: =>
			@enable           'force compile'
			@disable          'compress'
			@app.locals.pretty = true
			@use              'errorHandler'
		production:  =>
			@disable          'force compile'
			@enable           'compress' 
			@app.locals.pretty = false
	@set
		'port'              : process.env.PORT or 3000
		'views'             : path.join __dirname, '/views'
		'view engine'       : 'jade'
		'strict routing'    : true
		'project-name'      : 'Metaphor'
		'company-name'      : 'Metacoder'
		'admin-email'       : 'me@rixtox.com'
		'email-from-name'   : 'Metacoder Website'
		'email-from-address': 'admin@sb.gy'
		'email-credentials' :
			user    : 'admin@sb.gy'
			password: '54c3'
			host    : 'smtp.live.com'
			ssl     : true

	# Use jade files
	@app.engine 'jade', require('jade').__express

	# Configure Middlewares
	@use
		logger: 'dev'
		favicon: path.join(__dirname, 'public/favicon.ico')
		,'bodyParser'
		,'methodOverride'
		,'cookieParser'
		,session:
			secret: '54c3'
			store: new mongoStore url: MONGODB_URI
		,coffee(
			src  : "src"
			dest : "public"
			bare : true
			force: @get 'force compile'
		)
		,stylus.middleware(
			src     : "src"
			dest    : "public"
			force   : @get 'force compile'
			compress: @get 'compress'
		)
		,passport.initialize()
		,passport.session()
		,static: path.join(__dirname, 'public')
		,require('./views/http/index').http500

	# Set locals
	@app.locals.site =
		name: @app.get 'project-name'