Ext.define 'GSW.view.transcription.ImageAnnotationPanel',
  extend: 'Ext.panel.Panel'
  xtype: 'image-annnotation-panel'
  width: 350
  height: 120
  floating: true
  html: '''
    <div class="annotation-comment">
      <textarea class="annotation-textarea" placeholder="Add a comment (word with leading '#' will be recognized as a tag e.g. #kyoto-school）" ></textarea>
    </div>
    <div class="buttons">
      <a href="#" class="annotation-button save">Save</a>
      <a href="#" class="annotation-button cancel">Cancel</a>     
    </div>      
  '''
  hidden: true
  cls: 'image-annotation-panel'
  style:
    "border-radius": "8px"
    
  constructor: (config) ->
    @callParent(config)
    @target = config.target
    @canvas = config.canvas
    @model = config.model
    @target.on "mouseover", =>
      @showPanel()
    @target.on "mouseout", =>      
      @startHideTimer()
    @

  listeners:
    afterrender: (container)->
      container.getEl().on "click", (e, elem)=>
        switch elem.className
          when "annotation-button save"
            @model.set 'x', @target.getLeft()
            @model.set 'y', @target.getTop()
            @model.set 'w', @target.getWidth()
            @model.set 'h', @target.getHeight()
            @model.set 'target_uri', @canvas.surf.get('uri')
            @canvas.surf.get('annotations').push @model
            container.close()            
          when "annotation-button cancel"
            container.canvas.c.remove(container.target)
            container.canvas.c.renderAll()
            container.close()

  startHideTimer: ->
    hidePanel = => @hidePanel()
    @timer = window.setTimeout hidePanel, 500

  showPanel: ->
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
    $(@getEl().query("textarea")[0]).focus()

  hidePanel: ->
    @getEl().setOpacity 0,
      duration: 300
      easing: 'ease-in'
      afteranimate: =>
        @hide()
