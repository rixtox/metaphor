# Set logger schemas and prefixs
console.log.setSchema
  workflowAdded: (msg) ->
    return ['Workflow:'.bold.cyan, 'Added'.green, msg]
  workflowEmit: (msg) ->
    return ['Workflow:'.bold.cyan, 'Emit'.blue, msg]
  workflowReceive: (msg) ->
    return ['Workflow:'.bold.cyan, 'Receive'.magenta, msg]
console.log.setPrefix
  workflowAdded: '\u271a'.cyan
  workflowEmit: '\u261e'.cyan
  workflowReceive: '\u261e'.cyan

exports = module.exports = (req, res) ->
  workflow = new (require('events').EventEmitter)()

  logging = req.app.get('env') == 'development'

  workflow.outcome =
    success: false
    errors: []
    errfor: {}

  workflow.hasErrors = ->
    if Object.keys(workflow.outcome.errors).length or
    Object.keys(workflow.outcome.errfor).length
      return true
    return false

  workflow.add = (works) ->
    for key, val of works
      task = ((key, val, args) ->
        return ->
          if logging
            console.log key, 'workflowEmit'
          result = val args...
          if logging and typeof result == 'string'
            console.log result, 'workflowReceive'
          switch typeof result
            when 'string'
              workflow.emit result
            when 'object'
              for k, v of result
                workflow.emit k, v
      ) key, val, arguments
      workflow.on key, task
      if logging
        console.log key, 'workflowAdded'

  if req and res
    workflow.on 'exception', (err) ->
      workflow.outcome.errors.push 'Exception: ' + err
      return workflow.emit 'response'

    workflow.on 'response', ->
      if workflow.outcome.redirect
        res.redirect workflow.outcome.redirect
      workflow.outcome.success = !workflow.hasErrors()
      res.send workflow.outcome

  return workflow