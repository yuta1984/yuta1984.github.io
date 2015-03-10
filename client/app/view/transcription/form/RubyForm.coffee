Ext.define 'GSW.view.transcription.form.RubyForm',
  extend: 'GSW.view.transcription.form.AbstractMarkupForm'
  xtype: 'ruby-form'
  title: 'Add ruby to text'
  modal: true
  items: [
    xtype: 'textfield'
    allowBlank: false
    fieldLabel: 'Ruby characters'
    name: 'text'
    emptyText: 'るび' 
  ]

  register: ->
    try
      @editor.ruby @getValues().text
    catch e
      @notifySelectionError()
    finally
      @close()
