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

exports = module.exports = (app) ->
	app.get  '/',        require('./root').init
	app.get  '/debug',   require('./debug')
	app.get  '/signup',  require('./signup').init
	app.get  '/login',   require('./login').init
	app.post '/signup',  require('./signup').signup
	app.post '/login',   require('./login').login
	app.get  '/account', require('./account').init
	app.get  '/logout',  require('./logout').init
	# app.get  '/login/forgot',       require('./login/forgot').init
	# app.post '/login/forgot',       require('./login/forgot').send
	# app.get  '/login/reset',        require('./login/reset').init
	# app.get  '/login/reset/:token', require('./login/reset').init
	# app.post '/login/reset/:token', require('./login/reset').set
	app.get '*', require('./http').http404