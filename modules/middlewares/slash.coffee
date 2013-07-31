exports = module.exports = (req, res, next) ->
	if req.url.substr(-1) == '/' and req.url.length > 1
		res.redirect 301, req.url.slice(0, -1)
	else
		next()