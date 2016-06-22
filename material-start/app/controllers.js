(function() {
  var app;

  app = angular.module("seismology");

  app.controller("DashboardCtrl", function($scope, $window, $state, $mdBottomSheet, $firebaseAuth, tabletop) {
    var e, entries, _i, _len;
    $scope.auth = $firebaseAuth();
    $scope.authData = $scope.auth.$getAuth();
    console.log($scope.auth.$getAuth());
    $scope.logout = function() {
      return $scope.auth.$signOut().then(function() {
        return $state.go('signin');
      });
    };
    $scope.showBottomSheet = function() {
      return $mdBottomSheet.show({
        templateUrl: 'templates/partial/action-bottom-sheet.html'
      });
    };
    entries = tabletop[0]['シート1']['elements'];
    for (_i = 0, _len = entries.length; _i < _len; _i++) {
      e = entries[_i];
      e['thumbnail'] = "resources/img/thumbnails/" + ("0000" + e['暫定ID']).substr(-5) + ".min.jpg";
      e.themes = e['主題別'];
      e.themes = e.themes.split(/[0-9]+\./).slice(1);
    }
    $window.entries = entries;
    console.log(entries);
    return $scope.entries = entries;
  });

  app.controller("SignInCtrl", function($scope, $state, $firebaseAuth) {
    var auth;
    auth = $firebaseAuth();
    $scope.signInWithGoogle = function() {
      console.log("google sign in");
      return auth.$signInWithPopup("google").then(function(user) {
        console.log("Signed in as:", user);
        return $state.go('dashboard');
      })["catch"](function(err) {
        return console.log(err);
      });
    };
    $scope.signInWithFacebook = function() {
      return auth.$signInWithPopup("facebook").then(function(user) {
        console.log("Signed in as:", user);
        return $state.go('dashboard');
      })["catch"](function(err) {
        return console.log(err);
      });
    };
    return $scope.signInWithTwitter = function() {
      return auth.$signInWithPopup("twitter").then(function(user) {
        console.log("Signed in as:", user);
        return $state.go('dashboard');
      })["catch"](function(err) {
        return console.log(err);
      });
    };
  });

  app.controller("TranscriptionCtrl", function($scope, $window, $stateParams, $firebaseAuth, $http, tabletop) {
    var entries, entry, path;
    console.log($stateParams);
    $scope.auth = $firebaseAuth();
    $scope.authData = $scope.auth.$getAuth();
    console.log($scope.auth.$getAuth());
    $scope.logout = function() {
      return $scope.auth.$signOut().then(function() {
        return $state.go('signin');
      });
    };
    entries = tabletop[0]['シート1']['elements'];
    entry = (entries.filter(function(e) {
      return e['暫定ID'] === $stateParams.id;
    }))[0];
    console.log(entry);
    $scope.entry = entry;
    $scope.id = parseInt(entry['暫定ID']);
    path = "../data/json/" + ("0000" + $scope.id).substr(-5) + ".json";
    console.log(path);
    return $http({
      method: 'GET',
      url: path
    }).success(function(data) {
      $scope.images = data.ResponseData.Results;
      return $scope.viewer = new $window.Viewer($window.document.getElementById('image'));
    });
  });

}).call(this);
