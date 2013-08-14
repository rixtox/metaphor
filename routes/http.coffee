exports.http404 = (req, res) ->
  res.status 404
  if req.xhr
    res.send error: 'Resource not found.'
  else
    res.render 'http/404'

exports.http500 = (err, req, res, next) ->
  res.status 500
  if req.xhr
    res.send error: 'Something went wrong.'
  else
    logger err.stack
    res.render 'http/500'