### define
backbone : Backbone
lib/codemirror : CodeMirror
app : app
###


class EditorView extends Backbone.View

  className : "editor-view"

  initialize : ->
    @handleValueChange = _.debounce(@handleValueChange, 500)


  render : ->

    if /android/i.test(window.navigator.userAgent)
      @editorTextArea = $("<textarea>", class : "fallback-textarea").appendTo(@el)
      @editorTextArea.on("input", =>
        @handleValueChange(null, { origin : "userinput" })
      )
      @editor = {
        getValue : =>
          return @editorTextArea.val()

        setValue : (value) =>
          @editorTextArea.val(value)
          return

        focus : =>
          @editorTextArea.focus()

        refresh : ->
      }

    else
      @editor = CodeMirror(@el, {
        mode : "markdown"
        theme : "empty"
        lineNumbers : false
        lineWrapping : true
        autoCloseBrackets: true
        extraKeys: {
          "Enter": "newlineAndIndentContinueMarkdownList"
          "Tab": "indentMore",
          "Shift-Tab": "indentLess"
          "Ctrl-Left": -> app.router.prevPanel()
          "Ctrl-Right": -> app.router.nextPanel()
        }
      })
      @editor.on("change", @handleValueChange.bind(this))

    return this


  handleValueChange : (editor, options) ->
    if options.origin != "setValue"
      @trigger("change", @editor.getValue(), this)
    return


  setValue : (value) ->
    @editor.setValue(value)
    return

  refresh : ->
    @editor.refresh()

  focus : ->
    @editor.focus()

