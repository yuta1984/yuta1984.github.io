app = angular.module("seismology")

app.controller "DashboardCtrl", ($scope, $window, $state, $mdBottomSheet, $firebaseAuth, tabletop) ->
  $scope.auth = $firebaseAuth()
  $scope.authData = $scope.auth.$getAuth()
  console.log $scope.auth.$getAuth()
  $scope.logout = ->
    $scope.auth.$signOut().then ->
      $state.go('signin')
  $scope.showBottomSheet = ->
    $mdBottomSheet.show
      templateUrl: 'templates/partial/action-bottom-sheet.html'
  entries = tabletop[0]['シート1']['elements']
  for e in entries
    e['thumbnail'] = "resources/img/thumbnails/"+("0000"+e['暫定ID']).substr(-5)+".min.jpg"
    e.themes = e['主題別']
    e.themes = e.themes.split(/[0-9]+\./).slice(1)
  $window.entries = entries
  console.log entries
  $scope.entries = entries
  

app.controller "SignInCtrl", ($scope, $state, $firebaseAuth) ->
  auth = $firebaseAuth()

  $scope.signInWithGoogle = ->
    console.log("google sign in")  
    auth.$signInWithPopup("google")
      .then (user) ->
        console.log("Signed in as:", user)
        $state.go('dashboard')
      .catch (err) ->
        console.log(err)

  $scope.signInWithFacebook = ->
    auth.$signInWithPopup("facebook")
      .then (user) ->
        console.log("Signed in as:", user)
        $state.go('dashboard')
      .catch (err) ->
        console.log(err)
  
  $scope.signInWithTwitter = ->
    auth.$signInWithPopup("twitter")
      .then (user) ->
        console.log("Signed in as:", user)
        $state.go('dashboard')
      .catch (err) ->
        console.log(err)


app.controller "TranscriptionCtrl", ($scope, $window, $stateParams, $firebaseAuth, $http, tabletop) ->
  console.log $stateParams
  $scope.auth = $firebaseAuth()
  $scope.authData = $scope.auth.$getAuth()
  console.log $scope.auth.$getAuth()
  $scope.logout = ->
    $scope.auth.$signOut().then ->
      $state.go('signin')

  entries = tabletop[0]['シート1']['elements']
  entry = (entries.filter (e)-> e['暫定ID']==$stateParams.id)[0]
  console.log entry
  $scope.entry = entry
  $scope.id = parseInt(entry['暫定ID'])

  # load image data
  path = "../data/json/" + ("0000"+$scope.id).substr(-5) + ".json"
  console.log path
  $http(method: 'GET', url: path)
    .success (data) ->
      $scope.images= data.ResponseData.Results
      $scope.viewer = new $window.Viewer($window.document.getElementById('image'))
