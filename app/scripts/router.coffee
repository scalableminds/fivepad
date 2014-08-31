### define
jquery : $
backbone : Backbone
lib/uber_router : UberRouter
views/editor_view : EditorView
views/layout_view : LayoutView
###

class Router extends UberRouter

  rootSelector : "#main"
  navbarSelector : "#navbar"

  routes :
    "" : "home"

  whitelist : []

  home : ->
    view = new LayoutView()
    @changeView(view)
