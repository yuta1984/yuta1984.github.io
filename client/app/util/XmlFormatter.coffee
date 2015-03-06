Ext.define 'GSW.util.XmlFormatter',
  singleton: true


  format: (src) ->
    window.hljs.configure
      tabReplace: true
      useBR: true
    beautified = window.vkbeautify.xml src
    highlighted = window.hljs.highlight("xml", beautified).value 
    lines = for l in highlighted.split("\n")
      spaceCnt = l.indexOf('<')
      l = "<span style='padding-left: #{spaceCnt*5}px'></span>" + l
    lines.join('<br/>') 
