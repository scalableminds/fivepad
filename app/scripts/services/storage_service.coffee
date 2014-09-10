### define
lodash : _
app : app
###

class StorageService

  constructor : ->

    app.on("dropboxService:ready", =>
      _.times(app.options.panelCount, (i) =>
        dropboxRecord = app.dropboxService.getNote(i)
        localRecord = @getNote(i)

        if localRecord.lastSynced < dropboxRecord.lastUpdated
          alert("Conflict!!!")
        else
          if localRecord.lastUpdated > dropboxRecord.lastUpdated
            app.dropboxService.updateNote(i, localRecord)
          else
            @updateNote(i, dropboxRecord)
      )
    )

  getNote : (id) ->
    storedString = window.localStorage.getItem("scratchpad-note-#{id}")
    if storedString
      return JSON.parse(storedString)
    else
      return {}

  updateNote : (id, noteObj) ->
    window.localStorage.setItem("scratchpad-note-#{id}", JSON.stringify(noteObj))
    app.dropboxService.updateNote(id, noteObj)
    app.trigger("storageService:recordsChanged")
    return

