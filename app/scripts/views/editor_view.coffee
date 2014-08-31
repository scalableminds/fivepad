### define
backbone : Backbone
ace/ace : Ace
lib/empty_theme : EmptyTheme
app : app
###


class EditorView extends Backbone.View

  className : "editor-view"

  initialize : ->
    @handleValueChange = _.debounce(@handleValueChange, 200)


  render : ->
    @$el.css(
      fontFamily : app.options.fontFamily
      fontSize : app.options.fontSize
      fontWeight : app.options.fontWeight
    )

    @editor = Ace.edit(@el)
    @editor.setTheme(EmptyTheme)
    @editor.getSession().setMode("ace/mode/markdown")
    @editor.renderer.setShowGutter(false)
    @editor.renderer.setShowPrintMargin(false)
    @editor.getSession().setUseWrapMode(true)
    @editor.getSession().on("change", @handleValueChange.bind(this))

    return this


  handleValueChange : ->
    @trigger("change", @editor.getSession().getValue(), this)
    return


  setValue : (value) ->
    @editor.getSession().setValue(value)
    return

  resize : ->
    @editor.resize()

  focus : ->
    @editor.focus()

