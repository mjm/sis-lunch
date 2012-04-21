hasStorage = ->
  try
    'localStorage' of window and window['localStorage'] isnt null
  catch e
    false

window.updatePlaces = ->
  params = {}
  if hasStorage()
    $('.place-cell').each ->
      id = @id.replace('place','')
      tab = localStorage["places.#{id}.tab"]
      if tab
        params[id] = tab

  $.get '/periodic', params, (data) ->
    $('#places').html(data)

selectStoredTabs = ->
  $('.place-cell').each ->
    id = @id.replace('place','')
    tab = localStorage["places.#{id}.tab"]
    if tab
      $("a[href='##{tab}']", this).tab('show')

$(document).ready ->
  $('#container').tooltip
    selector: 'a[rel="tooltip"]',
    placement: 'right'
  if hasStorage()
    $('#places').on 'shown', (e) ->
      cell = $(e.target).closest('.place-cell')
      placeId = cell.attr('id').replace('place','')
      tab = $(e.target).attr('href').replace('#','')
      localStorage["places.#{placeId}.tab"] = tab
    selectStoredTabs()

  setInterval updatePlaces, 10000
