Ext.define 'GSW.model.Base',
  extend: 'Ext.data.Model'
  schema:
    namespace: 'GSW.model'

  on: (event, callback) ->
    @handler = {} unless @handler
    @handler[event] = @handler[event] or []
    @handler[event].push(callback)

  fireEvent: (event) ->
    return unless @handler
    return unless @handler[event]
    for callback in @handler[event]
      callback()
