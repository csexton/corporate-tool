/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(function() {
  $('textarea.inlineattachment').inlineattachment({
    uploadUrl: '/uploads.json',
    extraParams: {
      authenticity_token: $('meta[name="csrf-token"]').attr( 'content' )
    }
  });

  $('#upload_link').click(function(event){
    $('#upload_file').trigger("click");
    return event.preventDefault();
  });
  $(document).on('change','#upload_file', () => $('form#new_upload').submit());

  // Callback for the iframe upload
  return window.handle_iframe_upload = function(details){
    const textarea = $('#page_body');
    return textarea.val(textarea.val() + '\n\n' + details);
  };
});


