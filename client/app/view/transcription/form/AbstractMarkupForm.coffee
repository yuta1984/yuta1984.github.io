Ext.define 'GSW.view.transcription.form.AbstractMarkupForm',
  extend: 'Ext.form.Panel'
  requires: ['Ext.form.FieldSet']
  xtype: 'abstract-markup-form'
  frame: true
  title: 'Markup'
  modal: true
  autoScroll:true
  width: 400
  bodyPadding: 10
  floating: true
  closable : true
  layout: 'form'
  fieldDefaults: 
    labelAlign: 'left'
    labelWidth: 115
    msgTarget: 'side'

  buttons: [
    text: 'Markup'
    handler: (btn) => btn.up('form').register()
  ,
    text: 'Cancel'
    handler: (btn) => btn.up('form').cancel()
  ]
  
  constructor: (config) ->
    @callParent(arguments)
    Ext.Error.raise "editor not given" unless @editor = config.editor

  cancel: ->
    @close()

  notifySelectionError: ->
    Ext.Msg.alert 'Error','Invalid markup position'
