Ext.define 'GSW.model.Image',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'title', type: 'string', defaultValue: ''}
    {name: 'url', type: 'string', defaultValue: ''}
    {name: 'url_thumbnail', type: 'string', defaultValue: ''}
    {name: 'transcription', type: 'string', defaultValue: ''}
    {name: 'translation', type: 'string', defaultValue: ''}
    {name: 'notes', type: 'string', defaultValue: ''}
    {name: 'manuscriptId', reference: 'Manuscript'}
  ]

  
  # FIX THIS!!!
  update: (attr, value) ->
    @set(attr,value)
    @updateOnServer(attr, value)
    @notifyToGroup(attr, value)

  notifyToGroup: (attr, value)->
    data = type: "update:image", id: @id, attrs: {}    
    data["attrs"][attr] = value
    TogetherJS.send data

  updateOnServer: (attr, value)->
    url = @buildURL() + ".json"
    params = {}
    params["image[#{attr}]"] = value
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
        title: data.title
        url: data.image_data.url
        url_thumbnail: data.image_data.thumbnail.url
        transcription: data.transcription or ''
        translation: data.translation or ''
        notes: data.note or ''
      image = new this(config)
      Ext.getStore('GSW.store.ImageStore').add image
      image
      
  buildURL: ->
    server = GSW.app.getServerURL()
    manuscriptId = @manuscript.id
    projectId = @manuscript.project.id
    [server, "projects", projectId, "manuscripts", manuscriptId, "images", @id].join("/")
