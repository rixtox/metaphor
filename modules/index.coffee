exports = module.exports = (app, mongoose, validator) ->
  ########################################
  ###       Load Mongoose Schemas      ###
  ########################################

  # General Sub-docs Schemas
  require('./schema/Note') app, mongoose
  require('./schema/Status') app, mongoose
  require('./schema/StatusLog') app, mongoose
  require('./schema/Category') app, mongoose

  # User System Schemas
  require('./schema/User') app, mongoose
  require('./schema/Admin') app, mongoose
  require('./schema/AdminGroup') app, mongoose
  require('./schema/Account') app, mongoose

  ########################################
  ###     Load Application Modules     ###
  ########################################

  require('./utils') app
  require('./auth') app
  require('./validator') validator, app
  require './welcome'
