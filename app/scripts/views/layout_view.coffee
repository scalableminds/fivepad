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
    <div class="connection-label"></div>
  """

  events :
    "click .connection-label" : "handleConnectionLabelClick"

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
        app.router.prevPanel()
    )
    Hammer(document.body).on("swipeleft", =>
      if window.innerWidth <= SCREEN_XS_MAX and @activeIndex < (app.options.panelCount - 1)
        app.router.nextPanel()
    )

    Mousetrap.bind("ctrl+left", (event) =>
      event.preventDefault()
      app.router.prevPanel()
    )

    Mousetrap.bind("ctrl+right", (event) =>
      event.preventDefault()
      app.router.nextPanel()
    )

    @listenTo(this, "pageshow", ->
      @panelViews.forEach((panelView) -> panelView.trigger("pageshow"))
    )

    @listenTo(app, "dropboxService:syncing", @updateConnectionLabel)
    @listenTo(app, "dropboxService:authenticated", @updateConnectionLabel)
    @listenTo(app, "dropboxService:synced", @updateConnectionLabel)
    @listenTo(app, "dropboxService:ready", @updateConnectionLabel)

    @updateConnectionLabel()

    return this


  updateConnectionLabel : ->

    if app.dropboxService.isAuthenticated()
      if app.dropboxService.isReady
        if app.dropboxService.isTransient()
          connectionLabel = "Syncing..."
        else
          connectionLabel = "Synced"
      else
        connectionLabel = "Offline"
    else
      connectionLabel = "Connect with Dropbox."

    @$(".connection-label").html(connectionLabel)


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


  handleConnectionLabelClick : (event) ->

    event.preventDefault()
    if not app.dropboxService.isAuthenticated()
      app.dropboxService.authenticate()
    return

