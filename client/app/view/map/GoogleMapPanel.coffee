Ext.define 'GSW.view.map.GoogleMapPanel',
  extend: 'Ext.panel.Panel'
  id: 'gmap-panel'
  requires: ["Ext.ux.GMapPanel"]
  xtype: 'google-map-panel'    
  width: '100%'
  height: '100%'
  layout: 'fit'
  
  constructor: (config) ->    
    @callParent(config)
    @

  listeners:
    afterrender: (panel) =>
      panel.drawMap()
      
  drawMap: ->
    opts =
      zoom: 8
      mapTypeId: google.maps.MapTypeId.ROADMAP
      center: new google.maps.LatLng(35.0117, 135.7683)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("gmap-panel"), opts)  
  
    
