Ext.define 'GSW.store.RegionStore',
  extend: 'Ext.data.Store'
  model: 'GSW.model.Region'
  proxy:
    type: 'memory'
    
  constructor: ->
    @listenTogetherJS()
    @callParent(arguments)

  listenTogetherJS: ->
    TogetherJS.hub.on "update:region", (data) =>
      region = @getById(data.id)
      console.log region
      if region
        for k, v of data["attrs"]
          region.set(k, v)
        region.fireEvent "update:region"
    TogetherJS.hub.on "create:region", (data) =>
      region = new GSW.model.Region(data.attrs)
      region.id = data.attrs.id
      @add(region)
      # add association
      image_id = region.get('image_id')
      image = Ext.getStore("GSW.store.ImageStore").getById(image_id)
      image.regions().add(region)
      user_id = region.get('user_id')
      user = Ext.getStore("GSW.store.UserStore").getById(user_id)
      region.setUser(user)
      console.log "new region added", region.getImage()
      image.fireEvent "create:region", region
        
