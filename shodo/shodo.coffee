unless Shodo then Shodo = {}
window.Shodo = Shodo


class Shodo.App
  constructor: (canvas) ->
    @canvas = canvas
    @manager = new Shodo.StrokeManager(canvas)
    
    $(canvas).on "mousedown touchstart", (e)=>
      @mousedown(e)
      e.preventDefault()
    $(canvas).on "mousemove touchmove", (e)=>      
      @mousemove(e)
      e.preventDefault()
    $(canvas).on "mouseup touchend", (e)=>
      @mouseup(e)
      e.preventDefault()

    $("#clear").click ->
      ctx = @canvas.getContext('2d')
      ctx.clearRect(0,0, @canvas.width, @canvas.height)

  mousedown: (e) ->
    @isMouseDown = true
    @manager.reset()    
    
  mousemove: (e)->    
    if e.originalEvent and e.originalEvent.changedTouches
      x= e.originalEvent.changedTouches[0].pageX
      y= originalEvent.changedTouches[0].pageY
    else
      x= e.pageX
      y= e.pageY      
    @currentPos = x: x, y: y, t: new Date().getTime()
    if @isMouseDown
      @manager.draw(@currentPos)
  
  mouseup: (e) ->
    @isMouseDown = false

    
class Shodo.StrokeManager
  constructor: (canvas) ->
    @canvas = canvas
    @selectBrush(Shodo.Brush.medium)

  selectBrush: (brush) ->
    @brushImage = brush.image
    @maxBrushSize = brush.maxSize
    @minimumBrushSize = brush.minimumSize

  getDistance: (p1, p2) ->
    Math.sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y))

  reset: ->
    @previousPos = null
    @previousPos = null
    @previousBrushSize = null
    @previousVelocity = null
    @previousDistance = null
      
  draw: (pos)->
    unless @previousPos
      @previousPos = pos
    t = (pos.t - @previousPos.t)
    distance = @getDistance(pos, @previousPos)    
    velocity = distance / t
    accelerate = (@previousVelocity == 0) ? 0 : velocity / @previousVelocity
    brushSize = Math.min(@minimumBrushSize)
    @drawStroke @previousPos, pos, brushSize, distance
    @previousPos = pos
    @previousVelocity = velocity
    @previousDistance = distance
    @previousBrushSize = brushSize

  drawStroke: (startPos, endPos, brushSize, distance)->
    t = 0
    brushDelta = brushSize - @previousBrushSize
    while t < 1
      brushSizeCur = brushSize - (t*brushDelta)
      console.log brushSizeCur
      pos = @getInterlatePos(startPos, endPos, t)
      if Math.random() > 0.2
        jitter = ((Math.random() > 0.5) ? 1 : -1) * parseInt(Math.random() * 1.2, 10)
        px = pos.x - brushSizeCur/2+jitter
        py = pos.y - brushSizeCur/2+jitter
        ctx = @canvas.getContext('2d')
        ctx.drawImage(@brushImage, px, py, brushSizeCur, brushSizeCur)
      t += 1 / distance
        
    
  
  getInterlatePos: (p0, p1, moveLen) ->
    x = p0.x + (p1.x - p0.x)*moveLen;
    y = p0.y + (p1.y - p0.y)*moveLen;
    { x:x, y:y };



#   initialize: (canvas) ->
#     @canvas = canvas
#     @_points = []

#   onMouseDown: (pointer) ->
#     @_captureDrawingPath(pointer)
#     @_render()

#   onMouseMove: (pointer) ->
#     @_captureDrawingPath(pointer)
#     @canvas.clearContext(this.canvas.contextTop)
#     @_render()

#   onMouseUp: ->
#     @_finalizeAndAddPath()

#   _prepareForDrawing: (pointer) ->
#     p = new fabric.Point(pointer.x, pointer.y)
#     @_reset()
#     @_addPoint(p)
#     @canvas.contextTop.moveTo(p.x, p.y)

#   _addPoint: (point) ->
#     @_points.push point

#   _reset: ->
#     @_points.length = 0
#     @_setBrushStyles()
#     @_setShadow()

#   _captureDrawingPath: (pointer) ->
#     pointerPoint = new fabric.Point(pointer.x, pointer.y)
#     @_addPoint(pointerPoint)

#   _render: ()->
#     ctx  = @canvas.contextTop
#     v = @canvas.viewportTransform
#     p1 = @_points[0]
#     p2 = @_points[1]
#     ctx.save()
#     ctx.transform(v[0], v[1], v[2], v[3], v[4], v[5])
#     for p in @_points
#       ctx.drawImage(Shodo.BrushImages.Original, p.x, p.y)

#   _finalizeAndAddPath: ->
#     ctx = @canvas.contextTop
#     ctx.closePath()
#     @canvas.clearContext(this.canvas.contextTop)
#     @canvas.renderAll()
    

