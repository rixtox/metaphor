mongoose = require 'mongoose'
Schema = mongoose.Schema
bcrypt = require 'bcrypt'
validator = require './validator'
utils = require '../lib/utils'
group = require './group'

SALT_WORK_FACTOR = 10

infoSchema = Schema
  firstname: 
    type: String
    validate: validator.name
  lastname: 
    type: String
    validate: validator.name
  middlename: 
    type: String
    validate: validator.name
  department: String
  grade: Number
  class: Number
  student_id: String
  birth: Date

infoSchema.pre 'validate', (next) ->
  @firstname = utils.firstCap @firstname if @firstname
  @lastname = utils.firstCap @lastname if @lastname
  @middlename = utils.firstCap @middlename if @middlename
  next()

userSchema = Schema
  username:
    type: String
    required: true
    validate: validator.username
    #unique: true
  password:
    type: String
    required: true
  email:
    type: String
    required: true
    validate: validator.email
    #unique: true
  group:
    type: String
    required: true
    validate: validator.group
  info: [infoSchema]

userSchema.pre 'save', (next) ->
  next() if not @isModified 'password'
  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) =>
    return next err if err
    bcrypt.hash @password, salt, (err, hash) =>
      return next err if err
      @password = hash
      next()

userSchema.methods = 
  comparePassword: (password, fn) ->
    bcrypt.compare password, @password, (err, isMatch) ->
      fn err or isMatch
  can: (verb) ->
    path = verb.split(' ').reverse()
    ret = group[@group]
    for i in path
      if ret
        ret = ret[i]
      else
        return false
    return !!ret

userModel = mongoose.model 'User', userSchema

userModel.__defineGetter__ 'current', ->
  @findOne

module.exports = userModel