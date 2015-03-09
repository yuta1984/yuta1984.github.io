Ext.define 'GSW.model.Manuscript',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'title', type: 'string', defaultValue: ''}
    {name: 'description', type: 'string', defaultValue: ''}
    {name: 'projectId', reference: 'Project'}
    
  ]

  statics:
    fromJSON: (data) ->
      images = if data.images then (GSW.model.Image.fromJSON(img) for img in data.images) else []
      config = 
        id: data._id.$oid
        title: data.title
        description: data.description
      m = new this(config)
      store = m.images()
      store.add(images)
      m
      
