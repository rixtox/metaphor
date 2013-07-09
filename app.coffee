coffee = require('connect-coffee-script')
stylus = require('stylus')

require('zappajs') ->
	@configure
		development: =>
			@enable  'force compile'
			@disable 'compress'
			@app.locals.pretty = true
		production:  =>
			@disable 'force compile'
			@enable  'compress'
			@app.locals.pretty = false

	@use 'logger'
		,coffee(
			src:   "src"
			dest:  "public"
			bare:  true
			force: @get 'force compile'
		)
		,stylus.middleware(
			src:      "src"
			dest:     "public"
			force:    @get 'force compile'
			compress: @get 'compress'
		)
		,'static'

	@get
		'/': -> @render 'index.jade',
			title:           'Metaphor - Article and topic manage system'
			description:     'Article and topic manage system'
			author:          'RixTox'
		'/templates/*': ->
			@render @request.params[0] + '.jade'