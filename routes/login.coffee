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
    workflow.add
      validate: ->
        req.check('username').notEmpty().isUsername()
        req.check('password').notEmpty()
        req.check('email').notEmpty().isEmail()

        workflow.addErrFor req.validationErrors(true)
        if workflow.hasErrors()
          return 'response'
        return 'filter'

      filter: ->
        req.filter('username').toLowerCase()
        req.filter('email').toLowerCase()
        return 'attenptLogin'

      attenptLogin: ->
        req.authenticate req.body.username,
        req.body.password, (err, user) ->
          if err
            return workflow.emit 'exception', err
          else
            req.login user, ->
              workflow.outcome.redirect = user.defaultReturnUrl()
              return workflow.emit 'response'
        
    workflow.emit 'validate'
