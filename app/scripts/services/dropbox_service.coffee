### define
dropbox : Dropbox
lodash : _
app : app
views/authorize_view : AuthorizeView
###

# if not window.Dropbox?
#   Dropbox = window.Dropbox = nodereq("./scripts/lib/dropbox-datastores-1.1.0")


class DropboxService

  constructor : ->
    @isReady = false

    @client = new Dropbox.Client({ key: "hlzfj39a4cfzpri" })
    if cordova?
      @client.authDriver(
        new Dropbox.AuthDriver.Popup({
          receiverUrl: "https://scalableminds.github.io/scratchpad/oauth_receiver.html"
        }))
      @client._driver.openWindow = (url) ->
        AuthorizeView.show(url)

    else
      @client.authDriver(new Dropbox.AuthDriver.Cordova())



    @client.authenticate({ interactive : false })
    if @client.isAuthenticated()
      @initDatastore()


  authenticate : ->

    @client.authenticate((error) =>

      if error
        console.error("dropboxService:authenticationError", error)

      else
        @initDatastore()
    )
    return this


  initDatastore : ->

    datastoreManager = @client.getDatastoreManager()
    datastoreManager.openDefaultDatastore((error, datastore) =>
      if error
        console.error("dropboxService:datastoreError", error)
      else
        @datastore = datastore
        @notesTable = @datastore.getTable("notes")
        @datastore.syncStatusChanged.addListener( =>
          if not @datastore.getSyncStatus().uploading
            app.trigger("dropboxService:synced")
            window.localStorage.setItem("scratchpad-lastSynced", (new Date()).toJSON())
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


  updateNote : (id, obj) ->

    if @isReady
      if record = @notesTable.get("note-#{id}")
        record.update(obj)
      else
        @notesTable.getOrInsert("note-#{id}", obj)


  getNote : (id) ->

    if @isReady
      return @notesTable.get("note-#{id}")
