Ext.define 'GSW.view.transcription.state.ImageAnnotationState',
  extend: 'GSW.view.transcription.state.DefaultState'
  requires: [
    'GSW.model.ImageAnnotation'
    'GSW.view.transcription.ImageAnnotationPanel'
  ]
  onSwitchState: ->
    @drawMode = false
    @origin = null
    @rect = null

  mousedown: (event) ->
    unless @drawMode
      @drawMode = true
      @origin = @canvas.c.getPointer(event.e)
      model = Ext.create 'GSW.model.ImageAnnotation'
      options =
        width: 0
        height: 0
        left: @origin.x
        top: @origin.y
        canvas: @canvas.c
      @rect = new fabric.AnnotationRect options
      @panel = Ext.create 'GSW.view.transcription.ImageAnnotationPanel',
        target: @rect
        canvas: @canvas
        model: model
      @canvas.c.add(@rect)
      @canvas.c.renderAll()
    
  mousemove: (event) ->
    if @drawMode
      mouse = @canvas.c.getPointer(event.e)
      w = Math.abs(mouse.x - @origin.x)
      h = Math.abs(mouse.y - @origin.y)
      @rect.set("width",w).set("height",h)
      @canvas.c.renderAll()

  mouseout: (event) ->
    @_onZoneCreated event

  mouseup: (event) ->
    @_onZoneCreated event

  _onZoneCreated: (event) ->
    @drowMode = false
    @rect = null
    @panel.showPanel()
    @canvas.resetState()    

  showAnnotationPanel: (rect) ->


  hideAnnotationPanel: (rect) ->

