### define
dropbox : Dropbox
lodash : _
app : app
###

# if not window.Dropbox?
#   Dropbox = window.Dropbox = nodereq("./scripts/lib/dropbox-datastores-1.1.0")


class DropboxService

  constructor : ->
    @isReady = false

    @client = new Dropbox.Client({ key: "hlzfj39a4cfzpri" })
    if cordova?
      @client.authDriver(new Dropbox.AuthDriver.Cordova())

    else if chrome?.storage?
      @client.authDriver(new Dropbox.AuthDriver.ChromeApp())

    else
      @client.authDriver(
        new Dropbox.AuthDriver.Popup({
          receiverUrl: "https://scalableminds.github.io/scratchpad/oauth_receiver.html"
        }))

    @client.authenticate({ interactive : false }, (error) =>
      if error
        console.error("dropboxService:authenticationError", error)

      else if @isAuthenticated()
        @initDatastore()
        app.trigger("dropboxService:authenticated")
    )


  authenticate : ->

    @client.authenticate((error) =>

      if error
        console.error("dropboxService:authenticationError", error)

      else
        app.trigger("dropboxService:authenticated")
        @initDatastore()
    )
    return this


  initDatastore : ->

    datastoreManager = @client.getDatastoreManager()
    datastoreManager.openDefaultDatastore((error, datastore) =>
      if error
        console.error("dropboxService:datastoreError", error)
        @initDatastore()

      else
        @datastore = datastore

        @notesTable = @datastore.getTable("notes")

        @datastore.syncStatusChanged.addListener( =>
          console.log("dropbox syncing", @datastore.getSyncStatus().uploading)
          if @datastore.getSyncStatus().uploading
            app.trigger("dropboxService:syncing")
          else
            app.trigger("dropboxService:synced")
          return
        )
        @datastore.recordsChanged.addListener((changes) =>
          if changes.isLocal()
            app.trigger("dropboxService:recordsChangedLocal", changes)
          else
            app.trigger("dropboxService:recordsChangedRemote", changes)

          app.trigger("dropboxService:recordsChanged", changes)
          return
        )

        if not @isReady
          @isReady = true
          app.trigger("dropboxService:ready", this)
    )
    return this


  isAuthenticated : ->
    return @client.isAuthenticated()

  isTransient : ->
    return @datastore?.getSyncStatus().uploading


  updateNote : (id, obj) ->

    if @isReady
      if record = @notesTable.get("note-#{id}")
        record.update(obj)
      else
        @notesTable.getOrInsert("note-#{id}", obj)


  getNote : (id) ->

    if @isReady
      return @notesTable.get("note-#{id}")?.getFields()


