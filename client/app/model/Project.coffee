Ext.define 'GSW.model.Project',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'title', type: 'string', defaultValue: ''}
    {name: 'description', type: 'string', defaultValue: ''}
    {name: 'owner'}
    {name: 'admins', defaultValue: []}
    {name: 'contributors',  defaultValue: []}
  ]
  toTreeModel: ->
    manuscrits = for m in @manuscripts().data.items
      text: m.get('title')
      leaf: false
      children: for i in m.images().data.items
        text: i.get('title')
        leaf: true
        url: i.get('url')
        model: i
        type: 'image'
    root =
      text: 'ROOT'
      expanded: true
      children: [
        text: "Manuscripts"
        children: manuscrits
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
    root

  statics:
    fromJSON: (data) ->
      # project info
      name = data.name
      description = data.description
      # users
      owner = GSW.model.User.fromJSON(data.owner)
      admins = (GSW.model.User.fromJSON(admin) for admin in data.admins)
      contributors = (GSW.model.User.fromJSON(con) for con in data.contributors)
      # manuscripts
      manuscripts = (GSW.model.Manuscript.fromJSON(man) for man in data.manuscripts)
      config = 
        id: data._id.$oid
        name: name
        owner: owner
        admins: admins
        contributors: contributors
      p = new this(config)
      store = p.manuscripts()
      store.add manuscripts
      p
