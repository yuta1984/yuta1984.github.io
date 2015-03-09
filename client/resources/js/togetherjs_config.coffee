getParameterByName= (name) ->
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
  regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
  results = regex.exec(location.search)
  if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))
window.TogetherJSConfig_useMinimizedCode = true
window.TogetherJSConfig_findRoom = getParameterByName("projectId")
window.TogetherJSConfig_siteName = "SMART-GS Web"
window.TogetherJSConfig_dontShowClicks = true
window.TogetherJSConfig_suppressJoinConfirmation = true
window.TogetherJSConfig_suppressInvite = true
window.TogetherJSConfig_ignoreForms = true
window.TogetherJSConfig_autoStart = true;
# window.TogetherJSConfig_getUserName =->
#   GSW.app.project.get("owner").get("username")
