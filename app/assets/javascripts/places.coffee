$(document).ready ->
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
	
	setInterval ->
		$.get '/periodic', (data) ->
			$('#places')
				.trigger('beforeupdate')
				.html(data)
				.trigger('update')
	, 5000