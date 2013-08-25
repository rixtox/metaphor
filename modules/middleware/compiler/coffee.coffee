coffee = require 'coffee-script'
UglifyJS = require 'uglify-js'
generate = require './generate'

uri_ext = '.js'
file_ext = ['.coffee', '.cs']
headers =
  'Content-Type': 'application/javascript'

compiler = (data, options, callback) ->
  if typeof options == 'function'
    callback = options
    options = {}
  try
    compiled_js = coffee.compile data, bare: on
  catch {location, message}
    if location?
      message = "Error on line #{location.first_line + 1}: #{message}"
    return callback message
  if options.env == 'production' || options.compress
    compiled_js = UglifyJS.minify(compiled_js, fromString: true).code
  return callback null, compiled_js

module.exports = generate
  uri_ext: uri_ext
  file_ext: file_ext
  compiler: compiler
  headers: headers