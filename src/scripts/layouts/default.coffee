#######################################
### Some general UI pack related JS ###
#######################################

# Extend JS String with repeat method
String.prototype.repeat = (num) ->
	return new Array(num + 1).join @

(($) ->

	# Add segments to a slider
	$.fn.addSliderSegments = (amount) ->
		return @each ->
			segmentGap = 100 / (amount - 1) + '%'
			segment = '''
			<div class="ui-slider-segment" 
			style="margin-left: ' + 
			segmentGap + ';"><div>
			'''
			$(@).prepend segment.repeat amount - 2

	$ ->

		# Todo list
		$('.todo li').click ->
			$(@).toogleClass 'todo-done'

		# Custom Select
		$('select[name="herolist"]').selectpicker
			style: 'btn-primary'
			menuStyle: 'dropdown-inverse'

		# Tooltips
		$('[data-toggle=tooltip]')
		.tooltip 'show'

		# Tags Input
		$('.tagsinput').tagsInput()

		# jQuery UI Sliders
		$slider = $ '#slider'
		if $slider.length
			$slider.slider(
				min: 1
				max: 5
				value: 2
				orientation: 'horizontal'
				range: 'min'
			).addSliderSegments $slider
			.slider('option').max

		# Placeholders for input/textarea
		$('input, textarea').placeholder()

		# Pagination
		$('.pagination a').on 'click', ->
			$(@).parent().siblings('li')
			.removeClass('active')
			.end().addClass('active')
		$('.btn-group a').on 'click', ->
			$(@).siblings()
			.removeClass('active')
			.end().addClass 'active'

		# Disable fake links
		$('a[href="#fakelink"]').on 'click'
		, (e) ->
			e.preventDefault()

		# Switch
		$('[data-toggle="switch"]')
		.wrap('<div class="switch" />')
		.parent().bootstrapSwitch()

) jQuery