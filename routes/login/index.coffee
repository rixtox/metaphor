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
        req.app.auth.prepare req.body
        if !req.body.username
          workflow.outcome.errfor.username = 'required'
        if !req.body.password
          workflow.outcome.errfor.password = 'required'
        if workflow.hasErrors()
          return 'response'
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
