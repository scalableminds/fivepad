(function() {
  define(["dropbox", "lodash", "app", "views/authorize_view"], function(Dropbox, _, app, AuthorizeView) {
    var DropboxService;
    return DropboxService = (function() {
      function DropboxService() {
        this.isReady = false;
        this.client = new Dropbox.Client({
          key: "hlzfj39a4cfzpri"
        });
        if (typeof cordova !== "undefined" && cordova !== null) {
          this.client.authDriver(new Dropbox.AuthDriver.Popup({
            receiverUrl: "https://scalableminds.github.io/scratchpad/oauth_receiver.html"
          }));
          this.client._driver.openWindow = function(url) {
            return AuthorizeView.show(url);
          };
        } else {
          this.client.authDriver(new Dropbox.AuthDriver.Cordova());
        }
        this.client.authenticate({
          interactive: false
        });
        if (this.client.isAuthenticated()) {
          this.initDatastore();
        }
      }

      DropboxService.prototype.authenticate = function() {
        this.client.authenticate((function(_this) {
          return function(error) {
            if (error) {
              return console.error("dropboxService:authenticationError", error);
            } else {
              return _this.initDatastore();
            }
          };
        })(this));
        return this;
      };

      DropboxService.prototype.initDatastore = function() {
        var datastoreManager;
        datastoreManager = this.client.getDatastoreManager();
        datastoreManager.openDefaultDatastore((function(_this) {
          return function(error, datastore) {
            if (error) {
              console.error("dropboxService:datastoreError", error);
              return _this.initDatastore();
            } else {
              _this.datastore = datastore;
              _this.notesTable = _this.datastore.getTable("notes");
              _this.datastore.syncStatusChanged.addListener(function() {
                console.log("dropbox syncing", _this.datastore.getSyncStatus().uploading);
                if (_this.datastore.getSyncStatus().uploading) {
                  app.trigger("dropboxService:syncing");
                } else {
                  app.trigger("dropboxService:synced");
                }
              });
              _this.datastore.recordsChanged.addListener(function(changes) {
                if (changes.isLocal()) {
                  app.trigger("dropboxService:recordsChangedLocal", changes);
                } else {
                  app.trigger("dropboxService:recordsChangedRemote", changes);
                }
                app.trigger("dropboxService:recordsChanged", changes);
              });
              if (!_this.isReady) {
                _this.isReady = true;
                return app.trigger("dropboxService:ready", _this);
              }
            }
          };
        })(this));
        return this;
      };

      DropboxService.prototype.isTransient = function() {
        var _ref;
        return (_ref = this.datastore) != null ? _ref.getSyncStatus().uploading : void 0;
      };

      DropboxService.prototype.updateNote = function(id, obj) {
        var record;
        if (this.isReady) {
          if (record = this.notesTable.get("note-" + id)) {
            return record.update(obj);
          } else {
            return this.notesTable.getOrInsert("note-" + id, obj);
          }
        }
      };

      DropboxService.prototype.getNote = function(id) {
        var _ref;
        if (this.isReady) {
          return (_ref = this.notesTable.get("note-" + id)) != null ? _ref.getFields() : void 0;
        }
      };

      return DropboxService;

    })();
  });

}).call(this);
