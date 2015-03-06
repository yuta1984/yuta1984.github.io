Ext.define 'GSW.model.Zone',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'htmlText', type: 'string', defaultValue: '<div class="tategaki-column"></div>'}
    {name: 'x', type: 'int'}
    {name: 'y', type: 'int'}
    {name: 'w', type: 'int'}
    {name: 'h', type: 'int'}
  ]

  hasMany: 'TextAnnotation'

  setHtmlText: (text) ->
    @set 'htmlText', text

  getHtmlText: ->
    @get 'htmlText'

  getTeiText: ->    
    zone = $("<zone></zone>")
    zone.attr(k,v) for k,v of @__getCoords()
    $(@getHtmlText()).each (i)->
      line = $("<line></line>")
      line.text $(@).html()
      zone.append line
    zone[0].outerHTML

  update: (fabricZone)->
    @set 'x', fabricZone.getLeft()
    @set 'y', fabricZone.getTop()
    @set 'w', fabricZone.getWidth()
    @set 'h', fabricZone.getHeight()
    console.log "width: ", fabricZone.getWidth()
    console.log "scaleX: ", fabricZone.getScaleX()
    
  __columnToTeiLine: (line) ->
    
    
  __getCoords: ->
    ulx: @get('x')
    uly: @get('y')    
    lrx: @get('x')+@get('w')
    lry: @get('y')+@get('h')
