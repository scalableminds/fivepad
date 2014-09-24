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

  whitelist : []

  panel : (number) ->
    app.view.setActive(number)


  nextPanel : ->
    activeIndex = app.view.activeIndex
    newIndex = if activeIndex < (app.options.panelCount - 1) then activeIndex + 1 else 0
    app.router.navigate("/panel/#{newIndex}", trigger : true)
    return


  prevPanel : ->
    activeIndex = app.view.activeIndex
    newIndex = if activeIndex > 0 then activeIndex - 1 else app.options.panelCount - 1
    app.router.navigate("/panel/#{newIndex}", trigger : true)
    return

