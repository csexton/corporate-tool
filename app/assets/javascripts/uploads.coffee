# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('textarea.inlineattachment').inlineattachment
    uploadUrl: '/uploads.json'
    extraParams:
      authenticity_token: $('meta[name="csrf-token"]').attr( 'content' )

  $('#upload_link').click (event)->
    $('#upload_file').trigger("click")
    event.preventDefault()
  $(document).on 'change','#upload_file', ()->
    $('form#new_upload').submit()

  # Callback for the iframe upload
  window.handle_iframe_upload = (details)->
    textarea = $('#page_body')
    textarea.val(textarea.val() + '\n\n' + details)

