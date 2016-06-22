(function() {
  var app;

  app = angular.module("seismology", ['ngMaterial', 'ui.router', 'times.tabletop', 'firebase']);

  app.config(function($mdThemingProvider, $mdIconProvider) {
    $mdIconProvider.defaultIconSet("./assets/svg/avatars.svg", 128).icon("menu", "./assets/svg/menu.svg", 24).icon("share", "./assets/svg/share.svg", 24).icon("google_plus", "./assets/svg/google_plus.svg", 512).icon("hangouts", "./assets/svg/hangouts.svg", 512).icon("twitter", "./assets/svg/twitter.svg", 512).icon("phone", "./assets/svg/phone.svg", 512);
    return $mdThemingProvider.theme('default').primaryPalette('blue').accentPalette('red');
  });

  app.config(function($stateProvider, $urlRouterProvider, TabletopProvider) {
    TabletopProvider.setTabletopOptions({
      key: 'https://docs.google.com/spreadsheets/d/1YcW3byuB2opCCjo89jFWTFGHuKUn3x-y2O0onqX1Kc0/pubhtml'
    });
    $stateProvider.state('dashboard', {
      url: '/dashboard',
      controller: 'DashboardCtrl',
      templateUrl: 'templates/dashboard.html',
      resolve: {
        tabletop: 'Tabletop'
      }
    });
    $stateProvider.state('signin', {
      url: '/sign_in',
      controller: 'SignInCtrl as signin',
      templateUrl: 'templates/sign_in.html'
    });
    $stateProvider.state('transcription', {
      url: '/transcription/:id',
      controller: 'TranscriptionCtrl',
      templateUrl: 'templates/transcription.html',
      resolve: {
        tabletop: 'Tabletop'
      }
    });
    return $urlRouterProvider.otherwise("/sign_in");
  });

}).call(this);
