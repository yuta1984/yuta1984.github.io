$(document).ready ->  
  
  $("#ruby").click ->
    furigana = window.prompt "ルビ文字を入力してください", "ふりがな"
    window.tategakiEditor.ruby(furigana)

  $("#markup").click ->
    tagName = window.prompt "タグ名を入力してください", "strong"
    window.tategakiEditor.markup(tagName)

  $("#remove-markup").click ->
    window.tategakiEditor.removeMarkup()
    window.tategakiEditor.resetElementSelection()
    
  $("#link").click ->
    url = window.prompt "URLを入力してください", "http://google.com"
    window.tategakiEditor.makeLink(url)

  $("#source").click ->    
    alert tategakiEditor.getHtmlSource()
  

class TategakiEditor  
  constructor: (iframeId, options={}) ->
    @iframeId = iframeId
    @colNum = options["colNum"] or 10
    @colWidth = options["colWidth"] or 15
    @render()

  render: ->
    iframe = $(@iframeId)
    @doc = iframe[0].contentWindow.document
    @head = $('head', @doc)
    @body = $('body', @doc)
    cssLink = $('<link rel="stylesheet" type="text/css" href="./tategaki.css"/>')
    @editor = $('<div contenteditable class="tategaki-editor"></div>').height(@body.height())
    col = $('<div class="tategaki-column"><ruby class="">色<rt class="">いろ</rt></ruby>は<ruby class="">匂<rt class="">にほ</rt></ruby>えど <ruby class="">散<rt class="">ち</rt></ruby>りぬるを <ruby class="">我<rt>わ</rt></ruby>が<ruby class="">世<rt class="">よ</rt></ruby><ruby class="">誰<rt>たれ</rt></ruby>ぞ <ruby class="">常<rt class="">つね</rt></ruby>ならん</div><div class="tategaki-column"><ruby class="selected">有為<rt class="">うゐ</rt></ruby>の<ruby class="">奥山<rt class="">おくやま</rt></ruby> <ruby class="">今日<rt class="">けふ</rt></ruby><ruby class="">越<rt class="">こ</rt></ruby>えて <ruby class="">浅<rt class="">あさ</rt></ruby>き<ruby class="">夢<rt class="">ゆめ</rt></ruby><ruby class="">見<rt class="">み</rt></ruby>し <ruby class="">酔<rt class="">よ</rt></ruby>ひもせす</div>')
    @editor.append col
    @head.append cssLink 
    @body.append @editor
    @editor.resize (e) => console.log e
    @bindKeyEventHandlers()

  bindKeyEventHandlers: ->
    # @editor.on "focus", (e) =>
    #   @resetElementSelection()
    #   $(@selectedElement()).addClass "selected"
    
    @editor.on "keydown", (e) =>
      switch e.keyCode
        when 38
          @moveCaretToPrevChar()
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
          
    @editor.on "keydown click focus", =>
      @highlightSelected()      

  highlightSelected: ->      
    @resetElementSelection()
    @selected = $(@selectedElement())
    @selected.addClass "selected" unless @selected.hasClass("tategaki-column")

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
      alert "行をまたぐマークアップはできません"

  makeLink: (url) ->
    @markup("a", href: url)          

  ruby: (furigana) ->
    sel = @doc.getSelection()
    range = sel.getRangeAt(0)
    return if range.collapsed
    rubyElem = @doc.createElement("ruby")
    try
      range.surroundContents(rubyElem)
      furiganaText = @doc.createTextNode(furigana)
      furiganaElem = @doc.createElement("rt")
      furiganaElem.appendChild(furiganaText)
      rubyElem.appendChild(furiganaElem)
      sel.removeAllRanges()
      sel.addRange(range)
    catch e
      alert "行をまたぐルビは付けられません"

  removeMarkup: ->
    return null if @selected.hasClass("tategaki-column")
    console.log @selected
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
    if node.nodeType is 1 then node else node.parentElement
  
  resetElementSelection: ->
    @editor.find(".selected").removeClass("selected")
