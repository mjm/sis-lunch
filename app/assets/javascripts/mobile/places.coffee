## Initialization
$(document).ready ->
  $('#places').bind 'pageAnimationEnd', (evt) ->
    if (evt.data.direction == 'in')
      updatePlaces()
  
## Private functions
updatePlaces = ->
  $.ajax
    url: '/places.json'
    dataType: 'json'
    success: (data) ->
      displayPlaces(data)

displayPlaces = (places) ->
  $places = $('#places ul')
  $places.children().remove()
  
  for place in places
    appendPlace place.place, $places

appendPlace = (place, $list) ->
  $li = $("<li class='place' data-id='#{place.id}'></li>")
  $a = $("<a href='#place'></a>")
  $li.append($a)
  
  $a.append("<small class='counter'>#{place.vote_total}</small>")
  $a.append(place.name)
  $a.append("<small>#{if place.walkable then 'Walking' else 'Driving'}</small>")
  
  $list.append($li)