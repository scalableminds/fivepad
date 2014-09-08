### define
jquery : $
backbone : Backbone
lib/uber_router : UberRouter
###

class Router extends UberRouter

  rootSelector : "#main"
  navbarSelector : "#navbar"

  routes :
    "" : "home"
    "panel/:panel_number" : "panel"
    "settings" : "settings"

  whitelist : []

  panel : (number) ->
    app.view.setActive(number)


  settings : ->
