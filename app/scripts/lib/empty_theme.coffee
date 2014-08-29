### define
ace/ace : AceEditor
###

exports = {
  isDark : false
  cssClass : "ace-empty"
  cssText : ""
}

DOM = require("ace/lib/dom")
DOM.importCssString(exports.cssText, exports.cssClass)

return exports
