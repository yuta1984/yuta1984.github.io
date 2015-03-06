Ext.define 'GSW.model.Surface',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'imageURI', type: 'string', defaultValue: ''}
    #delete this
    {name: 'annotations', defaultValue: []}    # 
  ]

  hasMany: 'Zone'
  hasMany: 'ImageAnnotation'

  getImageURI: ->
    "http://dummy_image.org"
#    @get('imageURI')
