define( "app", ["marionette"], (Marionette) -> new Marionette.Application() )

require [
  "jquery"
  "lodash"
  "app"
  "./router"
  "views/layout_view"
  "services/dropbox_service"
], ($, _, app, Router, LayoutView, DropboxService) ->

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
      fontFamily : "Source Code Pro"
      fontSize : "16pt"
      fontWeight : 300
    }
  )

  app.on("start", ->

    app.view = new LayoutView()
    $("#main").append(app.view.render().el)

    Backbone.history.start()
  )

  $ ->
    app.start()
