Ext.define 'GSW.view.transcription.state.DrawingState',
  extend: 'GSW.view.transcription.state.DefaultState'
  requires: ['GSW.model.Zone']
  onSwitchState: ->
    @drawMode = false
    @origin = null
    @zone = null

  mousedown: (event) ->
    unless @drawMode
      @drawMode = true
      @origin = @canvas.c.getPointer(event.e)
      zoneModel = Ext.create 'GSW.model.Zone'
      @zone = new fabric.Zone
        width: 0
        height: 0
        left: @origin.x
        top: @origin.y
        canvas: @canvas.c
        model: zoneModel
      @canvas.c.add(@zone)
      @canvas.c.renderAll()
      @canvas.c.setActiveObject(@zone)      
    
  mousemove: (event) ->
    if @drawMode
      mouse = @canvas.c.getPointer(event.e)
      w = Math.abs(mouse.x - @origin.x)
      h = Math.abs(mouse.y - @origin.y)
      @zone.set("width",w).set("height",h)
      @canvas.c.renderAll()

  mouseout: (event) ->
    @_onZoneCreated event

  mouseup: (event) ->
    @_onZoneCreated event

  _onZoneCreated: (event) ->
    @zone?.updateModel() 
    @drowMode = false
    @zone = null    
    @canvas.resetState()    


