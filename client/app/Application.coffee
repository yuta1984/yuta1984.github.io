###*
The main application class. An instance of this class is created by app.js when it calls
Ext.application(). This is the ideal place to handle application launch and initialization
details.
###
Ext.define "GSW.Application",
  extend: "Ext.app.Application"
  name: "GSW"
  appProperty: 'app'
  stores: [
    "GSW.store.ResourceStore"
    "GSW.store.UserStore"
  ]
  models: [
    "GSW.model.Project"
    "GSW.model.User"
    "GSW.model.Manuscript"
    "GSW.model.Image"        
    "GSW.model.Surface"
    "GSW.model.Zone"
    "GSW.model.AbstractAnnotation"
    "GSW.model.ImageAnnotation"
    "GSW.model.TextAnnotation"        
  ]
  launch: ->
    @fetchProject (data) =>
      data = JSON.parse(data.responseText)
      console.log data
      @loadProject(data)
      Ext.getBody().unmask()   
      
    
  loadGoogleMap: ->
    # opts =
    #   zoom: 3
    #   mapTypeId: google.maps.MapTypeId.ROADMAP
    #   center: new google.maps.LatLng(0.0, 0.0)
    #   mapTypeId: google.maps.MapTypeId.ROADMAP
    script = document.createElement('script')      
    script.type = 'text/javascript'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&callback=initializ
  e'
    document.body.appendChild(script)

  fetchProject: (callback)->
    Ext.getBody().mask("Loading...")    
    projectId = @getParameterByName("projectId")
    Ext.Ajax.request
      withCredentials: true
      url: "#{@getServerURL()}/projects/#{projectId}.json"
      success: callback
    
  loadProject: (data)->
    # init project
    @project = GSW.model.Project.fromJSON(data)
    console.log root: @project.toTreeModel()
    store=Ext.getStore("GSW.store.ResourceStore")
    Ext.getCmp("navigation-tree-panel").setTitle(@project.get('name'))
    store.setRootNode @project.toTreeModel()

  getProject: ->
    @project

  getServerURL: ->
    if document.URL =~ /localhost/
      "http://localhost:3000"
    else
      "https://gsweb.herokuapp.com"

  getParameterByName: (name) ->
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
    regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
    results = regex.exec(location.search)
    if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))
  

