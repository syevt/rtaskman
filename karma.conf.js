module.exports = function(config) {
  config.set({
    basePath: 'src/client',

    frameworks: ['mocha', 'chai'],

    preprocessors: {
      '**/*.spec.coffee': ['coffee']
    },

    coffeePreprocessor: {
      options: {
        bare: true,
        sourceMap: false
      },
      transformPath: function(path){
        return path.replace(/\.coffee$/, '.js')
      }
    },

    files: [
      '**/**/*.spec.coffee',
      {pattern: '../../public/js/bundle.js', included: false, watched: true}
    ],

    exclude: [
    ],

    reporters: ['mocha'],

    mochaReporter: {
      output: 'minimal',
      showDiff: true,
      divider: ''
    },

    port: 9876,

    colors: true,

    logLevel: config.LOG_INFO,

    autoWatch: true,

    browsers: ['PhantomJS'],

    singleRun: false,

    concurrency: Infinity
  })
}
