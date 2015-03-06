Ext.define 'GSW.model.AbstractAnnotation',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'body', type: 'string', defaultValue: ''}
    {name: 'bodyType', type: 'string', defaultValue: 'text'}    
    {name: 'target_uri', type: 'string'}
    {name: 'targetType', type: 'string'}
    {name: 'annotatedAt', type: 'int'}
    {name: 'user_id', reference: 'User'}
    {name: 'motivation', type: 'string', defaultValue: 'commenting'}
    {name: 'tags', defaultValue: []}    
  ]

  getURI: -> 
    "http://smart-gs-web.org/annotations/" + @id

  getAnnotatedAt: ->
    @get 'annotatedAt'

  getBody: ->
    @get 'body'

  getBodyType: ->
    Ext.Error.raise "not implemented"    

  getTargetURI: ->
    Ext.Error.raise "not implemented"

  getTargetType: ->
    Ext.Error.raise "not implemented"
  
  getMotivation: ->
    Ext.Error.raise "not implemented"

  addTag: (tag)->
    tags = @get('tags')
    tags.push tag unless tag in tags

  prefix:
    oa:	 "http://www.w3.org/ns/oa#"
    cnt:	 "http://www.w3.org/2011/content#"
    dc:	 "http://purl.org/dc/elements/1.1/"
    dcterms:	 "http://purl.org/dc/terms/"
    dctypes:	 "http://purl.org/dc/dcmitype/"
    foaf:	 "http://xmlns.com/foaf/0.1/"
    prov:	 "http://www.w3.org/ns/prov#"
    rdf:	 "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    rdfs:	 "http://www.w3.org/2000/01/rdf-schema#"
    skos:	 "http://www.w3.org/2004/02/skos/core#"
    trig:	 "http://www.w3.org/2004/03/trix/rdfg-1/"
    gsw:	 "http://smart-gs-web.org/ns#"

  p: (prefix,term) ->
    Ext.Error.raise "undefined prefix" unless @prefix[prefix]
    @prefix[prefix] + term    
  
  toTriples: ->
    triples = []

    uri = @getURI()
    body = "_:body-"+@id
    targetURI = @getTargetURI()
    annotatedAt = @wrapData @xsdDateTime(@get('annotatedAt'))
    serializedBy = "SMART-GS-Web"
    serializedAt = @wrapData @xsdDateTime(new Date().getTime())
    user = @getUser()
    userNodeName = "_:user-" + @id
    motivation = @get('motivation')

    # base block
    triples.push [uri, @p("rdf","type"), @p("oa","Annotation")]
    triples.push [uri, @p("oa","hasBody"), body]
    triples.push [uri, @p("oa","hasTarget"), targetURI]
    triples.push [uri, @p("oa","annotatedBy"), userNodeName]
    triples.push [uri, @p("oa","annotatedAt"), annotatedAt]
    triples.push [uri, @p("oa","serializedBy"), serializedBy]
    triples.push [uri, @p("oa","serializedAt"), serializedAt]    
    triples.push [uri, @p("oa","motivatedBy"), @p("oa", motivation)]

    # body block
    triples.push [body, @p("rdf","type"), @p("cnt", "ContentAsText")]
    triples.push [body, @p("dc","format"), @wrapData("text/plain")]
    triples.push [body, @p("cnt","characterEncoding"), @wrapData("utf-8")]
    triples.push [body, @p("cnt","chars"), @wrapData(@get('body'))]        

    # annotator block
    triples.push [userNodeName, @p("rdf","type"), @p("foaf","Person")]
    triples.push [userNodeName, @p("foaf","name"), @wrapData(user.get('name'))]

    # tags
    tags = @get('tags')
    if tags.length > 0
      triples.push [uri, @p("oa","motivatedAt"), @p("oa", "tagging")]
    for tag in @get('tags')
      tagNodeName = "_:tag-" + tag
      triples.push [uri, @p("oa", "hasBody"), tagNodeName]
      triples.push [tagNodeName, @p("rdf","type"), @p("oa", "Tag")]
      triples.push [tagNodeName, @p("rdf","type"), @p("cnt", "ContextAsText")]
      triples.push [tagNodeName, @p("cnt","characterEncoding"), @wrapData("utf-8")]
      triples.push [tagNodeName, @p("dc","format"), @wrapData("text/plain")]
      triples.push [tagNodeName, @p("cnt","chars"), @wrapData(tag)]

    # software block
    triples.push [serializedBy, @p("rdf","type"), @p("prov","SoftwareAgent")]
    triples.push [serializedBy, @p("foaf","name"), @wrapData("SMART-GS-Web")]

    # target and body blocks should be added in subclasses
    triples      

  write: (callback)->    
    writer = new window.N3.Writer()
    # prefix block
    for k,v of @prefix
      writer.addPrefix k, v
    # annotation block
    for triple in @toTriples()
      writer.addTriple triple[0], triple[1], triple[2]
    writer.end callback

  xsdDateTime: (dateInt) ->
    date = new Date(dateInt)
    pad = (n) ->
      s = n.toString()
      (if s.length < 2 then "0" + s else s)
    yyyy = date.getFullYear()
    mm1 = pad(date.getMonth() + 1)
    dd = pad(date.getDate())
    hh = pad(date.getHours())
    mm2 = pad(date.getMinutes())
    ss = pad(date.getSeconds())
    yyyy + "-" + mm1 + "-" + dd + "T" + hh + ":" + mm2 + ":" + ss

  wrapData: (raw) ->
    '"'+raw+'"'
 
