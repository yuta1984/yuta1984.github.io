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





    
window.SourceDocCanvas = SourceDocCanvas
