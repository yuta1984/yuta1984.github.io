class TategakiEditor  
  constructor: (iframeId, options={}) ->
    @iframeId = iframeId
    @colNum = options["colNum"] or 10
    @colWidth = options["colWidth"] or 15
    @render()

  # pub/sub
  on: (event, callback) ->
    @eventListeners = {} unless @eventListeners
    unless @eventListeners.hasOwnProperty(event)
      @eventListeners[event] = []
    @eventListeners[event].push(callback)

  fireEvent: (event, args) ->
    if @eventListeners.hasOwnProperty(event)
      try 
        for listener in @eventListeners[event]
          listener.call(null, args)
      catch e
        console.error(e)

  render: ->
    @doc = document.getElementById(@iframeId).contentWindow.document
    @head = $('head', @doc)
    @body = $('body', @doc)        
    cssLink = $('<link rel="stylesheet" type="text/css" href="resources/css/tategaki.css"/>')
    @editor = $('<div contenteditable class="tategaki-editor" widht="100%" height="100%"></div>').height(@body.height())
    @head.append cssLink 
    @body.append @editor
    @editor.resize (e) => console.log e
    @bindKeyEventHandlers()

  bindKeyEventHandlers: ->
    @editor.on "keydown", (e) =>
      switch e.keyCode
        when 38
          @movecarettoprevchar()
          e.stopPropagation()          
          e.preventDefault()
        when 40
          @moveCaretToNextChar()
          e.stopPropagation()
          e.preventDefault()
        when 37
          @moveCaretToNextLine()
          e.stopPropagation()
          e.preventDefault()
        when 39
          @moveCaretToPrevLine()
          e.stopPropagation()
          e.preventDefault()
          
    @editor.on "keyup", (e) =>
      @fireEvent "change", e
          
    @editor.on "keydown click focus", =>
      @highlightSelected()

    @editor.on "contextmenu", (e) =>
      @fireEvent "contextmenu", e

    @editor.on "mousedown", (e) =>
      @fireEvent "mousedown", e

  highlightSelected: ->      
    @resetElementSelection()
    @selected = $(@selectedElement())
    @selected.addClass "selected" unless @selected.hasClass("tategaki-column")
    @fireEvent "element:selected", @selectedElement()

  getHtmlSource: ->
    $(@editor).html()
          
  markup: (elemName, attrs={}) ->
    sel = @doc.getSelection()
    range = sel.getRangeAt(0)
    return if range.collapsed
    markup = @doc.createElement(elemName)
    for key, val of attrs
      markup.setAttribute(key, val)
    try
      range.surroundContents(markup)
      sel.removeAllRanges()
      sel.addRange(range)
    catch e
      console.log e
      throw "selection not markupable"

  makeLink: (url) ->
    @markup("a", href: url)          

  ruby: (furigana, attrs={}) ->
    sel = @doc.getSelection()
    range = sel.getRangeAt(0)
    return if range.collapsed
    rubyElem = @doc.createElement("ruby")
    console.log range
    range.surroundContents(rubyElem)
    furiganaText = @doc.createTextNode(furigana)
    furiganaElem = @doc.createElement("rt")
    furiganaElem.appendChild(furiganaText)
    rubyElem.appendChild(furiganaElem)
    for key, val of attrs
      rubyElem.setAttribute(key, val)
    sel.removeAllRanges()
    sel.addRange(range)

  removeMarkup: ->
    return null if @selected.hasClass("tategaki-column")
    @selected.contents().unwrap()
    @selected = null

  moveCaretToNextLine: ->
    # キャレットをy座標はそのままに次の行に移動
    return unless next = @nextColumn()
    x = next.offsetLeft + next.offsetWidth/2 #次の行の中心線のx座標
    y = @getCaretCoordinates().top             
    try
      sel = @doc.getSelection()
      range = @doc.caretRangeFromPoint(x,y)
      sel.removeAllRanges()
      sel.addRange(range)

  moveCaretToPrevLine: ->
    # キャレットをy座標はそのままに次の行に移動
    return unless prev = @prevColumn()
    x = prev.offsetLeft + prev.offsetWidth/2 #前の行の中心線のx座標
    y = @getCaretCoordinates().top
    try    
      sel = @doc.getSelection()
      range = @doc.caretRangeFromPoint(x,y)
      sel.removeAllRanges()
      sel.addRange(range)

  getCaretCoordinates: ->
    range = @doc.getSelection().getRangeAt(0).cloneRange()
    span = $("<span></span>")
    range.insertNode span[0]
    position = $(span).offset()
    parent = span[0].parentNode
    parent.removeChild(span[0])
    parent.normalize()
    position

  moveCaretToNextChar: ->
    return null unless @editor.is(":focus")
    range = @doc.getSelection().getRangeAt(0).cloneRange()
    sel = @doc.getSelection()
    el = range.startContainer    
    if el.length is range.startOffset # nodeの最後に到達
      nextNode = @findNextTextNode(el)
      return unless nextNode
      range.setStart(nextNode, 0)
    else      
      range.setStart(el, range.startOffset+1)
    sel.removeAllRanges()
    sel.addRange(range)

  moveCaretToPrevChar: ->
    return null unless @editor.is(":focus")
    range = @doc.getSelection().getRangeAt(0).cloneRange()
    sel = @doc.getSelection()
    el = range.startContainer    
    if range.startOffset is 0 # nodeの最初に到達
      prevNode = @findPrevTextNode(el)
      return unless prevNode      
      range.setStart(prevNode, prevNode.length)
      range.setEnd(prevNode, prevNode.length)
    else      
      range.setStart(el, range.startOffset-1)
      range.setEnd(el, range.endOffset-1)
    sel.removeAllRanges()
    sel.addRange(range)
    
  findNextTextNode: (el)->
    if el.nextSibling
      if el.nextSibling.nodeType is 3
        if el.nextSibling.length > 0
          el.nextSibling
        else
          @findNextTextNode(el.nextSibling)
      else if el.nextSibling.hasChildNodes()
        return el.nextSibling.firstChild if el.nextSibling.firstChild.nodeType is 3
        @findNextTextNode(el.nextSibling.firstChild)
    else
      while not el.parentNode.nextSibling
        el = el.parentNode
        return null if el is @editor[0]
      @findNextTextNode(el.parentNode)

  findPrevTextNode: (el)->
    if el.previousSibling
      if el.previousSibling.nodeType is 3
        if el.previousSibling.length > 0
          el.previousSibling
        else
          @findPrevTextNode(el.previousSibling)
      else if el.previousSibling.hasChildNodes()
        return el.previousSibling.lastChild if el.previousSibling.lastChild.nodeType is 3
        @findPrevTextNode(el.previousSibling.lastChild)
    else
      while not el.parentNode.previousSibling
        el = el.parentNode
        return null if el is @editor[0]
      @findPrevTextNode(el.parentNode)
      

  getCaretPosition: ->
    return null unless @editor.is(":focus")
    range = @doc.getSelection().getRangeAt(0)
    el: range.startContainer, offset: range.startOffset

  setCaretPosition: (colIndex, offset) ->
    return null unless @editor.is(":focus")
    range = @doc.createRange()
    sel = @doc.getSelection()
    range.setStart(@editor[0].childNodes[colIndex],offset)
    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)


  prevColumn: ->
    if current = @currentColumn()
      current.previousSibling
    else
      null

  nextColumn: ->
    if current = @currentColumn()
      current.nextSibling
    else
      null

  currentColumn: ->
    return null unless @editor.is(":focus")
    return null unless node = @doc.getSelection().focusNode
    console.log node
    if node.nodeType is 1 then p = node else p = node.parentElement
    while not $(p).hasClass("tategaki-column")
      p = p.parentElement
    p

  selectedElement: ->
    return null unless @editor.is(":focus")    
    node = @doc.getSelection().focusNode
    elem = if node.nodeType is 1 then node else node.parentElement
    elem
    
  
  resetElementSelection: ->
    @editor.find(".selected").removeClass("selected")

  source: (s)->
    @editor.html(s)

  getIframeOffset: ->
    $("##{@iframeId}").offset()

window.TategakiEditor = TategakiEditor


