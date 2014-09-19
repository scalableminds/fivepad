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

    @editor = CodeMirror(@el, {
      mode : "markdown"
      theme : "empty"
      lineNumbers : false
      lineWrapping : true
      viewportMargin : Infinity
      extraKeys: {
        "Enter": "newlineAndIndentContinueMarkdownList"
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

