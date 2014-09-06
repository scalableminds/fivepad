### define
backbone : Backbone
lodash : _
./panel_view : PanelView
models/note_model : NoteModel
###

class LayoutView extends Backbone.View

  className : "layout-view"

  initialize : ->

    @activeIndex = -1
    @listenTo(app, "panel:activate", (panel) ->
      @setActive(panel.number)
    )


  render : ->

    @collection = new Backbone.Collection(_.times(5, (i) ->
      model = new NoteModel(id : i)
      model.fetch()
      return model
    ))

    @panels = @collection.map((model, i) ->
      new PanelView(model : model)
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
