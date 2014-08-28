### define
backbone : Backbone
ace/ace : Ace
###


class EditorView extends Backbone.View

  className : "editor-view"

  render : ->

    @$el.css(
      fontFamily : "Source Code Pro"
      fontSize : "16pt"
      fontWeight : 300
    )

    @editor = Ace.edit(@el)
    @editor.setTheme("ace/theme/github")
    @editor.getSession().setMode("ace/mode/markdown")

    @editor.getSession().setValue("""
      # Hallo Welt
      That's the way, ah ha uh ha, i like it.

      * Hallo

      [WAT](https://scm.io)

      > That's what she
        said!
    """)


    return this
