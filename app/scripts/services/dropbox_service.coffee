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
    @client.authDriver(
      new Dropbox.AuthDriver.Popup({
        receiverUrl: "https://5iler.com/oauth_receiver.html" # HACK
      }))

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
        @datastore.syncStatusChanged.addListener((event) =>
          if not @datastore.getSyncStatus().uploading
            app.trigger("dropboxService:synced", { originalEvent : event })
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
      return @notesTable.get("note-#{id}")?.getFields()
