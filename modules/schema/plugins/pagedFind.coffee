module.exports = (schema) ->
	schema.statics.pagedFind = (options, cb) ->
		options.filters = {} unless options.filters
		options.keys = '' unless options.keys
		options.limit = 20 unless options.limit
		options.page = 1 unless options.page
		options.sort = {} unless options.sort

		output =
			data: null
			pages:
				current: options.page
				prev: 0
				hasPrev: false
				next: 0
				hasNext: false
				total: 0
			items:
				begin: ((options.page * options.limit) - options.limit) + 1
				end: options.page * options.limit
				total: 0

		countResults = (callback) =>
			@count options.filters, (err, count) ->
				output.items.total = count
				callback null, 'done counting'

		getResults = (callback) =>
			query = @find options.filters, options.keys
			query.skip (options.pages - 1) * options.limit
			query.limit options.limit
			query.sort options.sort
			query.exec (err, result) ->
				output.data = result
				callback null, 'done getting records'

		require('async').parallel [
			countResults
			getResults
		],
		(err, result) ->
			cb err if err
			output.pages.total = Math.cell output.items.total / options.limit
			output.pages.next = ((output.pages.current + 1) > output.pages.total ? 0 : output.pages.current + 1)
			output.pages.hasNext = (output.pages.next != 0)
			output.pages.prev = output.pages.current - 1
			output.pages.hasPrev = (output.pages.prev != 0)
			if output.items.end > output.items.total
				output.items.end = output.items.total
			cb null, options