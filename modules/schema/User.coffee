mongoose = require 'mongoose'
crypto = require 'crypto'

module.exports = (app) ->
  userSchema = new mongoose.Schema
    username:
      type: String
      unique: true
    password: String
    email: String
    roles:
      admin:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Admin'
      account:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Account'
    info:
      displayName: String
      firstName: String
      lastName: String
      department: String
      grade: String
      class: String
      mentor: String
      studentId: String
      birth: Date
    isActive: Boolean
    timeCreated:
      type: Date
      default: Date.now
    resetPasswordToken: String
    search: [String]

  userSchema.methods.canPlayRoleOf = (role) ->
    return true if role == 'admin' and @roles.admin
    return true if role == 'account' and @roles.account
    return false

  userSchema.methods.defaultReturnUrl = ->
    returnUrl = '/'
    returnUrl = '/account/' if @canPlayRoleOf 'account'
    returnUrl = '/admin/' if @canPlayRoleOf 'admin'
    return returnUrl

  userSchema.statics.encryptPassword = (password) ->
    return crypto.createHmac(
      'sha512', app.get('crypto-key')
    ).update(password).digest('hex')

  userSchema.plugin require './plugins/pagedFind'
  userSchema.index {username: 1}, {unique: true}
  userSchema.index email: 1
  userSchema.index timeCreated: 1
  userSchema.index resetPasswordToken: 1
  userSchema.index search: 1
  userSchema.set 'autoIndex', app.get 'env' == 'development'
  app.db.model 'User', userSchema