Ext.define 'GSW.model.Manuscript',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'title', type: 'string', defaultValue: ''}
    {name: 'description', type: 'string', defaultValue: ''}
    
  ]

  hasMay: [
    name: 'images'
    model: 'GSW.model.Image'
  ]
  

  statics:
    fromJSON: (data) ->
      config = 
        id: data._id.$oid
        title: data.title
        description: data.description
        images: (GSW.model.Image.fromJSON(img) for img in data.images)
      new this(config)
      
