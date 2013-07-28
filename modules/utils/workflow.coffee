exports = module.exports = (req, res) ->
	workflow = new events.EventEmitter

	workflow.outcome =
		success: false
		errors: []
		errfor: {}

	workflow.hasErrors = ->
		Object.keys(workflow.outcome.errors).length or
		Object.keys(workflow.outcome.errfor).length

	workflow.on 'exception', (err) ->
		workflow.outcome.errors.push 'Exception: ' + err
		return workflow.emit 'response'

	workflow.on 'response', ->
		workflow.outcome.success = !workflow.hasErrors()
		res.send workflow.outcome

	return workflow