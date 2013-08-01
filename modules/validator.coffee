Validator = require('express-validator').Validator

Validator.prototype.isName = ->
  if /^[A-Za-z\ ]{0,30}$/.test @str
    @error @msg or "#{@str} is not a name"
  return @

Validator.prototype.isDisplayName = ->
  if /^[A-Za-z\ \-\_]{0,30}$/.test @str
    @error @msg or "#{@str} is not a display name"
  return @

Validator.prototype.isASCII = ->
  if /[\x00-\x7e]/.test @str
    @error @msg or "#{@str} is not ASCII"
  return @


validators =
  ascii:       /[\x00-\x7e]/
  antiXSS:     /^[^\<\'\"\\\#\&\;\$\(\)\=\>\:\!\%\*\+\,\/\|\{\}\[\]]*$/
  username:    /^[a-zA-Z0-9\-\_]+$/
  displayName: /^[A-Za-z\ \-\_]{0,30}$/
  firstName:   /^[A-Za-z\ ]{0,30}$/
  middleName:  /^[A-Za-z\ ]{0,30}$/
  lastName:    /^[A-Za-z\ ]{0,30}$/
  email:       /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/i

schemas =
  default:
    all:
      regex: 'antiXSS'
  login:
    all:
      regex: 'antiXSS'
    username:
      required: true
      regex: ['ascii', 'username']
    password:
      required: true
      regex: 'password'

merge = (obj1, obj2) ->
  for key, val of obj2
    try
      if val.constructor == Object
        obj1[key] = merge obj1[key], val
      else
        obj1[key] = val
    catch e
      obj1[key] = val
  return obj1
    

validator = (info, schema = 'default') ->
  result = {}
  for key, val of info
    if validators[key]
      result[key] = validators[key].test val
    else
      result[key] = 'no validator'
  return result

validator.validators = validators

validator.addValidator = (newValid) ->
  merge validators, newValid

exports = module.exports = (app) ->
  if app
    app.validate = validator
  return validator