(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["backbone", "app"], function(Backbone, app) {
    var AuthorizeView;
    return AuthorizeView = (function(_super) {
      __extends(AuthorizeView, _super);

      function AuthorizeView() {
        return AuthorizeView.__super__.constructor.apply(this, arguments);
      }

      AuthorizeView.prototype.className = "authorize-view";

      AuthorizeView.prototype.template = "<div class=\"close-button\">&times;</div>\n<iframe></iframe>";

      AuthorizeView.show = function(url) {
        var view;
        view = new AuthorizeView();
        view.render();
        $("#main").append(view.el);
        view.$("iframe").attr("src", url);
        return view;
      };

      return AuthorizeView;

    })(Backbone.View);
  });

}).call(this);
