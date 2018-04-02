(->
  removalModal = ($uibModal)->
    open: (modalOptions)->
      $uibModal.open
        templateUrl: 'common/views/removal-modal.client.view.html'
        size: 'sm'
        controller: ($uibModalInstance)->
          @options = modalOptions
          @ok = ()-> $uibModalInstance.close()
          @cancel = ()-> $uibModalInstance.dismiss()
          return
        controllerAs: 'vm'

  removalModal.$inject = ['$uibModal']

  require('angular').module('common').factory('removalModal', removalModal)
)()
