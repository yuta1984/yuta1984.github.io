window.canvas = SourceDocCanvas

class Surface 

  constructor: (imgURL, config={}) ->
      
class Zone extends fabric.Rect

  constructor: ->
    super()
      
window.Zone = Zone


class SourceDocCanvas
  constructor: (canvasId, config={}) ->
    @c = new fabric.CanvasWithViewport(canvasId)
    @bindEventListeners()
    @setBackgroundImg("http://www.ancestorsremembered.com/Capt%20Dave/hannah_handwriting.jpg")    
    rect = new fabric.Rect
      width: 50
      height: 50
      left: 50
      top: 50
      strokeWidth: 1
      stroke: 'red'
      fill: "rgba(0,0,0,0)"
    @c.add rect


  bindEventListeners: ->
    
    @c.on "object:scaling", (e) =>
      activeObject = @c.getActiveObject()
      console.log activeObject.scaleX, activeObject.scaleY
      activeObject.set 'strokeWidth', 1/activeObject.scaleX
      console.log activeObject.strokeWidth            
      
    @c.on "object:moving", (e) =>
      
    @c.on "object:modified", (e) =>

    @c.on "object:selected", (e) =>
      console.log e

    @c.on "selection:cleared", (e) =>

    @c.on "mouse:move", (e) =>
      
    @c.on "mouse:up", (e) =>
      console.log "mouseup"

    @c.on "mouse:down", (e) =>
      console.log "mousedown"

    # マウスホイールによるズーム
    $(@c.wrapperEl).on "mousewheel", (e) =>
      delta = e.originalEvent.wheelDelta/1000
      if (@c.viewport.zoom > 0.5 and delta <0) or (@c.viewport.zoom < 10.0 and delta > 0)
        @c.setZoom @c.viewport.zoom + delta
      e.stopPropagation()
      e.preventDefault()

    $(@c.wrapperEl).on "mousedown", (e) =>
      console.log "mousedown on el"

    $(@c.wrapperEl).on "mouseup", (e) =>
      console.log "mouseup on el"
      

  loadSurface: (surface) ->
    

  setBackgroundImg: (url) ->
    fabric.Image.fromURL url, (img) =>
      @c.remove(@img) if @img
      @img = img
      @img.set('selectable', false)
      @c.add(@img)
      @img.moveTo(-1)      

  setGrabMode: (bool=true) ->
    @c.isGrabMode = bool
    console.log "grabmode: #{bool}"

  isGrabMode: ->
    @c.isGrabMode

  zoom: (ratio) ->
    @c.setZoom(@c.viewport.zoom*ratio)



    
window.SourceDocCanvas = SourceDocCanvas
