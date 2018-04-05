(->
  RemovalModalController = ($uibModalInstance, entity, caption)->
    init = ()=>
      @entity = entity
      @caption = caption
      @ok = ()-> $uibModalInstance.close()
      @cancel = ()-> $uibModalInstance.dismiss()

    init()
    return

  RemovalModalController.$inject = ['$uibModalInstance', 'entity', 'caption']

  require('angular')
    .module('common')
    .controller('RemovalModalController', RemovalModalController)
)()
