exports = module.exports =
  init: (req, res) ->
    infoSetting = req.app.get('userInfo')
    # Check if logged in
    if req.isAuthenticated()
      res.redirect req.session.defaultReturnUrl
    else
      res.render 'signup/index',
        info: infoSetting

  signup: (req, res) ->
    infoSetting = req.app.get('userInfo')
    workflow = new req.app.util.Workflow req, res
    workflow.add
      validate: ->
        req.check('username').notEmpty().isUsername()
        req.check('password').notEmpty()
        req.check('email').notEmpty().isEmail()
        req.check(['info', 'displayName']).isDisplayName()
        req.check(['info', 'firstName']).isName()
        req.check(['info', 'lastName']).isName()
        req.check(['info', 'mentor']).isName()
        req.check(['info', 'department']).isDepartment()
        req.check(['info', 'grade']).isInt()
          .min(infoSetting.grade.min)
          .max(infoSetting.grade.max)
        req.check(['info', 'class']).isInt()
          .min(infoSetting.class.min)
          .max(infoSetting.class.max)

        workflow.addErrFor req.validationErrors(true)
        if workflow.hasErrors()
          return 'response'
        return 'filter'

      filter: ->
        req.filter('username').toLowerCase()
        req.filter('email').toLowerCase()
        return 'duplicateUsernameCheck'

      duplicateUsernameCheck: ->
        req.app.db.models.User.findOne
          username: req.body.username
          , (err, user) ->
            if err
              return workflow.emit exception, err
            if user
              workflow.outcome.errfor.username = 'username already taken'
              return workflow.emit 'response'
            return workflow.emit 'duplicateEmailCheck'

      duplicateEmailCheck: ->
        req.app.db.models.User.findOne
          email: req.body.email
          , (err, user) ->
            if err
              return workflow.emit exception, err
            if user
              workflow.outcome.errfor.username = 'email already registered'
              return workflow.emit 'response'
            return workflow.emit 'createUser'

      createUser: ->
        filedsToSet =
          isActive: true
          username: req.body.username
          email: req.body.email
          password: req.app.db.models.User
            .encryptPassword req.body.password
          search: [
            req.body.username
            req.body.email
          ]
          info:
            displayName: req.body.info.displayName
            firstName: req.body.info.firstName
            lastName: req.body.info.lastName
            department: req.body.info.department
            grade: req.body.info.grade
            class: req.body.info.class
            mentor: req.body.info.mentor
        req.app.db.models.User.create filedsToSet, (err, user) ->
          if err
            return workflow.emit exception, err
          workflow.user = user
          return workflow.emit 'createAccount'

      createAccount: ->
        filedsToSet =
          'name.full': workflow.user.username
          user:
            id: workflow.user._id
            name: workflow.user.username
          search: [
            workflow.user.username
          ]
        req.app.db.models.Account.create filedsToSet, (err, account) ->
          if err
            return workflow.emit exception, err
          workflow.user.roles.account = account._id
          workflow.user.save (err, user) ->
            if err
              return workflow.emit exception, err
            return workflow.emit 'sendWelcomeEmail'

      sendWelcomeEmail: ->
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
            # return 'logUserIn'
          error: (err) ->
            console.log "Error Sending Welcome Email: #{err}", 'error'
            # return 'logUserIn'
        return 'logUserIn'

      logUserIn: ->
        req.authenticate req.body.username, req.body.password,
        (err, user) ->
          if err
            return workflow.emit 'exception', err
          else
            req.login user, ->
              workflow.outcome.redirect = user.defaultReturnUrl()
              return workflow.emit 'response'

    workflow.emit 'validate'
