Ext.define 'GSW.util.OpenAnnotation',

  prefix: ->
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

  p: (prefix, term) ->
    Ext.Error.raise "undefined prefix" unless @prefix()[prefix]
    @prefix()[prefix] + ":" + term

  write: (anno, callback) ->
    uri = anno.getURI()
    body = @p("gsw", anno.id)
    targetURI = anno.getTargetURI()
    annotatedAt = @wrapData @xsdDateTime(anno.get('annotatedAt'))
    serializedBy = "SMART-GS-Web"
    serializedAt = @wrapData @xsdDateTime(new Date)
    annotatedBy = "_:" + anno.get('annotatedBy_id')
    motivation = anno.get('motivation')
    writer = new window.N3.Writer()
    # prefix block
    for k,v of @prefix()
      writer.addPrefix k, v
    # annotation block
    writer.addTriple uri, @p("rdf","type"), @p("oa","Annotation")
    writer.addTriple uri, @p("oa","hasBody"), body
    writer.addTriple uri, @p("oa","hasTarget"), targetURI
    writer.addTriple uri, @p("oa","annotatedBy"), annotatedBy
    writer.addTriple uri, @p("oa","annotatedAt"), annotatedAt
    writer.addTriple uri, @p("oa","serializedBy"), serializedBy
    writer.addTriple uri, @p("oa","serializedAt"), serializedAt
    writer.addTriple uri, @p("oa","motivatedAt"), @p("oa", motivation)

    # annotator block
    writer.addTriple annotatedBy, @p("rdf","type"), @p("foaf","Person")
    writer.addTriple annotatedBy, @p("foaf","name"), @wrapData("dummy user")

    # target block
    switch anno.getTargetType()
      when "xml"
        targetType = @p("dctypes","Text")
        format = @wrapData("text/xml")
      when "image"
        targetType = @p("dctypes","Image")
      else
        targetType = @p("dctypes","Text")
        format = @wrapData("text/xml")    
    writer.addTriple targetURI, @p("rdf","type"), targetType
    writer.addTriple targetURI, @p("dc","format"), format if format

    # body block
    switch anno.getBodyType()
      when "text"
        bodyType = @p("cnt","ContentAsText")
      when "tag"
        bodyType = @p("oa","Tag")
    writer.addTriple targetURI, @p("rdf","type"), targetType
    writer.addTriple targetURI, @p("cnt","characterEncoding"), @wrapData("utf-8")
    writer.addTriple targetURI, @p("dc","format"), @wrapData("text/plain")
    writer.addTriple targetURI, @p("cnt","chars"), @wrapData(anno.getBody())
                
    # software block
    writer.addTriple serializedBy, @p("rdf","type"), @p("prov","SoftwareAgent")
    writer.addTriple serializedBy, @p("foaf","name"), @wrapData("SMART-GS-Web")

    writer.end (err,res)->
      callback(res)

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
