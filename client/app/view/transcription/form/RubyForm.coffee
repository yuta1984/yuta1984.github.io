Ext.define 'GSW.view.transcription.form.RubyForm',
  extend: 'GSW.view.transcription.form.AbstractMarkupForm'
  xtype: 'ruby-form'
  title: 'ルビを追加'

  items: [
    xtype: 'fieldset'
    defaultType: 'textfield',
    defaults: 
      anchor: '100%'
    items: [
      allowBlank: false
      fieldLabel: 'ルビ文字'
      name: 'text'
      emptyText: 'るび' 
    ]
  ]

  register: ->
    try
      @editor.ruby @getValues().text
    catch e
      @notifySelectionError()
    finally
      @close()
