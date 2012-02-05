window.jQT = new $.jQTouch
  formSelector: '.form'

$(document).ready ->
  $(document).bind "ajaxBeforeSend", (elm, xhr) ->
    token = $('meta[name="csrf-token"]').attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token) if token