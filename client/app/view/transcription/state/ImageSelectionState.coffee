Ext.define 'GSW.view.transcription.state.ImageSelectionState',
  extend: 'GSW.view.transcription.state.DefaultState'
  requires: [
    'GSW.model.ImageAnnotation'
    'GSW.view.transcription.ImageAnnotationPanel'
    'GSW.view.transcription.menu.CanvasContextMenu'
  ]
  Onswitchstate: ->
    @drawMode = false
    @origin = null
    @region = null

  mousedown: (event) ->
    unless @drawMode
      @drawMode = true      
      @origin = @canvas.c.getPointer(event.e)
      options =
        width: 0
        height: 0
        left: @origin.x
        top: @origin.y
        canvas: @canvas.c
      @region = new fabric.Region(options)
      @canvas.c.add(@region)
      @canvas.c.renderAll()
      console.log @region      
    
  mousemove: (event) ->
    if @drawMode
      mouse = @canvas.c.getPointer(event.e)
      w = Math.abs(mouse.x - @origin.x)
      h = Math.abs(mouse.y - @origin.y)
      @region.set("width",w).set("height",h)
      @canvas.c.renderAll()

  mouseout: (event) ->
    @_onZoneCreated event

  mouseup: (event) ->
    @_onZoneCreated event

  _onZoneCreated: (event) ->
    @drawMode = false
    console.log @region.get('left'),@region.get('top'),@region.get('width'),@region.get('height')
    @_createRegionModel(@region)
    @region = null
    @_showMenu(event)    
    @canvas.resetState()    
  _showMenu: (event)->
    menu = Ext.create("GSW.view.transcription.menu.CanvasContextMenu", canvas: @canvas)
    menu.showAt event.e.clientX, event.e.clientY

  _createRegionModel: (region)->
    config =
      x: Math.ceil region.get('left')
      y: Math.ceil region.get('top')
      w: Math.ceil region.get('width')
      h: Math.ceil region.get('height')
      image: @canvas.getImageModel()
    model = GSW.model.Region.create(config)
    model
