module.exports = (gulp, $, options) ->

  gulp.task("serve", (done) ->
    gulp.src(options.serve.root)
      .pipe($.webserver(
        fallback : options.serve.defaultFile
        port : options.serve.port
      ))
  )
