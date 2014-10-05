(function() {
  define(["lodash", "backbone", "diff", "app", "jquery"], function(_, Backbone, Diff, app, $) {
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
        this.loaded = $.Deferred();
        this.load();
        app.on("dropboxService:recordsChangedRemote", (function(_this) {
          return function() {
            console.debug(_this.id, "dropbox change");
            return _this.sync();
          };
        })(this));
        app.on("dropboxService:synced", (function(_this) {
          return function() {
            console.debug(_this.id, "dropbox synced", _this.pull()._revision);
            _this.attributes._syncedRevision = _this.pull()._revision;
            return _this.persist();
          };
        })(this));
        app.on("dropboxService:ready", (function(_this) {
          return function() {
            console.debug(_this.id, "dropbox ready");
            return _this.sync().then(function() {
              return _this.trigger("reset");
            });
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
        return this.loaded.then((function(_this) {
          return function() {
            var local, remote;
            if (remote = _this.pull()) {
              local = _this.attributes;
              if (local._revision > local._syncedRevision && remote._revision > local._syncedRevision && !app.dropboxService.isTransient()) {
                console.debug(_this.id, "merge conflict", app.dropboxService.isTransient());
                if (!confirm("Merge conflict in Panel '" + local.title + "'. Do you wish to keep your local changes?")) {
                  _this.attributes.title = remote.title;
                  _this.attributes.contents = remote.contents;
                }
                _this.attributes._revision = Math.max(local._revision, remote._revision) + 1;
                _this.persist();
                _this.push();
                _this.trigger("reset");
              } else {
                _this.attributes._syncedRevision = remote._revision;
                _this.persist();
                if (local._revision > remote._revision) {
                  console.debug(_this.id, "merge local");
                  _this.push();
                } else if (local._revision < remote._revision) {
                  console.debug(_this.id, "merge remote");
                  _.extend(_this.attributes, remote);
                  _this.trigger("reset");
                  _this.persist();
                } else {
                  console.debug(_this.id, "merge equal");
                }
              }
            } else {
              _this.push();
            }
          };
        })(this));
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
        var obj, storedObj;
        storedObj = _.pick(this.attributes, ["_revision", "_syncedRevision", "title", "contents"]);
        if ((typeof chrome !== "undefined" && chrome !== null ? chrome.storage : void 0) != null) {
          obj = {};
          obj["" + this.LOCALSTORAGE_KEY + "-" + this.id] = storedObj;
          chrome.storage.local.set(obj);
        } else {
          window.localStorage.setItem("" + this.LOCALSTORAGE_KEY + "-" + this.id, JSON.stringify(storedObj));
        }
      };

      NoteModel.prototype.load = function() {
        var storedString;
        if ((typeof chrome !== "undefined" && chrome !== null ? chrome.storage : void 0) != null) {
          chrome.storage.local.get("" + this.LOCALSTORAGE_KEY + "-" + this.id, (function(_this) {
            return function(item) {
              if (item) {
                _.extend(_this.attributes, item["" + _this.LOCALSTORAGE_KEY + "-" + _this.id]);
              } else {
                _this.attributes.title = app.options.defaultTitle[_this.id];
              }
              return _this.loaded.resolve();
            };
          })(this));
        } else {
          storedString = window.localStorage.getItem("" + this.LOCALSTORAGE_KEY + "-" + this.id);
          if (storedString) {
            _.extend(this.attributes, JSON.parse(storedString));
          } else {
            this.attributes.title = app.options.defaultTitle[this.id];
          }
          this.loaded.resolve();
        }
      };

      return NoteModel;

    })();
  });

}).call(this);
