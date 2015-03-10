Ext.define 'GSW.view.transcription.form.ImageAnnotationForm',
  extend: 'Ext.form.Panel'
  requires: [
    'Ext.layout.container.Form'
  ]
  xtype: 'image-annotation-form'
  title: 'Annotate image'
  frame: true
  modal: true
  autoScroll:true
  bodyPadding: 10
  width: 400
  floating: true
  closable : false
  layout: 'form'
  fieldDefaults: 
    labelAlign: 'left'
    msgTarget: 'side'
    
  constructor: (config) ->
    @callParent(config)
    @model = config.model
    @down('image').setSrc @model.crop()
    anno = @model.get('annotation')
    if anno and anno isnt ''
      @down('textareafield').setText(anno)    
    @

  items: [
    xtype: 'image'
    fieldLabel: 'Image'
    height: 200
  ,
    xtype: 'textareafield'
    allowBlank: false
    grow: true
    fieldLabel: 'Text'
    width    : '100%'
    name: 'annotation'
    emptyText: 'Put some comments. You can use hashtags like this: #kyoto' 
  ]

  buttons: [
    text: 'Add'
    handler: (btn) => btn.up('form').register()
  ,
    text: 'Cancel'
    handler: (btn) => btn.up('form').cancel()
  ]

  register: ->
    @model.set("annotation", @getValues().annotation)
    @model.createOnServer =>
      @model.notifyCreation()
    @close()

  cancel: ->
    @model.view.canvas.remove(@model.view)
    @model.erase()
    @close()
