/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(function() {
  $('a#preview_tab[data-toggle="tab"]').on('shown.bs.tab', function(e) {
    const data = {body: $('#page_body').val()};
    $('#preview_area').html('<div class="fa fa-gear fa-spin"></div>');

    return $.ajax({
      url: '/preview',
      data,
      type: 'POST',
      error(jqXHR, textStatus, errorThrown) {
        return $('#preview_area').html("Unable to render preview");
      },
      success(data, textStatus, jqXHR) {
        return $('#preview_area').html(data);
      }
    });
  });

  return $('h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]').each((index, element) => {
    const anchor = "#" + $(element).attr("id");
    const text = '<i class="fa fa-link" aria-hidden="true"></i>';
    const link = '<a class="anchor" href="'+anchor+'">'+text+'</a>';
    return $(element).append(link);
  });
});

