
#editor = ace.edit("editor")
#editor.getSession().setMode("ace/mode/markdown")

jQuery ->
  jQuery('.editor').ace({ theme: 'github', lang: 'markdown', width: '100%', indent: 2 })
  jQuery('.editor-meta select').change event, ->
    ace = jQuery(event.srcElement)
      .closest('.editor-container')
      .find('.editor')
      .data('ace')
    ace.editor.ace.getSession().setMode("ace/mode/#{event.srcElement.value}")
  jQuery('.initial-focus').focus()
