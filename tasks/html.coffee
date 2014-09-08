module.exports = (gulp, $, options) ->

  gulp.task("copy", (done) ->
    gulp.src(options.src.copy, { base : options.src.dir })
      .pipe($.changed(options.dest.dir))
    	.pipe(gulp.dest(options.dest.dir))
      .pipe($.logger())
  )
