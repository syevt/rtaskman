(->
  tmNewProjectForm = ()->
    restrict: 'E'
    replace: on
    templateUrl: 'projects/directives/templates/\
      new-project-form.client.template.html'

  require('angular')
    .module('projects')
    .directive('tmNewProjectForm', tmNewProjectForm)
)()
