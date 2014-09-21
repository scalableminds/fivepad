(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["backbone", "lib/codemirror", "app"], function(Backbone, CodeMirror, app) {
    var EditorView;
    return EditorView = (function(_super) {
      __extends(EditorView, _super);

      function EditorView() {
        return EditorView.__super__.constructor.apply(this, arguments);
      }

      EditorView.prototype.className = "editor-view";

      EditorView.prototype.initialize = function() {
        return this.handleValueChange = _.debounce(this.handleValueChange, 500);
      };

      EditorView.prototype.render = function() {
        if (/android/i.test(window.navigator.userAgent)) {
          this.editorTextArea = $("<textarea>", {
            "class": "fallback-textarea"
          }).appendTo(this.el);
          this.editorTextArea.on("input", (function(_this) {
            return function() {
              return _this.handleValueChange(null, {
                origin: "userinput"
              });
            };
          })(this));
          this.editor = {
            getValue: (function(_this) {
              return function() {
                return _this.editorTextArea.val();
              };
            })(this),
            setValue: (function(_this) {
              return function(value) {
                _this.editorTextArea.val(value);
              };
            })(this),
            focus: (function(_this) {
              return function() {
                return _this.editorTextArea.focus();
              };
            })(this),
            refresh: function() {}
          };
        } else {
          this.editor = CodeMirror(this.el, {
            mode: "markdown",
            theme: "empty",
            lineNumbers: false,
            lineWrapping: true,
            extraKeys: {
              "Enter": "newlineAndIndentContinueMarkdownList"
            }
          });
          this.editor.on("change", this.handleValueChange.bind(this));
        }
        return this;
      };

      EditorView.prototype.handleValueChange = function(editor, options) {
        if (options.origin !== "setValue") {
          this.trigger("change", this.editor.getValue(), this);
        }
      };

      EditorView.prototype.setValue = function(value) {
        this.editor.setValue(value);
      };

      EditorView.prototype.refresh = function() {
        return this.editor.refresh();
      };

      EditorView.prototype.focus = function() {
        return this.editor.focus();
      };

      return EditorView;

    })(Backbone.View);
  });

}).call(this);
