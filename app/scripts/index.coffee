define( "app", ["marionette"], (Marionette) -> new Marionette.Application() )

requirejs [
  "jquery"
  "lodash"
  "app"
  "./router"
  "views/layout_view"
  "models/note_model"
  "services/dropbox_service"
], ($, _, app, Router, LayoutView, NoteModel, DropboxService) ->

  window.app = app

  app.addInitializer( ->
    app.dropboxService = new DropboxService()

    app.router = new Router()
  )

  app.addInitializer( ->
    app.options = {
      panelCount : 5
      # http://www.colourlovers.com/palette/373610/mellon_ball_surprise
      colors : [
        "#D1F2A5"
        "#EFFAB4"
        "#FFC48C"
        "#FF9F80"
        "#F56991"
      ]
      defaultTitle : [
        "Ideas"
        "Random"
        "Today"
        "Work"
        "Private"
      ]
    }
  )

  app.addInitializer( ->
    app.models = _.times(app.options.panelCount, (i) ->
      model = new NoteModel(id : i)
      return model
    )

    app.export = ->
      blob = new Blob([ JSON.stringify(app.models.map((a) -> a.toJSON())) ], { type : "application/octet-stream" })
      url = URL.createObjectURL(blob)
      a = $("<a>", href : url, download : "scratchpad-export.json")
      a.appendTo(document.body)
      _.defer -> a.trigger("click")
      return
  )

  app.on("start", ->

    app.view = new LayoutView()
    $("#main").append(app.view.render().el)
    app.view.trigger("pageshow")

    Backbone.history.start()

    window.require = window.nodereq
  )

  $ ->
    app.start()
