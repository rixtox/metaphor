exports = module.exports =
	init: (req, res) ->
		# Check if logged in
		if req.isAuthenticated()
			res.redirect req.user.defaultReturnUrl()
		else
			res.render 'signup/index',
				oauthMessage: ''

	signup: (req, res) ->
		workflow = new req.app.util.Workflow req, res
		workflow.on 'validate', ->
			if !req.body.username
				workflow.outcome.errfor.username = 'required'
			else if ! /^[a-zA-Z0-9\-\_]+$/.test req.body.username
				workflow.outcome.errfor.username = 'only use letters, numbers, \'-\', \'_\''
			if !req.body.email
				workflow.outcome.errfor.email = 'required'
			else if !/^[a-zA-Z0-9\-\_\.\+]+@[a-zA-Z0-9\-\_\.]+\.[a-zA-Z0-9\-\_]+$/.test req.body.email
				workflow.outcome.errfor.email = 'invalid email format'
			if !req.body.password
				workflow.outcome.errfor.password = 'required'
			if workflow.hasErrors()
				return workflow.emit 'response'
			workflow.emit 'duplicateUsernameCheck'

		workflow.on 'duplicateUsernameCheck', ->
			req.app.db.models.User.findOne
				username: req.body.username
				, (err, user) ->
					if err
						return workflow.emit 'exception', err
					if user
						workflow.outcome.errfor.username = 'username already taken'
						return workflow.emit 'response'
					workflow.emit 'duplicateEmailCheck'

		workflow.on 'duplicateEmailCheck', ->
			req.app.db.models.User.findOne
				email: req.body.email
				, (err, user) ->
					if err
						return workflow.emit 'exception', err
					if user
						workflow.outcome.errfor.username = 'email already registered'
						return workflow.emit 'response'
					workflow.emit 'createUser'

		workflow.on 'createUser', ->
			filedsToSet =
				isActive: 'yes'
				username: req.body.username
				email: req.body.email
				password: req.app.db.models.User
					.encryptPassword req.body.password
				search: [
					req.body.username
					req.body.email
				]
			req.app.db.models.User.create filedsToSet, (err, user) ->
				if err
					return workflow.emit 'exception', err
				workflow.user = user
				workflow.emit 'createAccount'

		workflow.on 'createAccount', ->
			filedsToSet =
				'name.full': workflow.user.username
				user:
					id: workflow.user._id
					name: workflow.user.username
				search: [
					workflow.user.username
				]
			req.app.db.models.Account.create filedsToSet, (err, user) ->
				if err
					return workflow.emit 'exception', err
				workflow.user.roles.account = account._id
				workflow.user.save (err, user) ->
					if err
						return workflow.emit 'exception', err
					workflow.emit 'sendWelcomeEmail'

		workflow.on 'sendWelcomeEmail', ->
			req.app.util.email req, res,
				from: "#{req.app.get('email-from-name')} <#{req.app.get('email-from-address')}>"
				to: req.body.email
				subject: "Your #{req.app.get('project-name')} Account"
				textPath: 'signup/email-text'
				htmlPath: 'signup/email-html'
				locals:
					username: req.body.username
					email: req.body.email
					loginURL: "http://#{req.headers.host}/login/"
					projectName: req.app.get 'project-name'
				success: (message) ->
					workflow.emit 'logUserIn'
				error: (err) ->
					console.log "Error Sending Welcome Email: #{err}"
					workflow.emit 'logUserIn'

		workflow.on 'logUserIn', ->
			req._passport.instance.authenticate('local', (err, user, info) ->
				if err
					return workflow.emit 'exception', err
				if !user
					workflow.outcome.errors.push 'Login failed. That is strange.'
					return workflow.emit 'response'
				else
					req.login user (err) ->
						if err
							return workflow.emit 'exception', err
						workflow.outcome.defaultReturnUrl = user.defaultReturnUrl()
						workflow.emit 'response'
			) req, res

		workflow.emit 'validate'