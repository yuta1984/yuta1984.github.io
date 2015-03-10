Ext.define 'GSW.view.main.NavigationTreePanel',
    extend: 'Ext.tree.Panel'
    xtype: "navigation-tree-panel"
    requires: ['GSW.view.map.GoogleMapPanel']
    
    layout: 'fit'
    collapsible: true
    split: true
    rootVisible: false
    useArrows: true
    colspan: 2
    store: "GSW.store.ResourceStore"
    

    constructor: (config) ->
      @callParent(arguments)

    listeners:
      itemclick: (tree, record, item, index)->
        @createTab(tree, record, item, index)

    createTab: (tree, record, item, index) ->
      switch record.data.type
        when 'image'
          tab = Ext.create("GSW.view.transcription.TranscriptionPanel", title: record.data.text, image: record.data.model)
          console.log record
          tab.setBackgroundImg record.data.url          
        when 'map'
          tab = Ext.create("GSW.view.map.GoogleMapPanel", title: '京都')
      tabpanel = Ext.getCmp("content-tabpanel")
      tabpanel.add tab      
      tabpanel.setActiveTab tab
      
      
      
