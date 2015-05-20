init = (callback)->
  Tabletop.init
    key: '1CZrYzD1s41hJBaMiEvBXM2oAR-5pe-zpGIW6KjyH8xE'
    simpleSheet: true    
    callback: (data, tabletop) -> callback(data)

convert2Div= (text) ->
  text = text.replace(/\(/g,"（").replace(/\)/g,"）")
  text.replace /([一-龠]*)（([ぁ-んァ-ヶゝ]+)）/g, (match, kanji, ruby) ->
    """
        <ruby>
          <rb>#{kanji}</rb>
          <rt>#{ruby}</rt>            
        </ruby>
    """

init (data) ->
  div = $("#transcription")
  locations = {}
  console.log data
  for d in data
    loc = d['場所']
    unless locations[loc] 
      locations[loc] = ""

  for d in data
    loc = d['場所']
    text = convert2Div(d['翻刻文'])
    num = d['行数']
    lineHtml = """
      <div class='line'>
        <div class='linenum'>#{num}</div>
        <div class='linetext'>#{text}</div>
      </div>
    """
    locations[loc] += lineHtml

  for loc, text of locations  
    page = $("<div class='page'><div class='loc'>#{loc}</div>#{text}</div>")
    div.append(page)

    



