(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["backbone", "mousetrap", "app", "./editor_view"], function(Backbone, Mousetrap, app, EditorView) {
    var PanelView, SCREEN_XS_MAX;
    SCREEN_XS_MAX = 767;
    return PanelView = (function(_super) {
      __extends(PanelView, _super);

      function PanelView() {
        return PanelView.__super__.constructor.apply(this, arguments);
      }

      PanelView.prototype.template = "<h2>\n  <input type=\"text\" class=\"title-input\">\n  <label class=\"title-label\"></label>\n</h2>\n<div class=\"editor-view\"></div>";

      PanelView.prototype.className = "panel-view";

      PanelView.prototype.events = {
        "click": "handleClick",
        "change input": "handleChangeTitle"
      };

      PanelView.prototype.render = function() {
        this.$el.html(this.template);
        this.$el.addClass("number-" + this.model.id);
        this.$el.css("background-color", app.options.colors[this.model.id % app.options.colors.length]);
        this.updateTitle();
        this.editorView = new EditorView({
          el: this.$(".editor-view")
        });
        this.editorView.render();
        this.editorView.setValue(this.model.get("contents"));
        this.listenTo(this.editorView, "change", function(value) {
          return this.model.set("contents", value);
        });
        this.listenTo(this, "pageshow", function() {
          return this.editorView.refresh();
        });
        this.listenTo(this.model, "reset", function() {
          this.editorView.setValue(this.model.get("contents"));
          return this.updateTitle();
        });
        this.listenTo(this.model, "change:title", function() {
          return this.updateTitle();
        });
        Mousetrap.bind(["command+" + (this.model.id + 1), "ctrl+" + (this.model.id + 1)], (function(_this) {
          return function(event) {
            event.preventDefault();
            return app.router.navigate("/panel/" + _this.model.id, {
              trigger: true
            });
          };
        })(this));
        return this;
      };

      PanelView.prototype.updateTitle = function() {
        this.$("input").val(this.model.get("title"));
        return this.$("label").html(this.model.get("title"));
      };

      PanelView.prototype.handleClick = function() {
        return app.router.navigate("/panel/" + this.model.id, {
          trigger: true
        });
      };

      PanelView.prototype.handleChangeTitle = function() {
        return this.model.set("title", this.$("input").val());
      };

      PanelView.prototype.activate = function() {
        this.$el.addClass("active");
        this.editorView.refresh();
        if (window.innerWidth > SCREEN_XS_MAX) {
          return this.editorView.focus();
        }
      };

      PanelView.prototype.deactivate = function() {
        this.$el.removeClass("active");
        return this.editorView.refresh();
      };

      return PanelView;

    })(Backbone.View);
  });

}).call(this);
