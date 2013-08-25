stylus = require 'stylus'
generate = require './generate'

uri_ext = '.css'
file_ext = '.styl'
headers =
  'Content-Type': 'text/css'

compiler = (data, options, callback) ->
  if typeof options == 'function'
    callback = options
    options = {}
  stylus_compiler = stylus(data)
  compile_options =
    filename: options.file_path
  if options.env == 'production'
    compile_options.compress = on
  for k, v of compile_options
    stylus_compiler.set k, v
  stylus_compiler.render callback

module.exports = generate
  uri_ext: uri_ext
  file_ext: file_ext
  compiler: compiler
  headers: headers