mongoose = require 'mongoose'

exports = module.exports = (app) ->
	adminSchema = new mongoose.Schema
		user:
			id:
				type: mongoose.Schema.Types.ObjectId
				ref: 'User'
		name:
			full:
				type: String
				default: ''
			first:
				type: String
				default: ''
			middle:
				type: String
				default: ''
			last:
				type: String
				default: ''
		groups: [
			type: String
			ref: 'AdminGroup'
		]
		permissions: [
			name: String
			permit: Boolean
		]
		timeCreated:
			type: Date
			default: Date.now
		search: [String]

	adminSchema.methods.hasPermissionTo = (something) ->
		# check group permissions
		groupHasPermission = false
		for i in @groups
			for j in @groups[i].permissions
				if @groups[i].permissions[j].name == something and
				@groups[i].permissions[j].permit
					groupHasPermission = true

		# check admin permissions
		for i in @permissions
			if @permissions[i].name == something
				return true if @permissions[i].permit
				return false

		return groupHasPermission

	adminSchema.methods.isMemberOf = (group) ->
		for i in @groups
			return true if @groups[i]._id == group
		return false

	adminSchema.plugin require './plugins/pagedFind'
	adminSchema.index 'user.id': 1
	adminSchema.index search: 1
	adminSchema.set 'autoIndex', app.get 'env' == 'development'
	app.db.model 'Admin', adminSchema