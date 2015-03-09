Ext.define 'GSW.store.ImageStore',
  extend: 'Ext.data.Store'
  model: 'GSW.model.Image'
  proxy:
    type: 'memory'
    
  constructor: ->
    @listenTogetherJS()
    @callParent(arguments)

  listenTogetherJS: ->
    console.log "start listenening"
    TogetherJS.hub.on "update:image", (data) =>
      image = @getById(data.id)
      console.log image
      if image
        for k, v of data["attrs"]
          image.set(k, v)
        image.fireEvent "update:image"
        
