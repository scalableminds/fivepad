### define
jquery : $
backbone : Backbone
lib/uber_router : UberRouter
views/editor_view : EditorView
###

class Router extends UberRouter

  rootSelector : "#main"
  navbarSelector : "#navbar"

  routes :
    "" : "home"

  whitelist : []

  home : ->
    view = new EditorView()
    @changeView(view)
