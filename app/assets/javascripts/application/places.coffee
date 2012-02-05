blockUpdates = false

window.setUpdatesEnabled = (enable) ->
  blockUpdates = not enable
  
updatePlaces = ->
  if not blockUpdates
    $.get '/periodic', (data) ->
      $('#places')
        .trigger('beforeupdate')
        .html(data)
        .trigger('update') if not blockUpdates

$(document).ready ->
  $('#places').bind 'update', ->
    $(this).find('.vote-comment').qtip
      style:
        classes: 'ui-tooltip-light ui-tooltip-shadow ui-tooltip-rounded'
      events:
        show: ->
          blockUpdates = true
        hide: ->
          blockUpdates = false
          true # returning false causes problems
    
    $(this).find('.delete-button').button
      icons:
        primary: "ui-icon-closethick"
      text: false
    $(this).find('.edit-button').button
      icons:
        primary: "ui-icon-pencil"
    $(this).find('.vote-button').button
      icons:
        primary: "ui-icon-check"
    $(this).find('.unvote-button').button
      icons:
        primary: "ui-icon-close"
    $(this).find('.comment-button').button
      icons:
        primary: "ui-icon-comment"
      text: false

    $(this).find('.car-seats td').droppable
      hoverClass: 'ui-state-highlight'
      tolerance: 'pointer'
      accept: (draggable) ->
        draggable.attr('data-place') == $(this).attr('data-place')
      drop: (event, ui) ->
        $(this).find('ul').append(ui.draggable)
        ui.draggable.css('left', 0).css('top', 0)
        $.ajax '/votes/'+ui.draggable.attr('data-vote'),
          type: 'PUT'
          data:
            vote:
              car_id: $(this).attr('data-car')
		            
    $(this).find('.car-seats li.mine').draggable
      revert: 'invalid'
      start: ->
        blockUpdates = true
      stop: ->
        blockUpdates = false

  $('#places').trigger('update')

  setInterval updatePlaces, 5000