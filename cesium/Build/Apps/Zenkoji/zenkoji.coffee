SHEET_KEY= "10k-arsvozpn1y5U-3OwfM_qYPNQTMN7UIJilHHNJrjs"


loadLocations= (callback) ->
  console.log "load locations"
  locations = {}
  Tabletop.init
    key: SHEET_KEY
    simpleSheet: false
    callback: (data) ->
      console.log data
      for d in data["Location master"].elements
        continue unless d["Coordinates"].length > 0
        locations[d["Name ENG"]] = 
          name: d["Name ENG"]
          type: d["Type"]
          lat: parseFloat(d["Coordinates"].split(", ")[0])
          long: parseFloat(d["Coordinates"].split(", ")[1])
          alt: parseFloat(d["Altitude"])
          comment: d["Comment"]
          damages: []
          im: d["im"]+".png"
      for d in data["Damage descriptions"].elements
        locName = d["English location name"]
        location = locations[locName]
        continue unless location
        location.damages.push d      
      callback(locations)

generateDescriptions = (location)->
  descriptionHTML = ""
  for d in location.damages
    name = location.name
    id = d["XML ID"]
    types = d["Type"]
    text = d["Text"]
    text = text.replace(location.name, "<span style='color: yellow; font-weight: bold;'>#{name}</span>")
    descriptionHTML += """
      <div style="padding: 5px;">
        <p style="color: red; font-size: 18px;">#{types}</p>
        <div>...#{text}...</div>
        <a href="transcription/shinetsu.html##{id}" target="_blank" style="color: blue;">View source</a>
      </div>
    """
  descriptionHTML

generateBillboard = (location) ->
  width = if location["im"].length is 6 then 100 else 50
  new Cesium.BillboardGraphics
    image: location["im"]
    width: width
    height: 50
   
setupViewer = ->
  viewer = new Cesium.Viewer 'mapdiv',
    animation : true
    baseLayerPicker: false
    fullscreenButton: false
    geocoder: false
    homeButton: false
    navigationHelpButton: false
    sceneModePicker: false
    scene3DOnly: true
    timeline: false
    imageryProvider: new Cesium.OpenStreetMapImageryProvider
      url: '//cyberjapandata.gsi.go.jp/xyz/relief/'
    terrainProvider: new Cesium.JapanGSITerrainProvider
      heightPower: 2.0
  layers = viewer.scene.imageryLayers;
  osm = layers.addImageryProvider(new Cesium.OpenStreetMapImageryProvider()) 
  osm.alpha = 0.6
  viewer

  
viewer = setupViewer()
fire = 'fh.png'        
loadLocations (locations) ->
  console.log locations
  for name, l of locations
    descHTML = generateDescriptions(l)
    viewer.entities.add
      name: name
      position: Cesium.Cartesian3.fromDegrees(l.long, l.lat, l.alt*2)
      description: descHTML
      billboard: generateBillboard(l)
      point:
        pixelSize : 5
        color : Cesium.Color.RED
        outlineColor : Cesium.Color.WHITE
        outlineWidth : 2
      label : 
        text : name
        font : '12pt monospace'
        style: Cesium.LabelStyle.FILL_AND_OUTLINE
        outlineWidth : 2
        verticalOrigin : Cesium.VerticalOrigin.BOTTOM
        pixelOffset : new Cesium.Cartesian2(0, 30)  
  viewer.zoomTo(viewer.entities)

