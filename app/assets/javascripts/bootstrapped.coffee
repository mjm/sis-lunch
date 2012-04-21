window.updatePlaces = ->
  $.get '/periodic', (data) ->
    $('#places').html(data)

$(document).ready ->
  $('#container').tooltip
    selector: 'a[rel="tooltip"]',
    placement: 'right'
