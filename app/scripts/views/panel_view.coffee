### define
backbone : Backbone
mousetrap : Mousetrap
app : app
./editor_view : EditorView
###

SCREEN_XS_MAX = 767

class PanelView extends Backbone.View

  template : """
    <h2>
      <input type="text" class="title-input">
      <label class="title-label"></label>
    </h2>
    <div class="editor-view"></div>
  """

  className : "panel-view"

  events :
    "click" : "handleClick"
    "change input" : "handleChangeTitle"


  render : ->
    @$el.html(@template)
    @$el.addClass("number-#{@model.id}")
    @$el.css("background-color", app.options.colors[@model.id % app.options.colors.length])

    @updateTitle()

    @editorView = new EditorView(el : @$(".editor-view"))
    @editorView.render()
    @editorView.setValue(@model.get("contents"))

    @listenTo(@editorView, "change", (value) ->
      @model.set("contents", value)
    )

    @listenTo(this, "pageshow", ->
      @editorView.refresh()
    )

    @listenTo(@model, "reset", ->
      @editorView.setValue(@model.get("contents"))
      @updateTitle()
    )
    @listenTo(@model, "change:title", ->
      @updateTitle()
    )

    Mousetrap.bind(["command+#{@model.id + 1}", "ctrl+#{@model.id + 1}"], (event) =>
      event.preventDefault()
      app.router.navigate("/panel/#{@model.id}", trigger : true)
    )

    return this


  updateTitle : ->
    @$("input").val(@model.get("title"))
    @$("label").html(@model.get("title"))

  handleClick : ->
    app.router.navigate("/panel/#{@model.id}", trigger : true)


  handleChangeTitle : ->
    @model.set("title", @$("input").val())


  activate : ->
    @$el.addClass("active")
    @editorView.refresh()
    if window.innerWidth > SCREEN_XS_MAX
      @editorView.focus()


  deactivate : ->
    @$el.removeClass("active")
    @editorView.refresh()
