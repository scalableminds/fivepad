module.exports = (gulp, $, options) ->

  gulp.task("styles", ->

    gulp.src(options.src.styles)
      # .pipe($.sourcemaps.init())
      .pipe($.less(
        paths : options.src.styles_paths
      ))
      .on("error", $.handleError)
      # .pipe($.sourcemaps.write())
      .pipe(gulp.dest(options.dest.styles))
      .pipe($.logger())

  )
