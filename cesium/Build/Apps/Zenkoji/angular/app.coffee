app = angular.module('zenkoji', ['ngMaterial', "ui.router"])

app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise('/tab/dash')

  state = $stateProvider.state
  state 'view1',
    url: '/view1'
    templateUrl: 'partials/view1.html'
  state 'view2',
    url: '/view2'
    templateUrl: 'partials/view2.html'
  state 'view3',
    url: '/view3'
    templateUrl: 'partials/view3.html'

app.controller 'tabCtrl', ($scope, $location, $log) ->
  $scope.selectedIndex = 0
  $scope.$watch 'selectedIndex', (current, old) ->
    switch current
      when 0
        $location.url '/view1'
      when 1
        $location.url '/view2'
      when 2
        $location.url '/view3'
