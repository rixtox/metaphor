group = require './group'
module.exports =
	username: (val) ->
		/^[a-zA-Z0-9]+$/.test val
	name: (val) ->
		/^[A-Z][A-Za-z]{0,29}$/.test val
	email: (val) ->
		/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/i.test val
	group: (val) ->
		group[val]