exports = module.exports = (app) ->
  ########################################
  ###       Load Mongoose Schemas      ###
  ########################################

  # General Sub-docs Schemas
  require('./schema/Note') app
  require('./schema/Status') app
  require('./schema/StatusLog') app
  require('./schema/Category') app

  # User System Schemas
  require('./schema/User') app
  require('./schema/Admin') app
  require('./schema/AdminGroup') app
  require('./schema/Account') app

  ########################################
  ###     Load Application Modules     ###
  ########################################

  require('./utils') app
  require('./auth') app
  require('./validator') app
  require('./welcome')

  ########################################
  ###   Load Application Middlewares   ###
  ########################################

  require('./middleware') app
