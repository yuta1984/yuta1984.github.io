Ext.define 'GSW.model.Image',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'title', type: 'string', defaultValue: ''}
    {name: 'url', type: 'string', defaultValue: ''}
    {name: 'url_thumbnail', type: 'string', defaultValue: ''}
    {name: 'transcription', type: 'string', defaultValue: ''}
    {name: 'translation', type: 'string', defaultValue: ''}
    {name: 'notes', type: 'string', defaultValue: ''}
  ]

  
  # FIX THIS!!!
  notifyRemote: (attribute) ->
    remoteURL = GSW.app.getServerURL()
    url = remoteURL + "images/" + @get('id')
    Ext.Ajax.request
      method: 'PUT'
      withCredentials: true
      url: url
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
      new this(config)
      
