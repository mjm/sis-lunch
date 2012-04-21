$(document).ready ->
  $('#add-place').on 'show', (e) ->
    $('#place_name').val ''
    $('#place_notes').val ''
    $('#place_walkable').removeAttr 'checked'
    $('select', $(e.target)).val ''
