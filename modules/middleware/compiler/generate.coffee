fs = require 'fs'
path = require 'path'
async = require 'async'

production = (options, callback) ->
  if typeof options == 'function'
    callback = options
    options = {}
  fs.exists options.dest_path, (exists) ->
    return development options, callback unless exists && !options.compile
    callback null, exists: true, static: true

development = (options, callback) ->
  if typeof options == 'function'
    callback = options
    options = {}
  exts = options.file_ext
  if typeof exts == 'string'
    exts = [exts]
  file_paths = []
  for ext in exts
    file_paths.push options.file_base_path + ext
  async.detect file_paths, fs.exists, (file_path) ->
    return callback null, exists: false unless file_path
    fs.readFile file_path, 'utf8', (err, data) ->
      return callback err if err
      options.file_path = file_path
      options.compiler data.toString(), options, (err, result) ->
        return callback err if err
        if options.dest_path
          fs.mkdir path.dirname(options.dest_path), ->
            file = fs.createWriteStream options.dest_path
            file.on 'open', ->
              file.end result
        callback null, build_result result, exists: true, options

build_result = (data, info, options) ->
  if arguments.length == 2
    options = info
    info = {}
  retval = info
  retval.send = (res) ->
    res.set options.headers
    res.send data
  return retval

module.exports = (params) ->
  return (args, callback) ->
    if typeof args == 'function'
      callback = args
      args = {}
    unless params.uri_ext == args.uri_ext
      return callback null, exists: false
    options =
      env: args.env
      compile: args.compile || args.env != 'production'
      compress: args.compress || args.env == 'production'
      compiler: params.compiler
      headers: params.headers
      uri_ext: params.uri_ext
      file_ext: params.file_ext
      file_base_path: args.file_base_path
      dest_path: args.dest_path
    if options.env == 'production'
      production options, callback
    else
      development options, callback
