nodemailer = require 'nodemailer'

exports = module.exports = (req, res, options, callback) ->
	smtpTransport = nodemailer.createTransport 'SMTP'
	, req.app.get 'email-credentials'

	renderText = (callback) ->
		res.render options.textPath
		, options.locals
		, (err, text) ->
			return callback err if err
			options.text = text
			return callback null, 'done'

	renderHtml = (callback) ->
		res.render options.htmlPath
		, options.locals
		, (err, html) ->
			return callback err if err
			options.html = html
			return callback null, 'done'

	renderers = []
	renderers.push renderText if options.textPath
	renderers.push renderHtml if options.htmlPath

	require('async').parallel renderers, (err, result) ->
		return callback "Email template render failed. #{err}" if err

		options.mail.text = options.text
		options.mail.html = options.html

		smtpTransport.sendMail options.mail, callback
