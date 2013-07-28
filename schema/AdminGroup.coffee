exports = module.exports = (app, mongoose) ->
	adminGroupSchema = new mongoose.Schema
		_id: String
		name:
			type: String
			default: ''
		permissions: [
			name: String
			permit: Boolean
		]
	adminGroupSchema.plugin require './plugins/pagedFind'
	adminGroupSchema.index {name: 1}, {unique: true}
	adminGroupSchema.set 'autoIndex', app.get 'env' == 'development'
	app.db.model 'AdminGroup', adminGroupSchema