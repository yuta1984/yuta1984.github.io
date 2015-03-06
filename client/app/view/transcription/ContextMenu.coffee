Ext.define 'GSW.view.transcription.ContextMenu',
  extend: 'Ext.menu.Menu'
  constructor: (config) ->
    @callParent(config)
    Ext.Error.raise "editor not given" unless @editor = config.editor

  items: [
    text: 'Edit TEI attributes'
  ,
    text: 'Delete markup'
  ,
    '-'
  ,
    text: 'Edit annotation'
  ,
    text: 'Remove annotation'
  ]


  
