### define
backbone : Backbone
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


  initialize : (options) ->
    @number = options.number


  render : ->
    @$el.html(@template(number : @number))
    @$el.addClass("number-#{@number}")
    @$el.css("background-color", app.options.colors[@number])

    @$("input").val(
      window.localStorage.getItem("title-#{@number}")
    )
    @$("label").html(
      window.localStorage.getItem("title-#{@number}")
    )

    @editorView = new EditorView(el : @$(".editor-view"), number : @number)
    @editorView.render()

    @editorView.setValue(
      window.localStorage.getItem("editor-content-#{@number}")
    )

    @listenTo(@editorView, "change", (value) ->
      window.localStorage.setItem(
        "editor-content-#{@number}",
        value
      )
    )

    return this


  handleClick : ->
    app.router.navigate("/panel/#{@number}", trigger : true)


  handleChangeTitle : ->
    window.localStorage.setItem(
      "title-#{@number}",
      @$("input").val()
    )
    @$("label").html(
      window.localStorage.getItem("title-#{@number}")
    )

  activate : ->
    @$el.addClass("active")
    @editorView.resize()
    @editorView.focus()


  deactivate : ->
    @$el.removeClass("active")
    @editorView.resize()
