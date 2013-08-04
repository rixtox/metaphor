path = require 'path'

exports.db =
  'url': process.env.MONGOLAB_URI or
  process.env.MONGOHQ_URL or
  'localhost/metaphor'

exports.app =
  'port'              : process.env.PORT or 3000
  'views'             : path.join __dirname, '/views'
  'view engine'       : 'jade'
  'strict routing'    : true
  'project-name'      : 'Metaphor'
  'company-name'      : 'Metacoder'
  'admin-email'       : 'admin@example.com'
  'crypto-key'        : 'yoi3dfg8sen'
  'x-powered-by'      : false
  'email-from-name'   : 'Metacoder Website'
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