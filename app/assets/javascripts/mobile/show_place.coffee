## Initialization
$(document).ready ->
  $('#places .place').live 'tap', ->
    updatePlacePage $(this).attr('data-id')
  $('#place .voteButton').tap ->
    voteForPlace $(this).data('place-id')
  $('#place .unvoteButton').tap ->
    removeVote $(this).data('vote-id')
      
## Private functions
getPlaceId = () ->
  $('#place').data('place-id')

updatePlacePage = (id) ->
  # clear out the existing page data
  $('#place').data('place-id', id)
  $.ajax
    url: "/places/#{id}.json"
    dataType: "json"
    success: (data) ->
      displayPlace data

appendVoteList = (container, votes, isCar) ->
  $list = $("<ul class='rounded'></ul>")
  for v in votes
    $list.append("<li>#{v.person.name}</li>")
  container.append($list)

displayPlace = (place) ->
  $page = $('#place')
  $page.find('.toolbar h1').html(place.name)
  $page.find('.notes').html(place.notes)
  
  if place.user_vote_id
    $('.voteButton', $page).hide()
    $('.unvoteButton', $page).show().data('vote-id', place.user_vote_id)
  else
    $('.voteButton', $page).show().data('place-id', place.id)
    $('.unvoteButton', $page).hide()

  $votes = $page.find('.votes')
  $votes.children().remove()
  if place.walkable
    $votes.append("<h2>Votes</h2>")
    appendVoteList $votes, place.votes, false
  else
    for c in place.cars
      if c.owner
        $votes.append("<h2>#{c.owner.name}'s Car</h2>")
      else
        $votes.append("<h2>No Car Chosen</h2>")
      appendVoteList $votes, c.votes, true

voteForPlace = (place) ->
  $.ajax
    url: '/votes.json'
    type: 'POST'
    data:
      place: place
    dataType: 'json'
    success: ->
      updatePlacePage(getPlaceId())

removeVote = (vote) ->
  $.ajax
    url: "/votes/#{vote}.json"
    type: 'DELETE'
    dataType: 'json'
    success: ->
      updatePlacePage(getPlaceId())