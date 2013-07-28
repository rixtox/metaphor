exports = module.exports = (req, res, options) ->
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

		require('async').parallel renderers, (err, results) ->
			return options.error 'Email template render failed. ' +
				err if err

			attachements = []

			if options.html
				attachements.push
					data: options.html
					alternative: true

			if options.attachements
				for i in options.attachements
					attachements.push options.attachements[i]

			emailjs = require 'emailjs/email'
			emailer = emailjs.server.connect req.app.get 'email-credentials'

			emailer.send
				from: options.from
				to: options.to
				cc: options.cc
				bcc: options.bcc
				subject: options.subject
				text: options.text
				attachements: attachements
				, (err, message) ->
					return options.error 'Email failed to send. ' +
						err if err
					return options.sucess message
