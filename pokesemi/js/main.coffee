init = (callback)->
  Tabletop.init
    key: '1CZrYzD1s41hJBaMiEvBXM2oAR-5pe-zpGIW6KjyH8xE'
    simpleSheet: true    
    callback: (data, tabletop) -> callback(data)

convert2Div= (text) ->
  text.replace /([一-龠]*)（([ぁ-んァ-ヶゝ]+)）/g, (match, kanji, ruby) ->
    """
        <ruby>
          <rb>#{kanji}</rb>
          <rt>#{ruby}</rt>            
        </ruby>
    """

init (data) ->
  div = $("#transcription")
  console.log data
  for d in data    
    text = convert2Div(d['翻刻文'])
    line = $("<div>#{text}</div>")
    div.append(line)
    



