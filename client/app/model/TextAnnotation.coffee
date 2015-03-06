Ext.define 'GSW.model.TextAnnotation',
  extend: 'GSW.model.AbstractAnnotation'
  fields: [
    {name: 'elementURI', type: 'string', defaultValue: ''}
  ]

  getBodyType: ->
    "text/plain"

  getTargetURI: ->
    @get 'elementURI'

  getTargetType: ->
    "Text"
  
  getMotivation: ->
    "commenting"

  toTriples: ->
    triples = @callSuper()
    # target desc
    triples.push [@getTargetURI(), @p("rdf","type"), @p("dctypes", "Text")]
    triples
    
  
