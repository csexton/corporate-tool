
#editor = ace.edit("editor")
#editor.getSession().setMode("ace/mode/markdown")

$ ->
  $('.editor').ace({ theme: 'github', lang: 'markdown', width: '100%', indent: 2 })
  $('.editor-meta select').change event, ->
    ace = $(event.srcElement)
      .closest('.editor-container')
      .find('.editor')
      .data('ace')
    ace.editor.ace.getSession().setMode("ace/mode/#{event.srcElement.value}")
  $('.initial-focus').focus()
