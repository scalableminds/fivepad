### define
backbone : Backbone
lodash : _
./panel_view : PanelView
###

class LayoutView extends Backbone.View

  className : "layout-view"

  initialize : ->

    @activeIndex = -1
    @listenTo(app, "panel:activate", (panel) ->
      @setActive(panel.number)
    )


  render : ->

    @panels = _.times(5, (i) ->
      new PanelView(number : i)
    )

    @panels.forEach((view) =>
      @$el.append(view.render().el)
    )


    return this


  setActive : (index) ->

    if index == @activeIndex
      return

    if @activeIndex >= 0
      @panels[@activeIndex].deactivate()

    if index >= 0
      @panels[index].activate()

    @activeIndex = index
    return
