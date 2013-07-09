window.App =
	Models: {}
	Collections: {}
	Views: {}
	Router: {}

requirejs.config
	baseUrl: '../lib'
	paths:
		js: '../scripts'
		app: '../scripts/app'
		tmpl: '../templates'
		styles: '../styles'
		bs: '../bootstrap'
	shim:
		bootstrap:
			deps: ['jquery']
			exports: 'jquery'
	packages: [
		{
			name: 'css'
			location: 'require/css'
			main: 'css'
		}
	]

requirejs [
	'jquery'
	'underscore'
	'backbone'
	'bootstrap'
	], ($, _, Backbone) ->
		requirejs ['app/main']