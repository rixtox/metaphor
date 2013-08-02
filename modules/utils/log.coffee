##################################################
###              An useful logger              ###
##################################################
###
How to use
  You can use console.log everywhere with this ut-
  ility. Just pass a schema identifier at the end 
  of the arguments. The logger would select the s-
  chema and produce the formated string.
  You have to remember your message to be formated 
  must be the first argument in String.

Example
  console.log 'Server up and run'
    , {time: Date.now}
    , 'Good luck!'.red
    , 'success'
  # It will produce a log using 'success' schema
  # and 'success' prefix (a tick in default)

Register schema
  console.log.setSchema
    newSchema: (msg)
      doSomething msg
      return msg
    otherSchema: (msg)
      doOtherthing msg
      return msg
  # Alternatively:
  console.log.setSchema 'newSchema', (msg) ->
    doSomething msg
    return msg
  # If you return an Array, it will be sliced and
  # concated to the remain arguments passed to the
  # logger.

Register prefix
  console.log.setSchema
    newPrefix: '\u261e'.cyan
    otherPrefix: '\u261e'.cyan
  # Alternatively:
  console.log.setSchema 'newPrefix'
    , '\u261e'.cyan
###

require 'colors'
util = require 'util'

log = console.log
schemas =
  default: (msg) ->
    return msg
  error: (msg) ->
    regex = /^\s*Error:?\s*/i
    match = msg.match regex
    if regex.test msg
      msg = msg.replace regex, ''
    return ['Error:'.bold.red, msg]
  warn: (msg) ->
    regex = /^\s*Warn:?\s*/i
    match = msg.match(regex)
    if regex.test msg
      msg = msg.replace regex, ''
    return ['Warn:'.bold.yellow, msg]
  success: (msg) ->
    regex = /^\s*Success:?\s*/i
    match = msg.match(regex)
    if regex.test msg
      msg = msg.replace regex, ''
    return ['Success:'.bold.green, msg]

prefixs =
  default: '\u2603'.white
  error: '\u2718'.red
  warn: '\u2623'.yellow
  success: '\u2714'.green

logger = (msg, args...) ->
  schema = 'default'
  prefix = prefixs.default
  if typeof msg == 'string' and args.length
    tmp = args[args.length - 1]
    if typeof tmp == 'string' and schemas[tmp]
      schema = args.pop()
    if prefixs[schema]?
      prefix = prefixs[schema]
    msg = schemas[schema] msg, args
    if args? and args instanceof Array
      for val, i in args
        args[i] = util.inspect val
    if msg instanceof Array
      return log prefix, msg..., args...
  return log prefix, msg, args...

logger.setSchema = (key, val) ->
  if typeof key == 'object'
    for k, v of key
      do (k, v) ->
        schemas[k] = v
  else if typeof key == 'string'
    do (val) ->
      schemas[key] = val

logger.setPrefix = (key, val) ->
  if typeof key == 'object'
    for k, v of key
      do (k, v) ->
        prefixs[k] = v
  else if typeof key == 'string'
    do (val) ->
      prefixs[key] = val

console.log = exports = module.exports = logger
