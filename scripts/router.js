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

      return Router;

    })(UberRouter);
  });

}).call(this);
