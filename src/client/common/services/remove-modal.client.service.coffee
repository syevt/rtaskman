(->
  RemoveModal = ($uibModal)->
    open: (modalOptions)->
      $uibModal.open
        templateUrl: 'common/views/remove-modal.client.view.html'
        size: 'sm'
        controller: ($uibModalInstance)->
          @options = modalOptions
          @ok = ()-> $uibModalInstance.close()
          @cancel = ()-> $uibModalInstance.dismiss()
          return
        controllerAs: 'vm'

  RemoveModal.$inject = ['$uibModal']

  require('angular').module('common').factory('RemoveModal', RemoveModal)
)()
