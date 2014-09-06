### define
backbone : Backbone
app : app
###

class NoteModel extends Backbone.Model

  LOCALSTORAGE_KEY : "scratchpad-notemodel"

  fetch : ->
    @set(JSON.parse(window.localStorage.getItem("#{@LOCALSTORAGE_KEY}-#{@id}")))

  save : ->
    @set.apply(this, arguments)
    window.localStorage.setItem("#{@LOCALSTORAGE_KEY}-#{@id}", JSON.stringify(@toJSON()))
