module.exports = (req, res) ->
  req.filter('name').firstCap()
  req.assert('email', 'valid email required').isEmail()
  req.assert('name').isName()
  req.assert('test').notEmpty()
  logger 'Validator Errors:'.cyan, req.validationErrors()
  res.send [Object.keys(req), req.query, req.validationErrors(), req.param('test')]