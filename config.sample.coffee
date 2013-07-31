path = require 'path'

exports = module.exports =
    'port'              : process.env.PORT or 3000
    'views'             : path.join __dirname, '/views'
    'view engine'       : 'jade'
    'strict routing'    : true
    'project-name'      : 'Metaphor'
    'company-name'      : 'Metacoder'
    'admin-email'       : 'admin@example.com'
    'crypto-key'        : 'yoi3dfg8sen'
    'email-from-name'   : 'Metacoder Website'
    'email-from-address': 'admin@example.com'
    'email-credentials' :
      'user'    : 'admin'
      'password': 'password'
      'host'    : 'smtp.example.com'
      'port'    : 465
      'ssl'     : true