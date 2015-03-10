fabric.Zone = fabric.util.createClass fabric.Rect, fabric.Observable,

  type: 'tei-zone'
  transparentCorners: false
  hasRotatingPoint: false
  stroke: 'red'
  strokeWidth: 1
  fill: 'rgba(0,200,0,0.1)'
  
  initialize: (options) ->
    @callSuper('initialize', options)
    throw 'canvas object not given' unless @canvas = options.canvas
    throw 'model object not given' unless @model = options.model
    
    @on "modified", ->
      @updateModel(@)

  updateModel: ->
    @model.update(@)

  getModel: ->
    @model


fabric.AnnotationRect = fabric.util.createClass fabric.Group, fabric.Observable,

  transparentCorners: false
  hasRotatingPoint: false
  originX: 'left'
  originY: 'top'
  selectable: false

  initialize: (options, callback) ->
    throw 'canvas object not given' unless @canvas = options.canvas
    
    @callSuper('initialize',[], options)
    ratio = @canvas.getZoom()
    @rect = new fabric.Rect
      transparentCorners: false
      hasRotatingPoint: false
      stroke: 'black'
      strokeWidth: 1/ratio
      fill: 'rgba(0,0,0,0)'
      left: options.left
      top: options.top
      width: options.width
      height: options.height
      originX: 'center'
      originY: 'center'
    @rectInside = new fabric.Rect
      transparentCorners: false
      hasRotatingPoint: false
      stroke: 'white'
      strokeWidth: 1/ratio
      fill: 'rgba(0,0,0,0)'
      left: options.left
      top: options.top
      width: options.width-2
      height: options.height-2      
      originx: 'center'
      originY: 'center'
    @add @rect
    @add @rectInside
    @bindEventListeners()
    @
      
  bindEventListeners: ->
    @on "mouseover", =>
      @rectInside.set "stroke", "yellow"
      #@showSpeechBalloon(true)
      @canvas.renderAll()
    @on "mouseout", =>
      @rectInside.set "stroke", "white"
      #@showSpeechBalloon(false)
      @canvas.renderAll()
    @canvas.on "zoom", =>
      ratio = @canvas.getZoom()
      @rect.set "strokeWidth", 1/ratio
      @rectInside.set "strokeWidth", 1/ratio
      
  showSpeechBalloon: (value=true)->
    @balloon.set
      left: -@getWidth()/2
      top: -@getHeight()/2
      scaleX: 1/@canvas.getZoom()
      scaleY: 1/@canvas.getZoom()
      visible: value
      
  set: (prop, value) ->
    @callSuper "set", prop, value
    if @rect and @rectInside
      @rect.set("width", @get('width'))
      @rect.set("height", @get('height'))
      @rectInside.set("width", @get('width')-2)
      @rectInside.set("height", @get('height')-2)
    @

  getRightCenter: ->
    x: @getLeft()+@getWidth()
    y: @getTop()+@getHeight()/2
    



fabric.Region = fabric.util.createClass fabric.Group, fabric.Observable,

  transparentCorners: false
  hasRotatingPoint: false
  originX: 'left'
  originY: 'top'
  selectable: false
  type: 'region'
  initialize: (options, callback) ->
    throw 'canvas object not given' unless @canvas = options.canvas

    @callSuper('initialize',[], options)
    ratio = @canvas.getZoom()
    @rect = new fabric.Rect
      transparentCorners: false
      hasRotatingPoint: false
      stroke: 'black'
      strokeWidth: 1/ratio
      fill: 'rgba(0,0,0,0)'
      left: 0
      top: 0
      originX: 'center'
      originY: 'center'
    @rectInside = new fabric.Rect
      transparentCorners: false
      hasRotatingPoint: false
      stroke: 'white'
      strokeWidth: 1/ratio
      fill: 'rgba(0,0,0,0)'
      left: 0
      top: 0
      originX: 'center'
      originY: 'center'
    
    @add @rect
    @add @rectInside
    
    @bindEventListeners()
    @
      
  bindEventListeners: ->
    @on "mouseover", =>
      @rectInside.set "stroke", "yellow"
      @canvas.renderAll()
    @on "mouseout", =>
      @rectInside.set "stroke", "white"
      #@showSpeechBalloont(false)
      @canvas.renderAll()
    @canvas.on "zoom", =>
      ratio = @canvas.getZoom()
      @rect.set "strokeWidth", 1/ratio
      @rectInside.set "strokeWidth", 1/ratio
      
      
  set: (prop, value) ->
    @callSuper "set", prop, value
    if @rect and @rectInside
      @rect.set("width", @get('width'))
      @rect.set("height", @get('height'))
      @rectInside.set("width", @get('width')-2)
      @rectInside.set("height", @get('height')-2)
    @

  getRightCenter: ->
    x: @getLeft()+@getWidth()
    y: @getTop()+@getHeight()/2
    
