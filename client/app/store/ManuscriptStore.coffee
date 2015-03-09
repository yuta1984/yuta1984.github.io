Ext.define 'GSW.store.ManuscriptStore',
  extend: 'Ext.data.Store'
  model: 'GSW.model.Manuscript'
  proxy:
    type: 'memory'
    
