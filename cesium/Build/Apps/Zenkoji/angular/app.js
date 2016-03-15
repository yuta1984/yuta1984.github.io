(function() {
  var app;

  app = angular.module('zenkoji', ['ngMaterial', "ui.router"]);

  app.config(function($stateProvider, $urlRouterProvider) {
    var state;
    $urlRouterProvider.otherwise('/tab/dash');
    state = $stateProvider.state;
    state('view1', {
      url: '/view1',
      templateUrl: 'partials/view1.html'
    });
    state('view2', {
      url: '/view2',
      templateUrl: 'partials/view2.html'
    });
    return state('view3', {
      url: '/view3',
      templateUrl: 'partials/view3.html'
    });
  });

  app.controller('tabCtrl', function($scope, $location, $log) {
    $scope.selectedIndex = 0;
    return $scope.$watch('selectedIndex', function(current, old) {
      switch (current) {
        case 0:
          return $location.url('/view1');
        case 1:
          return $location.url('/view2');
        case 2:
          return $location.url('/view3');
      }
    });
  });

}).call(this);
