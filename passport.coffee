LocalStrategy = require('passport-local').Strategy

exports = module.exports = (app, passport) ->
	passport.use new LocalStrategy (username, password, done) ->
		conditions = isActive: 'yes'
		if username.indexOf '@' == -1
			conditions.username = username
		else
			conditions.email = username
		app.db.models.User.findOne conditions, (err, user) ->
			return done err if err
			return done null, false, message: 'Unknown user' if !user

			app.db.models.User.encryptPassword password, (err, hash) ->
				return done null, user if user.password == hash
				return done null, false, message: 'Invalid password'

	passport.serializeUser (user, done) ->
		done null, user._id

	passport.deserializeUser (id, done) ->
		app.db.models.User.findOne(_id: id)
		.populate('roles.admin')
		.populate('roles.account')
		.exec (err, user) ->
			if user.roles and user.roles.admin
				user.roles.admin.populate 'groups', (err, admin) ->
					done err, user
			else
				done err, user
