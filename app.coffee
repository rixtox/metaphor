express = require   'express'
app     = new        express()

require('./config')  app
require('./modules') app
require('./routes')  app

app.listen app.get  'port'

logger "Server is running at 
localhost:#{app.get 'port'}"
, 'success'