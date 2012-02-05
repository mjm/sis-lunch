configureOptions = (options) ->
	hasCarField = $('#has_car')
	seatsSpan = $('#seat_count')
	seatsField = $('#car_seats')
	buttons = options.find('input:submit')
	
	if !hasCarField.attr('checked')
		seatsSpan.hide();
	
	hasCarField.change ->
		if hasCarField.attr('checked')
			if seatsField.val() is ''
				seatsField.val(5)
			seatsSpan.show()
			seatsField.focus()
		else
			seatsSpan.hide()
			
	buttons.button()
	
$(document).ready ->
	options = $('#options')
	if options.size() > 0
		configureOptions options