exports = module.exports = (app) ->
  app.auth = auth =
    authenticate: (username, password, fn) ->
      conditions = isActive: 'yes'
      if username.indexOf '@' == -1
        conditions.username = username
      else
        conditions.email = username
      app.db.models.User.findOne conditions, (err, user) ->
        return fn err if err
        return fn 'Unknown user' if !user
        hash = app.db.models.User.encryptPassword password
        if user.password == hash
          return fn null, user
        else
          return fn 'Invalid password'
  auth.init = (req, res, next) ->
    req.isAuthenticated = ->
      return true if req.session.user
      return false
    req.authenticate = auth.authenticate
    req.user = req.app.locals.user = req.session.user
    req.login = (user, fn) ->
      req.session.user = user
      req.session.defaultReturnUrl = user.defaultReturnUrl()
      fn()
    req.logout = ->
      req.session.destroy ->
        res.redirect '/'
    next()
  return auth