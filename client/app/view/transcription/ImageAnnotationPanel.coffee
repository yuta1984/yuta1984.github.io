Ext.define 'GSW.view.transcription.ImageAnnotationPanel',
  extend: 'Ext.panel.Panel'
  requires: ['GSW.view.transcription.form.ImageAnnotationForm']
  xtype: 'image-annnotation-panel'
  width: 350
  height: 120
  floating: true
  hidden: true
  cls: 'image-annotation-panel'
  style:
    "border-radius": "8px"
    
  constructor: (config) ->
    console.log "image annotation",config.model
    @callParent(config)
    @target = config.model.view
    @model = config.model
    @canvas = config.canvas
    user_id = @model.get('user_id')
    @user = Ext.getStore("GSW.store.UserStore").getById(user_id)    
    @target.on "mouseover", =>
      console.log @
      @showPanel()
    @target.on "mouseout", =>      
      @startHideTimer()
    @

  listeners:
    afterrender: (container)->
      return unless @model      
      @setHtml """
    <div class="annotation-comment">
      <p><b>#{@user.get('username')}</b> says:</p> 
      <div>#{@model.get('annotation')}</div>
    </div>
    <div class="buttons">
      <a href="#" class="annotation-button cancel">Delete</a>
    </div>      
      """

            
          
  startHideTimer: ->
    hidePanel = => @hidePanel()
    @timer = window.setTimeout hidePanel, 500

  showPanel: ->
    return unless @model and @user
    if @timer
      window.clearTimeout @timer
    rightCenter = @target.getRightCenter()
    origin = @canvas.translateToAbsolutePoint(rightCenter)
    @setPosition origin.x+12, origin.y-50
    @show true
    el = @getEl()
    el.setOpacity 0
    el.setOpacity 1, duration: 300, easing: 'ease-in'
    @getEl().hover =>
      window.clearTimeout(@timer) if @timer

  hidePanel: (callback)->
    return unless @model and @user
    @getEl().setOpacity 0,
      duration: 300
      easing: 'ease-in'
      listeners:
        afteranimate: =>
          @hide()
          callback() if callback


