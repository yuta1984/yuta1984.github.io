Ext.define 'GSW.view.transcription.CanvasPanel',
    extend: 'Ext.panel.Panel'
    requires: [
      'GSW.view.transcription.state.DefaultState'
      'GSW.view.transcription.state.DrawingState'
      'GSW.view.transcription.state.ImageAnnotationState'
      'GSW.view.transcription.SourcePanel'
      'GSW.util.XmlFormatter'
      'GSW.util.OpenAnnotation'] 
    xtype: "canvas-panel"
    bodyBorder: false
    bodyPadding: 0
    bodyMargin: 0    
    layout: 'fit'
    constructor: (config) ->
      @callParent(arguments)
    listeners:
      afterrender: -> @setupCanvas()
      resize: -> @resize()      
    dockedItems: [
      dock: 'top'
      xtype: 'toolbar'
      border: 1
      style:
        'background-color': "rgb(235,235,235)"
      items: [
        iconCls: null
        text: 'Show source'
        xtye: 'splitbutton'
        menu: [
          text: "TEI"
          handler: ->
            src = GSW.util.XmlFormatter.format @up("canvas-panel").getTeiSource()
            title = "TEI src: #{@up('transcription-panel').getTitle()}"
            tab = Ext.create "GSW.view.transcription.SourcePanel",
              title: title
            tab.setSource src
            tabpanel = Ext.getCmp("content-tabpanel")
            tabpanel.add tab
            tabpanel.setActiveTab tab
        ,
          text: "Open Annotation"
          handler: ->
            annotations = @up("canvas-panel").surf.get('annotations')
            generator = Ext.create "GSW.util.OpenAnnotation"
            src = ""
            for a in annotations
              generator.write a, (str) ->
                src += str
            title = "annotations: #{@up('transcription-panel').getTitle()}"
            tab = Ext.create "GSW.view.transcription.SourcePanel",
              title: title
            src = $("<pre />").text(src).html()
            src = src.split("\n").join("<br/>")
            tab.setSource src
            tabpanel = Ext.getCmp("content-tabpanel")
            tabpanel.add tab
            tabpanel.setActiveTab tab
                
        ]
      ,
        '-'
      ,        
      #   iconCls: null
      #   text: 'Text Zone'
      #   xtye: 'splitbutton'
      #   menu: [
      #     text: "Add"
      #     handler: -> @up("canvas-panel").switchState "drawing"
      #   ,
      #     text: "Remove"
      #     handler: ->
      #       c = @up("canvas-panel").c
      #       c.remove zone if zone = c.getActiveObject()
      #   ]
      # ,        
        iconCls: null
        text: 'Region'
        xtye: 'splitbutton'
        menu: [
          text: "Add"
          handler: -> @up("canvas-panel").switchState "annotating"
        ,
          text: "Remove"
        ]        
      ]
    ]
    setupCanvas: ->
      canvasId= "canvas-#{@getId()}"
      @setHtml "<canvas id=#{canvasId} width='900' height='900'></canvas>"
      options =
        selection: false
      @c = new fabric.Canvas(canvasId, options)      
      # イベントハンドラ登録
      @bindEventListeners()
      # マウスイベントハンドラの状態遷移クラスを構築
      @setupStates()
      # ズーム初期化
      @zoom = 1.0
      @setZoom @zoom

    setupStates: ->
      @currentState = 'default'
      @states =
        default: Ext.create 'GSW.view.transcription.state.DefaultState', canvas: this
        drawing: Ext.create 'GSW.view.transcription.state.DrawingState', canvas: this
        annotating: Ext.create 'GSW.view.transcription.state.ImageAnnotationState', canvas: this

    getState: ->
      @states[@currentState] or @states.default

    switchState: (name)->
      if @states[name]
        @currentState = name
        @states[name].onSwitchState()

    resetState: ->
      @switchState("default")

    bindEventListeners: ->
      @c.on "after:render", => @c.calcOffset()        
      @c.on "object:moving", (event) =>
      @c.on "object:modified", (event) =>
      @c.on "object:selected", (event) =>
        @__onObjectSelected event
      @c.on "selection:cleared", (event) =>
      @c.on "mouse:move", (event) =>
        @getState().mousemove(event)        
      @c.on "mouse:down", (event) =>
        @getState().mousedown(event)
      @c.on "mouse:up", (event) =>
        @getState().mouseup(event)
      $(@c.wrapperEl).on "mousewheel", (event) =>
        @getState().mousewheel(event)
      $(@c.wrapperEl).on "mouseout", (event) =>
        @getState().mouseout(event)

    resize: ->
      @c.setWidth @getWidth()
      @c.setHeight @getHeight()      

    setBackgroundImg: (url) ->
      @surf = Ext.create 'GSW.model.Surface'
      @surf.set 'imageURI', @url
      @url = url
      fabric.Image.fromURL url, (img) =>
        @c.remove(@img) if @img
        @img = img
        @img.set('selectable', false)
        @c.add(@img)
        @img.moveTo(-1)
        @c.absolutePan(x:0, y:0)
  
    setZoom: (ratio) ->
      if ratio > 0.2 and ratio < 10.0
        @zoom = ratio
        viewportCenter =
          x: @c.getWidth()/2*@zoom
          y: @c.getHeight()/2*@zoom
        @c.zoomToPoint viewportCenter, @zoom
        @c.fire "zoom"

    moveViewportBy: (delta) ->
      currentOrigin = @__viewportOrigin()
      newOrigin =
        x: currentOrigin.x + delta.x, y: currentOrigin.y + delta.y
      @c.absolutePan newOrigin

    # キャンバス上の点をドキュメントの座標に変換
    translateToAbsolutePoint: (point) ->
      zoom = @c.getZoom()
      offset = $(@c.getElement()).offset()
      currentOrigin = @__viewportOrigin()
      x: (point.x*zoom-currentOrigin.x) + offset.left
      y: (point.y*zoom-currentOrigin.y) + offset.top

    getTeiSource: ->
      doc = $("<sourceDoc></sourceDoc>")
      surf = $("<surface></surface>").attr("facs", @surf.get('url'))
      @c.forEachObject (obj) ->
        if obj instanceof fabric.Zone
           surf.append $(obj.model.getTeiText())
      doc.append surf           
      doc[0].outerHTML

    __getTranscriptionPanel: ->
      @up('transcription-panel').child('tategaki-editor')
  
    __viewportOrigin: ->
      x: -@c.viewportTransform[4], y: -@c.viewportTransform[5]

    __onObjectSelected: (event) ->
      if event.target instanceof fabric.Zone
        trclPanel = @__getTranscriptionPanel()
        trclPanel?.setZone event.target.model
