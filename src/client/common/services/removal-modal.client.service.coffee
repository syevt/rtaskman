(->
  removalModal = ($uibModal)->
    open: (entity, caption)->
      $uibModal.open
        templateUrl: 'common/views/removal-modal.client.view.html'
        size: 'sm'
        controller: 'RemovalModalController as vm'
        resolve:
          entity: ()-> entity
          caption: ()-> caption

  removalModal.$inject = ['$uibModal']

  require('angular').module('common').factory('removalModal', removalModal)
)()
