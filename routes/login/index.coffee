exports = module.exports =
	init: (req, res) ->
		# Check if logged in
		if req.isAuthenticated()
			res.redirect req.session.defaultReturnUrl
		else
			res.render 'login/index',
				returnUrl: req.query.returnUrl or '/'
				oauthMessage: ''

	login: (req, res) ->
		workflow = new req.app.util.Workflow req, res
		workflow.on 'validate', ->
				if !req.body.username
					workflow.outcome.errfor.username = 'required'
				if !req.body.password
					workflow.outcome.errfor.password = 'required'
				if workflow.hasErrors()
					return 'response'
				workflow.emit 'attenptLogin'

		workflow.on 'attenptLogin', ->
				req.authenticate req.body.username, req.body.password,
				(err, user) ->
					if err
						workflow.emit 'exception', err
					else
					  req.login user, ->
							workflow.outcome.redirect = user.defaultReturnUrl()
							workflow.emit 'response'
		workflow.emit 'validate'
