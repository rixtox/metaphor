exports = module.exports = (req, res) ->
  # req.authenticate 'rix', '54c3', (err, user) ->
  #   req.login user, ->
      res.send [Object.keys(req), req.session, req.user]