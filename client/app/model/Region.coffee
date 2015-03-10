Ext.define 'GSW.model.Region',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'x', type: 'integer', defaultValue: 0},
    {name: 'y', type: 'integer', defaultValue: 0},
    {name: 'w', type: 'integer', defaultValue: 0},
    {name: 'h', type: 'integer', defaultValue: 0},
    {name: 'annotation', type: 'string', defaultValue: ''},
    {name: 'image_id', reference: 'Image'},
    {name: 'user_id', reference: 'User'},
  ]
        
  crop: ->
    image = @getImage() or @get('image')
    image.crop(@get('x'),@get('y'),@get('w'),@get('h'))

  update: (attr, value) ->
    @set(attr, value)
    @updateOnServer(attr, value)
    @notifyUpdate(attr, value)

  createOnServer: (callback)->
    console.log "creating model on server", @
    url = @buildURL("create") + ".json"
    console.log "create url", url
    params =
      "region[x]": @get('x')
      "region[y]": @get('y')
      "region[w]": @get('w')
      "region[h]": @get('h')
      "region[annotation]": @get('annotation')
      "region[image_id]": @get('image_id')
      "region[user_id]": @get('user_id')
    Ext.Ajax.request
      method: 'POST'
      withCredentials: true
      cors: true
      useDefaultXhrHeader : false
      url: url
      params: params
      success: (res) =>
        data = JSON.parse(res.responseText)
        console.log data
        @set('id', data._id.$oid)
        callback()

  notifyCreation: ->
    attrs =
      x: @get('x')
      y: @get('y')
      w: @get('w')
      h: @get('h')
      id: @get('id')
      annotation: @get('annotation')
      image_id: @image.id
      user_id: GSW.app.me.id
    params = type: "create:region", attrs: attrs
    TogetherJS.send params

  notifyUpdate: (attr, value)->
    data = type: "update:region", id: @id, attrs: {}    
    data["attrs"][attr] = value
    TogetherJS.send data

  updateOnServer: (attr, value)->
    url = @buildURL("update") + ".json"
    params = {}
    params["region[#{attr}]"] = value
    Ext.Ajax.request
      method: 'PUT'
      withCredentials: true
      cors: true
      useDefaultXhrHeader : false
      url: url
      params: params
      success: (data)->
        console.log data

  statics:
    fromJSON: (data) ->
      config = 
        id: data._id.$oid
        x: data.x or 0
        y: data.y or 0
        w: data.w or 0
        h: data.h or 0
        annotation: data.annotation or ""
        image_id: data.image_id or ""
        user_id: data.user_id.$oid or ""
        user: Ext.getStore('GSW.store.UserStore').getById(data.user_id)
      region = new this(config)
      Ext.getStore('GSW.store.RegionStore').add region
      region
    
    create: (data) ->
      region = new this(data)
      region.set('user_id', GSW.app.me.id)
      data.image.regions().add region
      Ext.getStore('GSW.store.RegionStore').add region
      region.createOnServer ->
        region.notifyCreation()
      region

  buildURL: (action)->
    server = GSW.app.getServerURL()
    image = @getImage()
    console.log "image", image
    manuscript = image.getManuscript()
    console.log "manuscript", manuscript
    project = manuscript.getProject()
    console.log "project", project
    switch action
      when "update"
        [server, "projects", project.id, "manuscripts", manuscript.id, "images", image.id, "regions", @id].join("/")
      when "create"
        [server, "projects", project.id, "manuscripts", manuscript.id, "images", image.id, "regions"].join("/")
      else
        [server, "projects", project.id, "manuscripts", manuscript.id, "images", image.id, "regions", @id].join("/")

  
    
