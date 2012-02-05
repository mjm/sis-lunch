window.jQT = new $.jQTouch
  formSelector: '.form'

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

updatePlacePage = (id) ->
  # clear out the existing page data
  $.ajax
    url: "/places/#{id}.json"
    dataType: "json"
    success: (data) ->
      displayPlace data.place

$(document).ready ->
  $(document).bind "ajaxBeforeSend", (elm, xhr) ->
    token = $('meta[name="csrf-token"]').attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token) if token

  $('#places .place').tap ->
    updatePlacePage $(this).attr('data-id')
  $('#add-place').bind 'pageAnimationStart', (evt) ->
    if evt.data.direction == 'in'
      $('#place_name').val ''
      $('#place_notes').val ''
      $('#place_walkable').removeAttr 'checked'
  $('#add-place .save').tap ->
    $('#add-place').submit()
  $('#add-place').bind 'submit', ->
    $.ajax
      url: $(this).attr('action')
      data: $(this).serializeArray()
      type: 'POST'
      dataType: 'json'
      success: (data) ->
        jQT.goBack()
        # refresh things
        # perhaps show the new place
    false