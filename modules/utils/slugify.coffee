exports = module.exports = (text) ->
	return text
		.toLowerCase()
		.replace(/[^\w ]+/g, '')
		.replace /\ +/g, '-'