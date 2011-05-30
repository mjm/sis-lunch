window.stylePlaces = ->
	$('#places .delete-button').button
		icons:
			primary: "ui-icon-closethick"
		text: false
	$('#places .vote-button').button
		icons:
			primary: "ui-icon-check"
			
createAddPlaceDialog = ->
	addDialog = $('#add-place-dialog')
	addForm = addDialog.children 'form'
	
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
		$('#places').load '/periodic', ->
			stylePlaces()
	, 2000
	
	createAddPlaceDialog()
	
	options = $('#options')
	if options.size() > 0
		configureOptions options
	
	stylePlaces()