### define
backbone : Backbone
app : app
###

class NoteModel extends Backbone.Model

  LOCALSTORAGE_KEY : "scratchpad-notemodel"

  initialize : ->
    app.on("storageService:recordsChanged", => @fetch())


  fetch : ->
    @set(app.storageService.getNote(@id))

  save : ->
    @set.apply(this, arguments)
    app.storageService.updateNote(@id, @toJSON())
    app.dropboxService.updateNote(@id, @toJSON())
