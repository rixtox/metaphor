###
Usage

workflow
  eventTrigger: (arg1, arg2, emit) ->
    if arg1
      # trigger next event without argument
      return 'event2'
    if arg2
      # trigger an event tree with arguments
      return
        event3: 'successed'
        event4: 'failed'
    if emit
      # just trigger an event without return
      emit 'event5', {option: 'something'}
###

exports = module.exports = (req, res) ->
  workflow = new (require('events').EventEmitter)()

  workflow.outcome =
    success: false
    errors: []
    errfor: {}

  workflow.add = (tasks) ->
    for key, fn of tasks
      task = (args...) ->
        args.push workflow.emit
        result = fn.apply null, args
        if typeof result == 'string'
          return workflow.emit result
        if typeof result == 'object'
          for key, val in result
            workflow.emit key, val
          return false
      workflow.on key, task

  workflow.hasErrors = ->
    if Object.keys(workflow.outcome.errors).length or
    Object.keys(workflow.outcome.errfor).length
      return true
    return false

  if req and res
    workflow.on 'exception', (err) ->
      workflow.outcome.errors.push 'Exception: ' + err
      return workflow.emit 'response'

    workflow.on 'response', ->
      workflow.outcome.success = !workflow.hasErrors()
      res.send workflow.outcome

  return workflow