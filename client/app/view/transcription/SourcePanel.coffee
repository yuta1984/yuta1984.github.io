Ext.define 'GSW.view.transcription.SourcePanel',
    extend: 'Ext.panel.Panel'
    xtype: "tei-source-panel"
    padding: 5
    constructor: (config) ->
      @callParent(arguments)
      Ext.Error.raise msg: "title not given" unless config.title
      @setTitle config.title

    setSource: (src) ->
      @setHtml src

