(function() {
  define(["lodash", "backbone", "diff", "app"], function(_, Backbone, Diff, app) {
    var NoteModel;
    return NoteModel = (function() {
      NoteModel.prototype.LOCALSTORAGE_KEY = "scratchpad-note";

      function NoteModel(options) {
        _.extend(this, Backbone.Events);
        this.id = options.id;
        this.attributes = {
          _syncedRevision: 0,
          _revision: 0,
          title: "",
          contents: ""
        };
        this.load();
        app.on("dropboxService:recordsChangedRemote", (function(_this) {
          return function() {
            console.log(_this.id, "dropbox change");
            return _this.sync();
          };
        })(this));
        app.on("dropboxService:synced", (function(_this) {
          return function() {
            console.log(_this.id, "dropbox synced", _this.pull()._revision);
            _this.attributes._syncedRevision = _this.pull()._revision;
            return _this.persist();
          };
        })(this));
        app.on("dropboxService:ready", (function(_this) {
          return function() {
            console.log(_this.id, "dropbox ready");
            return _this.sync();
          };
        })(this));
      }

      NoteModel.prototype.set = function(key, value, options) {
        if (options == null) {
          options = {};
        }
        if (key in this.attributes && this.attributes[key] !== value) {
          this.attributes[key] = value;
          this.attributes._revision += 1;
          this.persist();
          if (!options.silent) {
            this.trigger("change", this);
            this.trigger("change:" + key, this, value);
          }
          this.sync();
        }
      };

      NoteModel.prototype.get = function(key) {
        return this.attributes[key];
      };

      NoteModel.prototype.sync = function() {
        var local, remote;
        if (remote = this.pull()) {
          local = this.attributes;
          if (local._revision > local._syncedRevision && remote._revision > local._syncedRevision && !app.dropboxService.isTransient()) {
            console.log(this.id, "merge conflict", app.dropboxService.isTransient());
            if (!confirm("Merge conflict in Panel '" + local.title + "'. Do you wish to keep your local changes?")) {
              this.attributes.title = remote.title;
              this.attributes.contents = remote.contents;
            }
            this.attributes._revision = Math.max(local._revision, remote._revision) + 1;
            this.persist();
            this.push();
            return this.trigger("reset");
          } else {
            this.attributes._syncedRevision = remote._revision;
            this.persist();
            if (local._revision > remote._revision) {
              console.log(this.id, "merge local");
              return this.push();
            } else if (local._revision < remote._revision) {
              console.log(this.id, "merge remote");
              _.extend(this.attributes, remote);
              this.trigger("reset");
              return this.persist();
            } else {
              return console.log(this.id, "merge equal");
            }
          }
        } else {
          return this.push();
        }
      };

      NoteModel.prototype.toJSON = function() {
        return _.clone(this.attributes);
      };

      NoteModel.prototype.push = function() {
        var transferObj;
        transferObj = _.omit(this.attributes, "_syncedRevision");
        app.dropboxService.updateNote(this.id, transferObj);
      };

      NoteModel.prototype.pull = function() {
        return app.dropboxService.getNote(this.id);
      };

      NoteModel.prototype.persist = function() {
        var storedObj;
        storedObj = _.pick(this.attributes, ["_revision", "_syncedRevision", "title", "contents"]);
        window.localStorage.setItem("" + this.LOCALSTORAGE_KEY + "-" + this.id, JSON.stringify(storedObj));
      };

      NoteModel.prototype.load = function() {
        var storedString;
        storedString = window.localStorage.getItem("" + this.LOCALSTORAGE_KEY + "-" + this.id);
        if (storedString) {
          _.extend(this.attributes, JSON.parse(storedString));
        }
      };

      return NoteModel;

    })();
  });

}).call(this);
