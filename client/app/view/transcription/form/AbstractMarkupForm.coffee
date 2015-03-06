Ext.define 'GSW.view.transcription.form.AbstractMarkupForm',
  extend: 'Ext.form.Panel'
  requires: ['Ext.form.FieldSet']
  xtype: 'abstract-markup-form'
  frame: true
  title: 'マークアップ'
  autoScroll:true
  width: 355
  floating: true
  closable : true  
  fieldDefaults: 
    labelAlign: 'right'
    labelWidth: 115
    msgTarget: 'side'

  buttons: [
    text: '登録'
    handler: (btn) => btn.up('form').register()
  ,
    text: 'キャンセル'
    handler: (btn) => btn.up('form').cancel()
  ]
  
  constructor: (config) ->
    @callParent(arguments)
    Ext.Error.raise "editor not given" unless @editor = config.editor

  cancel: ->
    @close()

  notifySelectionError: ->
    Ext.Msg.alert 'エラー','マークアップ位置が不正です'
