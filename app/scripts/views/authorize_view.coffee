### define
backbone : Backbone
app : app
###

class AuthorizeView extends Backbone.View

  className : "authorize-view"

  template : """
    <div class="close-button">&times;</div>
    <iframe></iframe>
  """

  @show : (url) ->

    view = new AuthorizeView()
    view.render()
    $("#main").append(view.el)
    view.$("iframe").attr("src", url)
    return view
