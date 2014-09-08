### define
backbone : Backbone
mousetrap : Mousetrap
app : app
./editor_view : EditorView
###

class PanelView extends Backbone.View

  template : _.template("""
    <h2>
      <input type="text" class="title-input">
      <label class="title-label"></label>
    </h2>
    <div class="editor-view"></div>
  """)

  className : "panel-view"

  events :
    "click" : "handleClick"
    "change input" : "handleChangeTitle"


  render : ->
    @$el.html(@template())
    @$el.addClass("number-#{@model.id}")
    @$el.css("background-color", app.options.colors[@model.id])

    @$("input").val(@model.get("title"))
    @$("label").html(@model.get("title"))

    @editorView = new EditorView(el : @$(".editor-view"))
    @editorView.render()
    @editorView.setValue(@model.get("contents"))

    @listenTo(@editorView, "change", (value) ->
      @model.save("contents", value)
    )

    Mousetrap.bind(["command+#{@model.id + 1}", "ctrl+#{@model.id + 1}"], (event) =>
      event.preventDefault()
      app.router.navigate("/panel/#{@model.id}", trigger : true)
    )

    return this


  handleClick : ->
    app.router.navigate("/panel/#{@model.id}", trigger : true)


  handleChangeTitle : ->
    @model.save("title", @$("input").val())
    @$("label").html(@model.get("title"))

  activate : ->
    @$el.addClass("active")
    @editorView.resize()
    @editorView.focus()


  deactivate : ->
    @$el.removeClass("active")
    @editorView.resize()
