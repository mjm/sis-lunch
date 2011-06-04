showMessage = (elem, message) ->
	elem.find('.message').text(message)
	elem.fadeIn().delay(3000).fadeOut().siblings().hide()

window.notice = (message) ->
	showMessage $('#messages .ui-state-highlight'), message

window.error = (message) ->
	showMessage $('#messages .ui-state-error'), message