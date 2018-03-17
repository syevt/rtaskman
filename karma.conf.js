module.exports = function(config) {
  config.set({
    basePath: 'src/client',

    frameworks: ['mocha', 'chai', 'sinon'],

    preprocessors: {
      '**/*.spec.coffee': ['coffee'],
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
      {pattern: '../../public/js/bundle.js', included: true, watched: true},
      {
        pattern: '../../node_modules/angular-mocks/angular-mocks.js',
        included: true, watched: false
      },
      {
        pattern: '../../node_modules/sinon-chai/lib/sinon-chai.js',
        included: true, watched: false
      },
      {
        pattern: '../../node_modules/bardjs/bard.js',
        included: true, watched: false
      },
      '**/*.spec.coffee'
    ],

    client: {
      mocha: {
        reporter: 'html',
        ui: 'bdd'
      }
    },

    exclude: [
    ],

    reporters: ['mocha'],

    mochaReporter: {
      showDiff: true,
      // showDiff: 'inline',
    },

    port: 9876,

    colors: true,

    logLevel: config.LOG_INFO,

    autoWatch: true,

    // browsers: ['PhantomJS', 'Firefox'],
    browsers: ['PhantomJS'],

    singleRun: false,

    concurrency: Infinity
  })
}
