# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('textarea.inlineattachment').inlineattachment
    uploadUrl: '/uploads.json'
    extraParams:
      authenticity_token: $('meta[name="csrf-token"]').attr( 'content' )


