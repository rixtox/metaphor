bcrypt = require 'bcrypt'
SALT_WORK_FACTOR = 10

exports = module.exports = (app, mongoose) ->
	userSchema = new mongoose.Schema
		username:
			type: String
			unique: true
		password: String
		email: String
		roles:
			admin:
				type: mongoose.Schema.Types.ObjectId
				ref: 'Admin'
			account:
			 	type: mongoose.Schema.Types.ObjectId
			 	ref: 'Account'
		isActive: String
		timeCreated:
			type: Date
			default: Date.now
		resetPasswordToken: String
		search: [String]

	userSchema.methods.canPlayRoleOf = (role) ->
		return true if role == 'admin' and @role.admin
		return true if role == 'account' and @role.account
		return false

	userSchema.methods.defaultReturnUrl = ->
		returnUrl = '/'
		returnUrl = '/account/' if @canPlayRoleOf 'account'
		returnUrl = '/admin/' if @canPlayRoleOf 'admin'
		return returnUrl

	userSchema.statics.encryptPassword = (password, done) ->
		bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
			return done err if err
			bcrypt.hash password, salt, (err, hash) ->
				return done err if err
				return done null, hash

	userSchema.plugin require './plugins/pagedFind'
	userSchema.index {username: 1}, {unique: true}
	userSchema.index email: 1
	userSchema.index timeCreated: 1
	userSchema.index resetPasswordToken: 1
	userSchema.index search: 1
	userSchema.set 'autoIndex', app.get 'env' == 'development'
	app.db.model 'User', userSchema