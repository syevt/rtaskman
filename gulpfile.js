var gulp = require('gulp'),
  gutil = require('gulp-util'),
  open = require('gulp-open'),
  browserify = require('browserify'),
  coffeeify = require('coffeeify'),
  watch = require('gulp-watch'),
  plumber = require('gulp-plumber'),
  tap = require('gulp-tap'),
  streamify = require('gulp-streamify'),
  concat = require('gulp-concat'),
  stylus = require('gulp-stylus'),
  pug = require('gulp-pug');
  Server = require('karma').Server;

gulp.task('bundle', function(){
  gulp.src('./src/client/application.coffee', {read: false})
    .pipe(plumber())
    .pipe(tap(function(file){
      var d = require('domain').create();
      d.on('error', function(err){
        gutil.log(gutil.colors.red("Browserify compile error:"),
          gutil.colors.yellow(err.message),
          gutil.colors.red("in line"),
          gutil.colors.yellow(err.line),
          gutil.colors.red("column"),
          gutil.colors.yellow(err.column));
        gutil.beep();
        this.emit('end');
      });
      d.run(function(){
        file.contents = browserify({
          entries: [file.path],
          ignore: ['**/*.spec*'],
          extensions: ['.coffee'],
          debug: true
        }).transform(coffeeify).bundle();
      });
    }))
    .pipe(streamify(concat('bundle.js')))
    .pipe(gulp.dest('./public/js'))
});

gulp.task('pug', function(){
  gulp.src('./src/client/**/**/*.jade')
    .pipe(pug())
    .pipe(gulp.dest('./public'))
});

gulp.task('stylus', function(){
  gulp.src('./src/client/stylus/style.styl')
    .pipe(stylus({
      'include css': true
    }))
    .pipe(gulp.dest('./public/css'))
});

gulp.task('test', function(done){
  new Server({
    configFile: __dirname + '/karma.conf.js',
    // singleRun: true
  }, done).start()
});

gulp.task('watch', function(){
  gulp.watch(['src/client/**/*.coffee', '!src/client/**/*.spec.coffee'], ['bundle']);
  gulp.watch('./src/client/**/**/*.jade', ['pug']);
  gulp.watch('./src/client/stylus/**/*.styl', ['stylus']);
});

gulp.task('default', ['bundle', 'pug', 'stylus', 'watch'])
