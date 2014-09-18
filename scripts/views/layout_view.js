(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["backbone", "lodash", "hammer", "./panel_view"], function(Backbone, _, Hammer, PanelView) {
    var LayoutView, SCREEN_XS_MAX;
    SCREEN_XS_MAX = 767;
    return LayoutView = (function(_super) {
      __extends(LayoutView, _super);

      function LayoutView() {
        return LayoutView.__super__.constructor.apply(this, arguments);
      }

      LayoutView.prototype.className = "layout-view";

      LayoutView.prototype.template = "<div class=\"connection-label\"></div>";

      LayoutView.prototype.events = {
        "click .connection-label": "handleConnectionLabelClick"
      };

      LayoutView.prototype.initialize = function() {
        return this.activeIndex = -1;
      };

      LayoutView.prototype.render = function() {
        this.$el.append(this.template);
        this.panelViews = app.models.map((function(_this) {
          return function(model, i) {
            var view;
            view = new PanelView({
              model: model
            });
            _this.$el.append(view.render().el);
            return view;
          };
        })(this));
        if (this.panelViews.length > 0) {
          this.setActive(0);
        }
        Hammer(document.body).on("swiperight", (function(_this) {
          return function() {
            if (window.innerWidth <= SCREEN_XS_MAX && _this.activeIndex > 0) {
              return app.router.navigate("/panel/" + (_this.activeIndex - 1), {
                trigger: true
              });
            }
          };
        })(this));
        Hammer(document.body).on("swipeleft", (function(_this) {
          return function() {
            if (window.innerWidth <= SCREEN_XS_MAX && _this.activeIndex < (app.options.panelCount - 1)) {
              return app.router.navigate("/panel/" + (_this.activeIndex + 1), {
                trigger: true
              });
            }
          };
        })(this));
        this.listenTo(this, "pageshow", function() {
          return this.panelViews.forEach(function(panelView) {
            return panelView.trigger("pageshow");
          });
        });
        this.listenTo(app, "dropboxService:syncing", this.updateConnectionLabel);
        this.listenTo(app, "dropboxService:authenticated", this.updateConnectionLabel);
        this.listenTo(app, "dropboxService:synced", this.updateConnectionLabel);
        this.listenTo(app, "dropboxService:ready", this.updateConnectionLabel);
        this.updateConnectionLabel();
        return this;
      };

      LayoutView.prototype.updateConnectionLabel = function() {
        var connectionLabel;
        if (app.dropboxService.isAuthenticated()) {
          if (app.dropboxService.isReady) {
            if (app.dropboxService.isTransient()) {
              connectionLabel = "Syncing...";
            } else {
              connectionLabel = "Synced";
            }
          } else {
            connectionLabel = "Offline";
          }
        } else {
          connectionLabel = "Connect with Dropbox.";
        }
        return this.$(".connection-label").html(connectionLabel);
      };

      LayoutView.prototype.setActive = function(index) {
        index = parseInt(index);
        if (index === this.activeIndex) {
          return;
        }
        if (this.activeIndex >= 0) {
          this.panelViews[this.activeIndex].deactivate();
        }
        if (index >= 0) {
          this.panelViews[index].activate();
        }
        this.activeIndex = index;
      };

      LayoutView.prototype.handleConnectionLabelClick = function(event) {
        event.preventDefault();
        if (!app.dropboxService.isAuthenticated()) {
          app.dropboxService.authenticate();
        }
      };

      return LayoutView;

    })(Backbone.View);
  });

}).call(this);
