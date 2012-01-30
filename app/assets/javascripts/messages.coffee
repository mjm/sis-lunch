messageQueue = []
showingMessage = false

showNextMessage = ->
	if messageQueue.length == 0
		showingMessage = false
	else
		showingMessage = true
		message = messageQueue.shift()
		message.element.find('.message').text(message.text)
		message.element.fadeIn().delay(3000).fadeOut().siblings().hide()
		setTimeout showNextMessage, 4000

showMessage = (elem, message) ->
	messageQueue.push element: elem, text: message
	if not showingMessage
		showNextMessage()

window.notice = (message) ->
	showMessage $('#messages .ui-state-highlight'), message

window.error = (message) ->
	showMessage $('#messages .ui-state-error'), message