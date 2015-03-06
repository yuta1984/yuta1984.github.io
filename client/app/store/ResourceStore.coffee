Ext.define "GSW.store.ResourceStore",
  extend: "Ext.data.TreeStore"
  requires: ["Ext.data.TreeModel"]
  root:
    text: "Ext JS"
    expanded: true
    children: [
      text: "Manuscripts"
      children: [
        text: "安政見聞録（上）"
        leaf: false
        children: [
          leaf: true, text: "Page 01", url: "http://yuta1984.github.io/images/ansei_jou/ansei_jou_01.jpg", type: "document"
          ,
          leaf: true, text: "Page 02", url: "http://yuta1984.github.io/images/ansei_jou/ansei_jou_02.jpg", type: "document"
        ]
      ]
    ,
      text: "Location/Map"
      expanded: false
      children: [
        leaf: true
        text: "Kyoto"
        type: "map"
      ]
    ,
      text: "People"
      expanded: false
      children: [
        leaf: true
        text: "Button.js"
      ]
    ,
      text: "Datetime"
      expanded: false
      children: [
        leaf: true
        text: "Button.js"
      ]
    ]
