### define
backbone : Backbone
lodash : _
hammer : Hammer
./panel_view : PanelView
models/note_model : NoteModel
###

SCREEN_XS_MAX = 767

class LayoutView extends Backbone.View

  className : "layout-view"

  template : """
    <a class="settings-button" href="/settings">&#9881;</a>
  """

  events :
    "click .settings-button" : "handleSettingsButtonClick"

  initialize : ->

    @collection = new Backbone.Collection(_.times(app.options.panelCount, (i) ->
      model = new NoteModel(id : i)
      model.fetch()
      return model
    ))

    @activeIndex = -1


  render : ->

    @$el.append(@template)

    @panels = @collection.map((model, i) ->
      new PanelView(model : model)
    )

    @panels.forEach((view) =>
      @$el.append(view.render().el)
    )

    if @panels.length > 0
      @setActive(0)

    Hammer(document.body).on("swiperight", =>
      if window.innerWidth <= SCREEN_XS_MAX and @activeIndex > 0
        app.router.navigate("/panel/#{@activeIndex - 1}", trigger : true)
    )
    Hammer(document.body).on("swipeleft", =>
      if window.innerWidth <= SCREEN_XS_MAX and @activeIndex < (app.options.panelCount - 1)
        app.router.navigate("/panel/#{@activeIndex + 1}", trigger : true)
    )

    return this


  setActive : (index) ->

    index = parseInt(index)
    if index == @activeIndex
      return

    if @activeIndex >= 0
      @panels[@activeIndex].deactivate()

    if index >= 0
      @panels[index].activate()

    @activeIndex = index
    return


  handleSettingsButtonClick : (event) ->

    event.preventDefault()
    app.router.navigate("/settings", trigger : true)

