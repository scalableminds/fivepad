require.config(

  baseUrl : "/scripts"
  waitSeconds : 15

  paths :
    lodash : "../bower_components/lodash/dist/lodash"
    backbone : "../bower_components/backbone/backbone"
    marionette : "../bower_components/marionette/lib/backbone.marionette"
    jquery : "../bower_components/jquery/dist/jquery"
    ace : "../bower_components/ace-builds/src/"
    mousetrap : "../bower_components/mousetrap/mousetrap"
    hammer : "../bower_components/hammerjs/hammer"
    dropbox : "https://www.dropbox.com/static/api/dropbox-datastores-1.1-latest"

  map :
    backbone :
      underscore : "lodash"
    marionette :
      underscore : "lodash"
    "ace/mode/markdown" :
      "ace/mode/markdown_highlight_rules" : "lib/markdown_highlight_rules"


  shim :
    dropbox :
      exports : "Dropbox"

)
