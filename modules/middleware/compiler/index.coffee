async = require 'async'
path = require 'path'

# TODO: add Etag cache support

compilers = [
  require './coffee'
  require './stylus'
]
env = source_uri = source_path = dest_path = ''

middleware = (req, res, next) ->
  unless req.path.indexOf source_uri == 0
    return next()
  file_ext = path.extname req.path
  file_uri = req.path.substr source_uri.length
  file_path = path.join source_path, file_uri
  file_dest_path = path.join dest_path, file_uri
  file_base_path = path.join path.dirname(file_path), path.basename(file_path, file_ext)
  async.map compilers, (compiler, callback) ->
    compiler
      uri_ext: file_ext
      file_base_path: file_base_path
      dest_path: file_dest_path
      env: env
      , callback
  , (err, results) ->
    return res.send err if err
    for result in results
      if result.exists
        return result.send res unless result.static
        return next()
    next()

module.exports = (app) ->
  env = app.get 'env' || 'development'
  source_uri = path.resolve app.get 'source-uri' || '/'
  source_path = path.resolve app.get 'source-path'
  if !source_path
    app_path = path.resolve app.get 'app-path'
    if !app_path
      throw new Error 'Compiler middleware needs source-path or app-path'
    source_path = path.resolve app_path, 'src'
  dest_path = path.resolve app.get 'dest-path' || path.join source_path 'build'
  return middleware
