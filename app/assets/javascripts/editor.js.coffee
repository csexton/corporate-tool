
#editor = ace.edit("editor")
#editor.getSession().setMode("ace/mode/markdown")

jQuery ->
  jQuery('.editor').ace({ theme: 'github', lang: 'markdown', width: '100%', indent: 2 })
  jQuery('.editor-meta select').change (event) ->
    ace = jQuery(event.srcElement)
      .closest('.editor-container')
      .find('.editor')
      .data('ace')
    ace.editor.ace.getSession().setMode("ace/mode/#{event.srcElement.value}")
  jQuery('.initial-focus').focus()

  # For the nested form.
  document.addEventListener "DOMNodeInserted", ((event) ->
    elementJustAdded = jQuery(event.target)
    if elementJustAdded.hasClass("fields")
      jQuery(".editor").ace
        lang: "markdown"
        indent: 2
        width: "100%"
        theme: "github"

      jQuery(event.srcElement).find(".editor-meta select").change (ev) ->
        ace = undefined
        ace = jQuery(ev.target).closest(".editor-container").find(".editor").data("ace")
        ace.editor.ace.getSession().setMode "ace/mode/" + ev.target.value

    return
  ), false
