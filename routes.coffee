ensureAuthenticated = (req, res, next) ->
	return next() if req.isAuthenticated()
	res.set 'X-Auth-Required', 'true'
	res.redirect '/login/?returnUrl='+ encodeURIComponent(req.originalUrl)

ensureAdmin = (req, res, next) ->
	return next() if req.user.canPlayRoleOf 'admin'
	res.redirect '/'

ensureAccount = (req, res, next) ->
	return next() if req.user.canPlayRoleOf 'account'
	res.redirect '/'

exports = module.exports = (passport) ->
	@get
		'/': require('./views/index').init
		'/signup': require('./views/signup/index').init

	@post
		'/signup': require('./views/signup/index').signup