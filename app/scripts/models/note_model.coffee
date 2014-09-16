### define
lodash : _
backbone : Backbone
diff : Diff
app : app
###


class NoteModel

  LOCALSTORAGE_KEY : "scratchpad-note"

  constructor : (options) ->
    _.extend(this, Backbone.Events)
    @id = options.id
    @attributes = {
      _syncedRevision : 0
      _revision : 0
      title : ""
      contents : ""
    }
    @load()

    app.on("dropboxService:recordsChangedRemote", =>
      console.log(@id, "dropbox change")
      @sync()
    )
    app.on("dropboxService:synced", =>
      console.log(@id, "dropbox synced", @pull()._revision)
      @attributes._syncedRevision = @pull()._revision
      @persist()
    )
    app.on("dropboxService:ready", =>
      console.log(@id, "dropbox ready")
      @sync()
    )


  set : (key, value, options = {}) ->

    if key of @attributes and @attributes[key] != value
      @attributes[key] = value
      @attributes._revision += 1
      @persist()
      if not options.silent
        @trigger("change", this)
        @trigger("change:#{key}", this, value)
      @sync()

    return


  get : (key) ->
    return @attributes[key]


  sync : ->
    if remote = @pull()

      local = @attributes
      if local._revision > local._syncedRevision and
         remote._revision > local._syncedRevision and
         not app.dropboxService.isTransient()
        console.log(@id, "merge conflict", app.dropboxService.isTransient())

        if not confirm("Merge conflict in Panel '#{local.title}'. Do you wish to keep your local changes?")
          @attributes.title = remote.title
          @attributes.contents = remote.contents

        @attributes._revision = Math.max(local._revision, remote._revision) + 1
        @persist()
        @push()
        @trigger("reset")

      else
        @attributes._syncedRevision = remote._revision
        @persist()

        if local._revision > remote._revision
          console.log(@id, "merge local")
          @push()
        else if local._revision < remote._revision
          console.log(@id, "merge remote")
          _.extend(@attributes, remote)
          @trigger("reset")
          @persist()
        else
          console.log(@id, "merge equal")

    else
      @push()


  toJSON : ->
    return _.clone(@attributes)


  push : ->
    transferObj = _.omit(@attributes, "_syncedRevision")
    app.dropboxService.updateNote(@id, transferObj)
    return


  pull : ->
    return app.dropboxService.getNote(@id)


  persist : ->
    storedObj = _.pick(@attributes, ["_revision", "_syncedRevision", "title", "contents"])
    window.localStorage.setItem("#{@LOCALSTORAGE_KEY}-#{@id}", JSON.stringify(storedObj))
    return


  load : ->
    storedString = window.localStorage.getItem("#{@LOCALSTORAGE_KEY}-#{@id}")
    if storedString
      _.extend(@attributes, JSON.parse(storedString))
    return
