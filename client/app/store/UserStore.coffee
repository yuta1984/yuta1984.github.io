Ext.define 'GSW.store.UserStore',
  extend: 'Ext.data.Store'
  model: 'GSW.model.User'
  proxy:
    type: 'memory'
    
