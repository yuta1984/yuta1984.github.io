// Generated by CoffeeScript 1.8.0
(function() {
  Ext.define('GSW.view.transcription.state.ImageSelectionState', {
    extend: 'GSW.view.transcription.state.DefaultState',
    requires: ['GSW.model.ImageAnnotation', 'GSW.view.transcription.ImageAnnotationPanel', 'GSW.view.transcription.menu.CanvasContextMenu', 'GSW.view.transcription.form.ImageAnnotationForm'],
    Onswitchstate: function() {
      this.drawMode = false;
      this.origin = null;
      return this.region = null;
    },
    mousedown: function(event) {
      var options;
      if (!this.drawMode) {
        this.drawMode = true;
        this.origin = this.canvas.c.getPointer(event.e);
        options = {
          width: 0,
          height: 0,
          left: this.origin.x,
          top: this.origin.y,
          canvas: this.canvas.c
        };
        this.region = new fabric.Region(options);
        this.canvas.c.add(this.region);
        this.canvas.c.renderAll();
        return console.log(this.region);
      }
    },
    mousemove: function(event) {
      var h, mouse, w;
      if (this.drawMode) {
        mouse = this.canvas.c.getPointer(event.e);
        w = Math.abs(mouse.x - this.origin.x);
        h = Math.abs(mouse.y - this.origin.y);
        this.region.set("width", w).set("height", h);
        return this.canvas.c.renderAll();
      }
    },
    mouseout: function(event) {
      return this._onZoneCreated(event);
    },
    mouseup: function(event) {
      return this._onZoneCreated(event);
    },
    _onZoneCreated: function(event) {
      var model;
      this.drawMode = false;
      console.log(this.region);
      model = this._createRegionModel(this.region);
      this.canvas.attatchAnnotationPanel(model);
      this._showAnnotationForm(model);
      this.region = null;
      return this.canvas.resetState();
    },
    _createRegionModel: function(region) {
      var config, image, model;
      image = this.canvas.getImageModel();
      config = {
        x: Math.ceil(region.get('left')),
        y: Math.ceil(region.get('top')),
        w: Math.ceil(region.get('width')),
        h: Math.ceil(region.get('height')),
        image: image,
        user: GSW.app.me,
        user_id: GSW.app.me.id
      };
      model = new GSW.model.Region(config);
      region.model = model;
      model.view = region;
      image.regions().add(model);
      return model;
    },
    _showAnnotationForm: function(model) {
      var form;
      form = Ext.create('GSW.view.transcription.form.ImageAnnotationForm', {
        model: model,
        canvas: this.canvas
      });
      return form.show();
    }
  });

}).call(this);
