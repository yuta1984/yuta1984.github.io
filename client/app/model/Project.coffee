Ext.define 'GSW.model.Project',
  extend: 'GSW.model.Base'
  fields: [
    {name: 'title', type: 'string', defaultValue: ''}
    {name: 'description', type: 'string', defaultValue: ''}
  ]

  hasMany: [
    name: 'admins'
    model: 'GSW.model.User'
    associationKey:'admins'
  ,
    name: 'contributors'
    model: 'GSW.model.User'
    associationKey:'contributers'
  ,
    name: 'manuscripts'
    model: 'GSW.model.Manuscript'
    associationKey:'manuscripts'
  ]

  toTreeModel: ->
    manuscrits = for m in @get('manuscripts')
      text: m.get('title')
      leaf: false
      children: for i in m.get('images')
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
        manuscripts: manuscripts
      new this(config)
      
