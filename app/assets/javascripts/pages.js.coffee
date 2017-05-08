# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('a#preview_tab[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    data = body: $('#page_body').val()
    $('#preview_area').html '<div class="fa fa-gear fa-spin"></div>'

    $.ajax
      url: '/preview'
      data: data
      type: 'POST'
      error: (jqXHR, textStatus, errorThrown) ->
        $('#preview_area').html "Unable to render preview"
      success: (data, textStatus, jqXHR) ->
        $('#preview_area').html data