Shodo.Util =
  createImage: (url) ->
    image = document.createElement('img')
    image.src = url
    image

#   # createBrushImage: (originalImage, brushColor, width, height) ->
#   #   tmpCanvas = document.createElement('canvas')
#   #   tmpCanvas.width = width
#   #   tmpCanvas.height = height
#   #   ctx = tmpCanvas.getContext('2d')
#   #   ctx.drawImage(originalBrushImage, 0, 0)
#   #   imageData = ctx.getImageData(0, 0, tmpCanvas.width, tmpCanvas.height)
#   #   for (i = 0, n = imageData.data.length / 4; i < n; i++)
#   #     imageData.data[(i * 4)] = (brushColor & 0xff0000) >> 16
#   #     imageData.data[(i * 4) + 1] = (brushColor & 0x00ff00) >> 8
#   #     imageData.data[(i * 4) + 2] = (brushColor & 0x0000ff)
#   #   ctx.putImageData(imageData, 0, 0)      

#   #   tmpCanvas2 = document.createElement('canvas')
#   #   tmpCanvas2.width = width
#   #   tmpCanvas2.height = height
#   #   ctx2 = tmpCanvas2.getContext('2d')
#   #   for (i = 0; i < 15; i++)    
#   #     ctx2.drawImage(tmpCanvas, 0, 0)
      
#   #   img = document.createElement('img')
#   #   img.src = tmpCanvas2.toDataURL()
#   #   img

Shodo.Brush =
  medium:
    maxSize: 90
    minimumSize: 45
    image: Shodo.Util.createImage("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFoAAABaCAYAAAA4qEECAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAOOSURBVHja7JxfhFRRHMfPNAzLsAzDEvu0REQZNjHEUC89xRI9TeplX3uKEkv0usxTbCKWlrVPPSR6SL1sdm12FWvZlNKIsllapUy/0/yuPffOnZlz555zu+fe75eP/Wt29nPPnPs7/6bQ6XQEYj9HoACiIRqBaIiGaASiIRqBaIiGaASiIRqBaIjOeeR8tIqSElEjJmDJgNcBomfl7yvsEgvERWIcKs2ILhI7AdEqP4lF4hyUxhNdHyA5yA63/jHojS66FUG0x1dijqhAs77ojRFEe+wT88RRiB4susR9cCcm8jHuEccgOlz0lAHJQR4RDYj2i65ZEK2WiLfz0K3oiK5bFK3ylJjJ6oAo6LUQ3KlUKBRO0IfNhJ/XB+KVwjbRdl20z2uIaPmy/piS5yuFfyde89dviQP+/JNyMQ74Z06JFlyilR1uUN4F+UVs8ffafHG2+RX0Lg2i1/immPVssfCXxBPlohgX3W/AMp/QDTFtyNHtCtGMO6WgOzK8kFPRKl94SqFqU7S8mj8g2zfCLdsQLfMQkn1sRmndUUTXIbeHFzwXZFR03Fm8rDJnQ/QMxIb22cdNiy6iVfftQoomRaOv7s+sadGCyxvI7R3cVEyLrvADQ7Cfu6ZFy1yF2NAb45Rp0RjE9F+mMy5aDkPfQG4PddOiBdeQ+5DrYyNY7pkQLXMJcgeXe6ZEy1yH3J5yb8KGaMHlDSQf8sCWaJlFCPaVe9Uw0SZ2/F8hlgUieAq1qTeCGS1FftmgVfOeGBtdh5oWRP9j3LZomTsQLRo2+uhgbhHXePNKXtOzidPW8bf7xHnh+P65GBlLSrTMc+K0yd0/DqVtq+oYdnXzNus3mcTNcND8yF4OJO/aGrDoZok4JbobCrOcJZsDlqiDm5vCzIGkNLbmchIDliiRp7WeZa1+tjmpFDfNjCz8tmzNR5uMXGWXWxp+O7zCUnJBtLpMtuKY5D0Rcmg17aK9TIvutisXVlWmtYqMlIr2cpZ4nFLJq6LPng4XRatdykJKSsLPxOVhT9hV0V7kMtEN8f/2lrSE5hEL10WrqfE/nkRp+F503+JIO1kSrabBCw6rFsq2kd5dR+csuOtzDVW+iZ7hiuCk0D9R9UccnkdfjjMvo3tyNmuR8ie5ZYYdi5CnZ78R66b+4FDRiJ3gnRwhGqIRiIZoiIYCiIZoBKIhGqIRiIZoBKIhGqIRiM5Q/gowAMsRJLrK/gy+AAAAAElFTkSuQmCC")

Shodo.BrushImages =
  Kasure: Shodo.Util.createImage("data:image/png;base64,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")









