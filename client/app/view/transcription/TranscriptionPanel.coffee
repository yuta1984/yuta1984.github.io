Ext.define 'GSW.view.transcription.TranscriptionPanel',
    extend: 'Ext.panel.Panel'
    requires: [
      'GSW.view.transcription.TategakiEditor'
      'GSW.view.transcription.CanvasPanel'
      'GSW.view.transcription.EditorTabPanel'
      'GSW.util.TeiConverter']
    xtype: "transcription-panel"
    
    width: '100%'
    height: '100%'
    layout: 'border'
    bodyBorder: false    

    defaults:
      collapsible: true
      split: true
      bodyPadding: 10

    constructor: (config) ->
      @image = config.image
      @image.on "update:image", =>
        @down("tategaki-editor")?.reload()
      @image.on "create:region", =>
        @down("canvas-panel")?.showRegions()
      @callParent(arguments)
    
    setBackgroundImg: (url)->
      @child("canvas-panel").setBackgroundImg url

    getImage: ->
      @image

    items: [
      xtype: 'canvas-panel'
      region:'west'
      floatable: false
      margin: 0 #'5 0 0 0'
      width: '50%'      
      minWidth: 100
      header: false            
    ,
      collapsible: false
      region: 'center'
      header: false 
      margin: '5 0 0 0'
      #xtype: 'tategaki-editor'
      xtype: 'editor-tab-panel'
      minWidth: 100
      padding: 0
      width: '50%'       
      height: "100%"
    # ,
    #   xtype: 'tei-panel'
    #   collapsible: true
    #   collapsed: true      
    #   region:'south'
    #   header: true
    #   title: 'TEI属性'
    #   floatable: false
    #   margin: 0
    #   height: '20%'      
    #   minWidth: 100
    ]
    
    
