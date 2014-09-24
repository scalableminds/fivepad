(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["jquery", "backbone", "lib/uber_router"], function($, Backbone, UberRouter) {
    var Router;
    return Router = (function(_super) {
      __extends(Router, _super);

      function Router() {
        return Router.__super__.constructor.apply(this, arguments);
      }

      Router.prototype.rootSelector = "#main";

      Router.prototype.navbarSelector = "#navbar";

      Router.prototype.routes = {
        "": "home",
        "panel/:panel_number": "panel"
      };

      Router.prototype.whitelist = [];

      Router.prototype.panel = function(number) {
        return app.view.setActive(number);
      };

      Router.prototype.nextPanel = function() {
        var activeIndex, newIndex;
        activeIndex = app.view.activeIndex;
        newIndex = activeIndex < (app.options.panelCount - 1) ? activeIndex + 1 : 0;
        app.router.navigate("/panel/" + newIndex, {
          trigger: true
        });
      };

      Router.prototype.prevPanel = function() {
        var activeIndex, newIndex;
        activeIndex = app.view.activeIndex;
        newIndex = activeIndex > 0 ? activeIndex - 1 : app.options.panelCount - 1;
        app.router.navigate("/panel/" + newIndex, {
          trigger: true
        });
      };

      return Router;

    })(UberRouter);
  });

}).call(this);
