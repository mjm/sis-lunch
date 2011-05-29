window.stylePlaces = ->
	$('#places .delete-button').button {
		icons:
			primary: "ui-icon-closethick"
		text: false
	}
	$('#places .vote-button').button {
		icons:
			primary: "ui-icon-check"
	}
	
window.styleAddForm = ->
	$('#add-place-form input[type=submit]').button {
		icons:
			primary: "ui-icon-plusthick"
	}

$(document).ready ->
	setInterval ->
		$('#places').load '/periodic', ->
			stylePlaces()
	, 2000
	
	$('#add-place').button({icons: {primary:"ui-icon-plusthick"}}).click ->
		$('#add-place-form').toggle()
	
	stylePlaces()
	styleAddForm()