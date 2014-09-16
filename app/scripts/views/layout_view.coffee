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
    <a class="settings-button" href="/settings"><span class="connection-label">Offline</span> &#9881;</a>
  """

  events :
    "click .settings-button" : "handleSettingsButtonClick"

  initialize : ->

    @activeIndex = -1


  render : ->

    @$el.append(@template)

    @panelViews = app.models.map((model, i) =>
      view = new PanelView(model : model)
      @$el.append(view.render().el)
      return view
    )

    if @panelViews.length > 0
      @setActive(0)

    Hammer(document.body).on("swiperight", =>
      if window.innerWidth <= SCREEN_XS_MAX and @activeIndex > 0
        app.router.navigate("/panel/#{@activeIndex - 1}", trigger : true)
    )
    Hammer(document.body).on("swipeleft", =>
      if window.innerWidth <= SCREEN_XS_MAX and @activeIndex < (app.options.panelCount - 1)
        app.router.navigate("/panel/#{@activeIndex + 1}", trigger : true)
    )

    @listenTo(this, "pageshow", ->
      @panelViews.forEach((panelView) -> panelView.trigger("pageshow"))
    )

    @listenTo(app, "dropboxService:syncing", ->
      @$(".connection-label").html("Syncing...")
    )
    @listenTo(app, "dropboxService:synced", ->
      @$(".connection-label").html("Synced")
    )
    @listenTo(app, "dropboxService:ready", ->
      @$(".connection-label").html("Synced")
    )

    return this


  setActive : (index) ->

    index = parseInt(index)
    if index == @activeIndex
      return

    if @activeIndex >= 0
      @panelViews[@activeIndex].deactivate()

    if index >= 0
      @panelViews[index].activate()

    @activeIndex = index
    return


  handleSettingsButtonClick : (event) ->

    event.preventDefault()
    app.router.navigate("/settings", trigger : true)

