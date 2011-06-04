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
	
$(document).ready ->
	createAddPlaceDialog()