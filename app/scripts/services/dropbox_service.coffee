### define
dropbox : Dropbox
app : app
###

class DropboxService

  constructor : ->
    @client = new Dropbox.Client({ key: "hlzfj39a4cfzpri" })
    @client.authDriver(new Dropbox.AuthDriver.Popup({ receiverUrl: "https://5iler.com/oauth_receiver.html" }))



  authenticate : ->
    # Try to finish OAuth authorization.
    @client.authenticate((error) =>
      if error
        console.error("dropboxService:authenticationError", error)
      else
        datastoreManager = @client.getDatastoreManager()
        datastoreManager.openDefaultDatastore((error, datastore) =>
          if error
            console.error("dropboxService:datastoreError", error)
          else
            @datastore = datastore
            app.trigger("dropboxService:ready", this)
            console.log(this, datastore.getTable("notes").query())
        )
    )
    this
