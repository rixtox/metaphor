express    = require 'express'
mongoStore = require('connect-mongo') express
coffee     = require 'connect-coffee-script'
validator  = require 'express-validator'
stylus     = require 'stylus'
path       = require 'path'
mongoose   = require 'mongoose'
config     = require './config'

app = express()

# Connect Mongodb with Mongoose
app.db = mongoose.createConnection config.db.url

# Load schemas and modules
require('./modules') app, mongoose

for key, val of config.app
  app.set key, val

# Configure server
app.configure 'development', ->
  app.enable 'force compile'
  app.disable 'compress'
  app.locals.pretty = true
  app.use express.errorHandler()
app.configure 'production', ->
  app.disable 'force compile'
  app.enable 'compress' 
  app.locals.pretty = false

# Configure Middlewares
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.methodOverride()
app.use express.session
  secret: '54c3'
  store: new mongoStore url: config.db.url
app.use app.auth.init
# app.use validator
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
app.use express.static path.join(__dirname, 'public')
app.use require('./modules/middlewares/slash')
app.use app.router
app.use require('./routes/http').http500

# Set locals
app.locals.site =
  name: app.get 'project-name'

# Load Route Controllers
require('./routes') app

app.listen app.get 'port'
console.log "Metaphor is running at localhost:#{app.get 'port'}", 'success'
