Ext.define 'GSW.model.ImageAnnotation',
  extend: 'GSW.model.AbstractAnnotation'
  fields: [
    {name: 'x', type: 'int'}
    {name: 'y', type: 'int'}
    {name: 'w', type: 'int'}
    {name: 'h', type: 'int'}    
  ]

  getBodyType: ->
    "text/plain"

  getTargetURI: ->
    "http://yuta1984.github.io/images/ansei_jou/ansei_jou_03.jpg"
    #@getSurface().getImageURI()

  getTargetType: ->
    "image"
  
  getMotivation: ->
    "commenting"

  toTriples: ->
    triples = @callSuper()
    # target desc
    triples.push [@getTargetURI(), @p("rdf","type"), @p("dctypes", "Image")]
    triples
    
  
  update: (rect)->
    @set 'x', rect.getLeft()
    @set 'y', rect.getTop()
    @set 'w', rect.getWidth()
    @set 'h', rect.getHeight()

