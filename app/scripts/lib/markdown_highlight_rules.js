define(["require","exports","module","ace/lib/oop","ace/lib/lang","ace/mode/text_highlight_rules","ace/mode/javascript_highlight_rules","ace/mode/xml_highlight_rules","ace/mode/html_highlight_rules","ace/mode/css_highlight_rules"], function(require, exports, module) {
"use strict";

var oop = require("ace/lib/oop");
var lang = require("ace/lib/lang");
var TextHighlightRules = require("ace/mode/text_highlight_rules").TextHighlightRules;
var JavaScriptHighlightRules = require("ace/mode/javascript_highlight_rules").JavaScriptHighlightRules;
var XmlHighlightRules = require("ace/mode/xml_highlight_rules").XmlHighlightRules;
var HtmlHighlightRules = require("ace/mode/html_highlight_rules").HtmlHighlightRules;
var CssHighlightRules = require("ace/mode/css_highlight_rules").CssHighlightRules;

var escaped = function(ch) {
    return "(?:[^" + lang.escapeRegExp(ch) + "\\\\]|\\\\.)*";
}

function github_embed(tag, prefix) {
    return { // Github style block
        token : "support.function",
        regex : "^\\s*```" + tag + "\\s*$",
        push  : prefix + "start"
    };
}

var MarkdownHighlightRules = function() {
    HtmlHighlightRules.call(this);

    this.$rules["start"].unshift({
        token : "empty_line",
        regex : '^$',
        next: "allowBlock"
    }, { // h1
        token: "markup.heading.1",
        regex: "^=+(?=\\s*$)"
    }, { // h2
        token: "markup.heading.2",
        regex: "^\\-+(?=\\s*$)"
    }, {
        token : function(value) {
            return "markup.heading." + value.length;
        },
        regex : /^#{1,6}(?=\s*[^ #]|\s+#.)/,
        next : "header"
    },
       github_embed("(?:javascript|js)", "jscode-"),
       github_embed("xml", "xmlcode-"),
       github_embed("html", "htmlcode-"),
       github_embed("css", "csscode-"),
    { // Github style block
        token : "support.function",
        regex : "^\\s*```\\s*\\S*(?:{.*?\\})?\\s*$",
        next  : "githubblock"
    }, { // block quote
        token : "markup.blockquote",
        regex : "^\\s*>\\s*(?:[*+-]|\\d+\\.)?\\s+",
        next  : "blockquote"
    }, { // HR * - _
        token : "constant",
        regex : "^ {0,2}(?:(?: ?\\* ?){3,}|(?: ?\\- ?){3,}|(?: ?\\_ ?){3,})\\s*$",
        next: "allowBlock"
    }, { // list
        token : "markup.list",
        regex : "^\\s{0,3}(?:[*+-]|\\d+\\.)\\s+",
        next  : "listblock-start"
    }, {
        include : "basic"
    });

    this.addRules({
        "basic" : [{
            token : "constant.language.escape",
            regex : /\\[\\`*_{}\[\]()#+\-.!]/
        }, { // code span `
            token : "support.function",
            regex : "(`+)(.*?[^`])(\\1)"
        }, { // reference
            token : ["markup.reference", "constant", "markup.reference", "url", "string", "markup.reference"],
            regex : "^([ ]{0,3}\\[)([^\\]]+)(\\]:\\s*)([^ ]+)(\\s*(?:[\"][^\"]+[\"])?(\\s*))$"
        }, { // link by reference
            token : ["markup.reference", "string", "markup.reference", "constant", "markup.reference"],
            regex : "(\\[)(" + escaped("]") + ")(\\]\s*\\[)("+ escaped("]") + ")(\\])"
        }, { // link by url
            token : ["markup.reference", "string", "markup.reference", "markup.underline", "string", "markup.reference"],
            regex : "(\\[)(" +                                        // [
                    escaped("]") +                                    // link text
                    ")(\\]\\()"+                                      // ](
                    '((?:[^\\)\\s\\\\]|\\\\.|\\s(?=[^"]))*)' +        // href
                    '(\\s*"' +  escaped('"') + '"\\s*)?' +            // "title"
                    "(\\))"                                           // )
        }, { // strong ** __
            token : "string.strong",
            regex : "([*]{2}|[_]{2}(?=\\S))(.*?\\S[*_]*)(\\1)"
        }, { // emphasis * _
            token : "string.emphasis",
            regex : "([*]|[_](?=\\S))(.*?\\S[*_]*)(\\1)"
        }, { //
            token : ["text", "url", "text"],
            regex : "(<)("+
                      "(?:https?|ftp|dict):[^'\">\\s]+"+
                      "|"+
                      "(?:mailto:)?[-.\\w]+\\@[-a-z0-9]+(?:\\.[-a-z0-9]+)*\\.[a-z]+"+
                    ")(>)"
        }],
        "allowBlock": [
            {token : "support.function", regex : "^ {4}.+", next : "allowBlock"},
            {token : "empty", regex : "", next : "start"}
        ],

        "header" : [{
            regex: "$",
            next : "start"
        }, {
            include: "basic"
        }, {
            defaultToken : "heading"
        } ],

        "listblock-start" : [{
            token : "support.variable",
            regex : /(?:\[[ x]\])?/,
            next  : "listblock"
        }],

        "listblock" : [ { // Lists only escape on completely blank lines.
            token : "empty_line",
            regex : "^$",
            next  : "start"
        }, { // list
            token : "markup.list",
            regex : "^\\s{0,3}(?:[*+-]|\\d+\\.)\\s+",
            next  : "listblock-start"
        }, {
            include : "basic", noEscape: true
        }, { // Github style block
            token : "support.function",
            regex : "^\\s*```\\s*[a-zA-Z]*(?:{.*?\\})?\\s*$",
            next  : "githubblock"
        }, {
            defaultToken : "list" //do not use markup.list to allow stling leading `*` differntly
        } ],

        "blockquote" : [ { // Blockquotes only escape on blank lines.
            token : "empty_line",
            regex : "^\\s*$",
            next  : "start"
        }, { // block quote
            token : "string.blockquote",
            regex : "^\\s*>\\s*(?:[*+-]|\\d+\\.)?\\s+",
            next  : "blockquote"
        }, {
            include : "basic", noEscape: true
        }, {
            defaultToken : "string.blockquote"
        } ],

        "githubblock" : [ {
            token : "support.function",
            regex : "^\\s*```",
            next  : "start"
        }, {
            token : "support.function",
            regex : ".+"
        } ]
    });

    this.embedRules(JavaScriptHighlightRules, "jscode-", [{
       token : "support.function",
       regex : "^\\s*```",
       next  : "pop"
    }]);

    this.embedRules(HtmlHighlightRules, "htmlcode-", [{
       token : "support.function",
       regex : "^\\s*```",
       next  : "pop"
    }]);

    this.embedRules(CssHighlightRules, "csscode-", [{
       token : "support.function",
       regex : "^\\s*```",
       next  : "pop"
    }]);

    this.embedRules(XmlHighlightRules, "xmlcode-", [{
       token : "support.function",
       regex : "^\\s*```",
       next  : "pop"
    }]);

    this.normalizeRules();
};
oop.inherits(MarkdownHighlightRules, TextHighlightRules);

exports.MarkdownHighlightRules = MarkdownHighlightRules;
});
