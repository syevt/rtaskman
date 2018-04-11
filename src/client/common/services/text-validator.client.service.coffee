(->
  textValidator = (growl, $translate)->
    validate: (text)->
      regex = /^[\u00BF-\u1FFF\u2C00-\uD7FF\w.,\-\/\(\)"'`?!\s]+$/
      switch
        when not text
          growl.error($translate.instant('common.emptyError'))
          off
        when not regex.test(text)
          growl.error($translate.instant('common.invalidError'))
          off
        else on

  textValidator.$inject = ['growl', '$translate']

  require('angular').module('common').factory('textValidator', textValidator)
)()
