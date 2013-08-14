express = require 'express'

# Create application
app = new express()

# Configure app
require('./config') app

# Load schemas and modules
require('./modules') app

# Load Route Controllers
require('./routes') app

# Start application
app.listen app.get 'port'
console.log "Metaphor is running 
at localhost:#{app.get 'port'}"
, 'success'
