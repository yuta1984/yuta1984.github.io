Ext.define 'GSW.view.transcription.menu.CanvasContextMenu',
  xtype: 'canvas-context-menu'
  extend: 'Ext.menu.Menu'
  constructor: (config) ->
    @callParent(config)
    Ext.Error.raise "editor not given" unless @canvas = config.canvas

  items: [
    text: 'Annotate'
  ,
    text: 'Add to dictionary'
  ,
    text: 'Search'
  ,
    '-'
    text: 'Cancel'  
  ]


  
