mongoose = require 'mongoose'

exports = module.exports = (app) ->
	noteSchema = new mongoose.Schema
		data:
			type: String
			default: ''
		userCreated:
			id:
				type: mongoose.Schema.Types.ObjectId
				ref: 'User'
			name:
				type: String
				default: ''
			time:
				type: Date
				default: Date.now
	app.db.model 'Note', noteSchema