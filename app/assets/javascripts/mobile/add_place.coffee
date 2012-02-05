## Initialization
$(document).ready ->
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