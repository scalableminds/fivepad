### define
backbone : Backbone
app : app
###

class NoteModel extends Backbone.Model

  LOCALSTORAGE_KEY : "scratchpad-notemodel"

  defaults :
    title : ""
    contents : ""
    _lastUpdated : 0
    _isSynced : false

  initialize : ->

    storedString = window.localStorage.getItem("scratchpad-note-#{@id}")
    if storedString
      storedObj = JSON.parse(storedString)
    else
      storedObj = {}
    @set(storedObj)


    app.on("dropboxService:recordsChangedRemote", =>
      console.log(@id, "drobbox change")
      @mergeDropbox(app.dropboxService.getNote(@id))
    )
    app.on("dropboxService:synced", =>
      @save("_isSynced", true)
    )
    app.on("dropboxService:ready", =>
      @mergeDropbox(app.dropboxService.getNote(@id))
    )

    @listenTo(this, "change:title", @markDirty)
    @listenTo(this, "change:contents", @markDirty)


  markDirty : ->
    @set("_lastUpdated", Date.now())
    @set("_isSynced", false)


  fetch : ->

    return


  mergeDropbox : (remote) ->

    localObj = @toJSON()
    remoteObj = remote.getFields()

    if localObj._lastSynced < remoteObj._lastUpdated
      alert("Conflict!!!")

      mergedObj = {
        title :
          if localObj.title == remoteObj.title
            localObj.title
          else
            "#{localObj.title} || #{remoteObj.title}"
        contents :
          if localObj.contents == remoteObj.contents
            localObj.contents
          else
            """
            >>> local
            #{localObj.contents}

            >>> remote
            #{remoteObj.contents}
            """
      }

      @save(mergedObj)
    else
      if localObj._lastUpdated > remoteObj._lastUpdated
        console.log(@id, "resolve local")
        @saveDropbox()
      else if localObj._lastUpdated < remoteObj._lastUpdated
        console.log(@id, "resolve remote")
        @set(remote.getFields())
        @trigger("forceChange:contents")
      else
        console.log(@id, "resolve none")


  save : ->
    @set.apply(this, arguments)
    @saveLocal()
    if @get("_isSynced") == false
      @saveDropbox()
    return


  saveLocal : ->
    window.localStorage.setItem("scratchpad-note-#{@id}", JSON.stringify(@toJSON()))
    return

  saveDropbox : ->
    obj = {
      title : @get("title")
      contents : @get("contents")
      _lastUpdated : @get("_lastUpdated")
    }
    app.dropboxService.updateNote(@id, obj)
    return
