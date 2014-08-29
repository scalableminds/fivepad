### define
backbone : Backbone
ace/ace : Ace
lib/empty_theme : EmptyTheme
###


class EditorView extends Backbone.View

  className : "editor-view"

  initialize : ->
    @handleChange = _.debounce(@handleChange, 200)

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
    @editor.getSession().on("change", @handleChange.bind(this))

    @editor.getSession().setValue(
      window.localStorage.getItem("editor-content-1")
    )


    return this


  handleChange : ->

    window.localStorage.setItem("editor-content-1", @editor.getSession().getValue())

