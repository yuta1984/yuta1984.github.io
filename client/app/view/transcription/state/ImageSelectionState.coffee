Ext.define 'GSW.view.transcription.state.ImageSelectionState',
  extend: 'GSW.view.transcription.state.DefaultState'
  requires: [
    'GSW.model.ImageAnnotation'
    'GSW.view.transcription.ImageAnnotationPanel'
    'GSW.view.transcription.menu.CanvasContextMenu'
    'GSW.view.transcription.form.ImageAnnotationForm'
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
    console.log @region
    model = @_createRegionModel(@region)
    @canvas.attatchAnnotationPanel(model)
    @_showAnnotationForm(model)
    @region = null  
    @canvas.resetState()    
  
  _createRegionModel: (region)->
    image = @canvas.getImageModel()
    config =
      x: Math.ceil region.get('left')
      y: Math.ceil region.get('top')
      w: Math.ceil region.get('width')
      h: Math.ceil region.get('height')
      image: image
      user: GSW.app.me
      user_id: GSW.app.me.id
    model = new GSW.model.Region(config)
    region.model = model
    model.view = region
    image.regions().add model
    model

  _showAnnotationForm: (model)->    
    form = Ext.create 'GSW.view.transcription.form.ImageAnnotationForm',
      model: model
      canvas: @canvas
    form.show()
