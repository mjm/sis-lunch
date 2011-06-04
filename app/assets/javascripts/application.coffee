showMessage = (elem, message) ->
	elem.find('.message').text(message)
	elem.fadeIn().delay(3000).fadeOut().siblings().hide()

window.notice = (message) ->
	showMessage $('#messages .ui-state-highlight'), message

window.error = (message) ->
	showMessage $('#messages .ui-state-error'), message

createAddPlaceDialog = ->
	addDialog = $('#add-place-dialog')
	addForm = addDialog.find 'form'
	
	placeNameField = $('#place_name')
	walkingField = $('#place_walkable')
	submitButton = $('#add-place-dialog input[type=submit]')
	
	$('#add-place').button({icons: {primary:"ui-icon-plusthick"}}).click ->
		addDialog.dialog 'open'
		
	$('#add-place-dialog form').submit ->
		addDialog.dialog 'close'
		
	addDialog.dialog
		autoOpen: false
		modal: true
		title: 'Add a Place'
		resizable: false
		buttons:
			Add: ->
				addForm.submit()
		open: ->
			placeNameField.val ''
			walkingField.removeAttr 'checked'
			placeNameField.focus()
			
	submitButton.hide()
	
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
	setInterval ->
		$.get '/periodic', (data) ->
			$('#places')
				.trigger('beforeupdate')
				.html(data)
				.trigger('update')
	, 5000
	
	createAddPlaceDialog()
	
	options = $('#options')
	if options.size() > 0
		configureOptions options
		
	$('#places').bind 'update', ->
		$(this).find('.delete-button').button
			icons:
				primary: "ui-icon-closethick"
			text: false
		$(this).find('.vote-button').button
			icons:
				primary: "ui-icon-check"
		$(this).find('.unvote-button').button
			icons:
				primary: "ui-icon-close"
		
		$(this).find('.car-seats td').droppable
		    hoverClass: 'ui-state-highlight'
		    tolerance: 'pointer'
		    drop: (event, ui) ->
		        $(this).find('ul').append(ui.draggable)
		        ui.draggable.css('left', 0).css('top', 0)
		        $.ajax '/votes/'+ui.draggable.attr('data-vote'),
		            type: 'PUT'
		            data:
		                car_id: $(this).attr('data-car')
		            
		$(this).find('.car-seats li.mine').draggable
		    revert: 'invalid'

	$('#places').trigger('update')