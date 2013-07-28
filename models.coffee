exports = module.exports = (app, mongoose, passport) ->

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

	# Load Utilities
	require('./modules/util') app

	# Configure Passport
	require('./passport') app, passport

	# Load Route Controllers
	require('./routes').bind(@) passport