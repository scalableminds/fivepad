### define
backbone : Backbone
ace/ace : Ace
lib/empty_theme : EmptyTheme
###


class EditorView extends Backbone.View

  className : "editor-view"

  initialize : ->
    @handleValueChange = _.debounce(@handleValueChange, 200)


  render : ->
    @$el.css(
      fontFamily : "Source Code Pro"
      fontSize : "16pt"
      fontWeight : 300
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

