Ext.define 'GSW.view.transcription.state.DefaultState',
  constructor: (config) ->
    unless config.canvas      
      Ext.Error.raise msg: "canvas component not given" 
    @canvas = config.canvas
    @callParent(config)

  onSwitchState: ->
    @grabMode = false
    @currentPos = null

  mouseup: (event) ->
    @grabMode = false

  mousedown: (event) ->
    unless @canvas.c.getActiveObject()      
      @grabMode = true
      @currentPos = x: event.e.offsetX, y: event.e.offsetY 

  mousemove: (event) ->          
    if @grabMode
      nextPos =
        x: event.e.offsetX, y: event.e.offsetY
      delta =
        x: @currentPos.x - nextPos.x, y: @currentPos.y - nextPos.y
      @canvas.moveViewportBy delta
      @currentPos = nextPos        

  mousewheel: (event) ->
    delta = event.originalEvent.wheelDelta/1500
    @canvas.setZoom(@canvas.zoom+delta)
    event.stopPropagation()
    event.preventDefault()

  mouseout: (event) ->
    @grabMode = false    
