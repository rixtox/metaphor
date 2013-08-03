exports = module.exports = (validator, app) ->

  validator.addValidator = (newValid) ->
    for key, val of newValid
      regex = val.regex
      fn = val.fn
      msg = val.msg
      if regex?
        do (regex, msg) ->
          validator.Validator.prototype[key] = ->
            if not regex.test @str
              err = @msg
              if typeof msg == 'function'
                err = msg @str
              if typeof msg == 'string'
                err = @str + msg
              @error err
            return @
      else if typeof fn == 'function'
        do (fn, msg) ->
          validator.Validator.prototype[key] = ->
            if not fn.apply @
              err = @msg
              if typeof msg == 'function'
                err = msg @str
              if typeof msg == 'string'
                err = @str + msg
              @error err
            return @

  validator.addFilter = (newFilter, fn) ->
    if typeof newFilter == 'string'
      validator.Filter.prototype[newFilter] = fn
    else
      for key, val of newFilter
        console.log key, val
        validator.addFilter key, val

  validator.middleware = (req, res, next) ->
    req.addValidator = validator.addValidator
    req.addFilter = validator.addFilter
    next()

  validator.addValidator
    isUsername:
      regex: /^[a-zA-Z0-9\-\_]+$/
      msg: ' is not a valid username'
    isName:
      regex: /^[A-Za-z\ ]{0,30}$/
      msg: ' is not a name'
    isDisplayName:
      regex: /^[A-Za-z\ \-\_]{0,30}$/
      msg: ' is not a valid display name'
    isASCII: 
      regex: /^[\x00-\x7e]*$/
      msg: ' is not ASCII'
    isDepartment:
      fn: ->
        return @str in Object.keys app.get('userInfo').departments
      msg: ' is not in the department list'


  validator.addFilter
    toLowerCase: ->
      @modify @str.toLowerCase()
    toUpperCase: ->
      @modify @str.toUpperCase()
    capitalize: ->
      @modify @str.charAt(0).toUpperCase() + @str.slice(1)
    firstCap: ->
      split = @str.split ' '
      for val, i in split
        split[i] = val.charAt(0).toUpperCase() + val.toLowerCase().slice(1)
      @modify split.join ' '
