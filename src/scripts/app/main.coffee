define [
  'jquery'
  'underscore'
  'backbone'
  'css!bs/styles/bootstrap'
  'css!styles/main'
  'css!styles/home/main'
  ],
($, _, Backbone) ->
	App.Views.Nav = Backbone.View.extend
		el: '#app-nav'
		initialize: ->
			@render()
		render: ->
			require ['text!tmpl/main/nav'], (tmpl) =>
				@$el.html _.template tmpl

	App.Views.Footer = Backbone.View.extend
		el: '#app-footer'
		initialize: ->
			@render()
		render: ->
			require ['text!tmpl/main/footer'], (tmpl) =>
				@$el.html _.template tmpl

	App.Views.Body = Backbone.View.extend
		el: '#app-body'
		render: (path) ->
			require ['text!tmpl/' + path], (tmpl) =>
				console.log path, tmpl
				@$el.html _.template tmpl

	appNav = new App.Views.Nav
	appBody = new App.Views.Body
	appFooter = new App.Views.Footer
	App.Router = Backbone.Router.extend
		routes:
			'': 'index',
			'register': 'register'

		index: ->
			appBody.render 'main/index'

		register: ->
			appBody.render 'main/register'

	appRouter = new App.Router

	Backbone.history.start
		pushState: true
		root: "/"