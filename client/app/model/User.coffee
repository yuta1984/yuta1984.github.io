Ext.define 'GSW.model.User',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'username', type: 'string', defaultValue: ''}
    {name: 'avatar_standard', type: 'string', defaultValue: ''}
    {name: 'avatar_thumbnail', type: 'string', defaultValue: ''}
  ]

  hasMay: ['TextAnnotation','ImageAnnotation']

  getName: ->
    @get('name')

  statics:
    fromJSON: (data) ->
      config = 
        id: data._id.$oid
        username: data.username
        avatar_standard: data.avatar.standard.url
        avatar_thumbnail: data.avatar.thumbnail.url
      user = new this(config)
      Ext.getStore('GSW.store.UserStore').add user
      user

      
