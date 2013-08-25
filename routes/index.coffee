routes =
	root:    require './root'
	debug:   require './debug'
	signup:  require './signup'
	login:   require './login'
	account: require './account'
	logout:  require './logout'
	http:    require './http'

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

module.exports = (app) ->
	app.routes = routes
	app.get  '/',        routes.root.init
	app.get  '/debug',   routes.debug
	app.get  '/signup',  routes.signup.init
	app.get  '/login',   routes.login.init
	app.post '/signup',  routes.signup.signup
	app.post '/login',   routes.login.login
	app.get  '/account', routes.account.init
	app.get  '/logout',  routes.logout.init
	# app.get  '/login/forgot',       require('./login/forgot').init
	# app.post '/login/forgot',       require('./login/forgot').send
	# app.get  '/login/reset',        require('./login/reset').init
	# app.get  '/login/reset/:token', require('./login/reset').init
	# app.post '/login/reset/:token', require('./login/reset').set
	app.get '*', routes.http.http404