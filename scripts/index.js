(function() {
  define("app", ["marionette"], function(Marionette) {
    return new Marionette.Application();
  });

  requirejs(["jquery", "lodash", "app", "./router", "views/layout_view", "models/note_model", "services/dropbox_service"], function($, _, app, Router, LayoutView, NoteModel, DropboxService) {
    window.app = app;
    app.addInitializer(function() {
      app.dropboxService = new DropboxService();
      return app.router = new Router();
    });
    app.addInitializer(function() {
      return app.options = {
        panelCount: 5,
        colors: ["#D1F2A5", "#EFFAB4", "#FFC48C", "#FF9F80", "#F56991"],
        defaultTitle: ["Ideas", "Random", "Today", "Work", "Private"]
      };
    });
    app.addInitializer(function() {
      app.models = _.times(app.options.panelCount, function(i) {
        var model;
        model = new NoteModel({
          id: i
        });
        return model;
      });
      return app["export"] = function() {
        var a, blob, url;
        blob = new Blob([
          JSON.stringify(app.models.map(function(a) {
            return a.toJSON();
          }))
        ], {
          type: "application/octet-stream"
        });
        url = URL.createObjectURL(blob);
        a = $("<a>", {
          href: url,
          download: "scratchpad-export.json"
        });
        a.appendTo(document.body);
        _.defer(function() {
          return a.trigger("click");
        });
      };
    });
    app.on("start", function() {
      app.view = new LayoutView();
      $("#main").append(app.view.render().el);
      app.view.trigger("pageshow");
      Backbone.history.start();
      return window.require = window.nodereq;
    });
    return $(function() {
      return app.start();
    });
  });

}).call(this);
