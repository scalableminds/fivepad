### define
backbone : Backbone
lodash : _
hammer : Hammer
./panel_view : PanelView
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

    @activeIndex = -1


  render : ->

    @$el.append(@template)

    @panels = app.models.map((model, i) =>
      view = new PanelView(model : model)
      @$el.append(view.render().el)
      return view
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

