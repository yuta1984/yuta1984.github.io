cl = (msg)-> console.log(msg)

class TategakiEditor
    
  constructor: (editor, options) ->
    @editor = $("#"+editor)
    @options =
      linenum: false
      keisen: false
    @options[k] = v for k, v of options if options and options instanceof(Object)
    cl @options
    @render()
    @

  el: ->
    @editor[0]

  render: ->
    @editor.attr("contenteditable", true).addClass("tategaki-editor")
    @editor.addClass("keisen") if @options["keisen"]

    # refresh the editor when enter key is pressed
    @editor.on "keyup", (e) =>
      @refresh() if e.keyCode is 13 

    # change the direction of the cursor move
    @editor.on "keydown", (e) =>
      cl getSelectionCoords()
      # if e.keyCode in [37, 38, 39, 40] 
      #   e.preventDefault()
      #   e.stopPropagation()
      #   switch e.keyCode 
      #     when 37 then @dispatchKeyboardEvent("keydown", 40)
      #     when 38 then @dispatchKeyboardEvent("keydown", 37)
      #     when 39 then @dispatchKeyboardEvent("keydown", 38)                    
      # true
  
  dispatchKeyboardEvent: (type, keyCode) ->
    e = if document.createEventObject then document.createEventObject() else document.createKeyEvent("Events")
    e.initEvent("keydown", true, true)
    e.keyCode = keyCode
    e.which = keyCode
    e.generated = true
    @el().dispatchEvent(e)
    cl e
    
    # oEvent = document.createEvent("KeyboardEvent")
    # Object.defineProperty oEvent, "keyCode",
    #   get: -> @keyCodeVal
    # oEvent.generated = true
    # oEvent.initKeyboardEvent "keydown", true, true, @el().defaultView, keyCode, keyCode,"","",false, ""
    # oEvent.keyCodeVal = keyCode
    # @el().dispatchEvent oEvent
    # oEvent

  refresh:->
    # pos = @getCaretPosition()
    # @editor.blur().focus()
    # @setCaretPosition(pos)
  
  getCaretPosition: ->
    caretOffset = 0
    range = window.getSelection().getRangeAt(0)
    preCaretRange = range.cloneRange()
    preCaretRange.selectNodeContents @el()
    preCaretRange.setEnd range.endContainer, range.endOffset
    caretOffset = preCaretRange.toString().length
    caretOffset    

  setCaretPosition: (pos) ->
    range = document.createRange()
    sel = window.getSelection()
    range.setStart(@el(), pos)
    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)
    @

window.TategakiEditor = TategakiEditor


getSelectionCoords = ->
  sel = document.selection
  range = undefined
  rect = undefined
  x = 0
  y = 0
  if sel
    unless sel.type is "Control"
      range = sel.createRange()
      range.collapse true
      x = range.boundingLeft
      y = range.boundingTop
  else if window.getSelection
    sel = window.getSelection()
    if sel.rangeCount
      range = sel.getRangeAt(0).cloneRange()
      cl range
      if range.getClientRects
        range.collapse true
        rect = range.getClientRects()[0]      
        x = rect.left
        y = rect.top      
  x: x
  y: y
