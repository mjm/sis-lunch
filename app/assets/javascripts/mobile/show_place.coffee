## Initialization
$(document).ready ->
  $('#places .place').live 'tap', ->
    updatePlacePage $(this).attr('data-id')
      
## Private functions
updatePlacePage = (id) ->
  # clear out the existing page data
  $.ajax
    url: "/places/#{id}.json"
    dataType: "json"
    success: (data) ->
      displayPlace data.place

appendVoteList = (container, votes) ->
  $list = $("<ul class='rounded'></ul>")
  for v in votes
    $list.append("<li>#{v.person.name}</li>")
  container.append($list)

displayPlace = (place) ->
  $page = $('#place')
  $page.find('.toolbar h1').html(place.name)
  $page.find('.notes').html(place.notes)

  $votes = $page.find('.votes')
  $votes.children().remove()
  if place.walkable
    $votes.append("<h2>Votes</h2>")
    appendVoteList $votes, place.votes
  else
    for c in place.cars
      if c.owner
        $votes.append("<h2>#{c.owner.name}'s Car</h2>")
      else
        $votes.append("<h2>No Car Chosen</h2>")
      appendVoteList $votes, c.votes