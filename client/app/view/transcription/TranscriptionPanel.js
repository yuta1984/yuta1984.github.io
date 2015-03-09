// Generated by CoffeeScript 1.8.0
(function() {
  Ext.define('GSW.view.transcription.TranscriptionPanel', {
    extend: 'Ext.panel.Panel',
    requires: ['GSW.view.transcription.TategakiEditor', 'GSW.view.transcription.CanvasPanel', 'GSW.view.transcription.EditorTabPanel', 'GSW.util.TeiConverter'],
    xtype: "transcription-panel",
    width: '100%',
    height: '100%',
    layout: 'border',
    bodyBorder: false,
    defaults: {
      collapsible: true,
      split: true,
      bodyPadding: 10
    },
    constructor: function(config) {
      this.image = config.image;
      this.image.on("update:image", (function(_this) {
        return function() {
          return _this.down("tategaki-editor").reload();
        };
      })(this));
      return this.callParent(arguments);
    },
    setBackgroundImg: function(url) {
      return this.child("canvas-panel").setBackgroundImg(url);
    },
    getImage: function() {
      return this.image;
    },
    items: [
      {
        xtype: 'canvas-panel',
        region: 'west',
        floatable: false,
        margin: 0,
        width: '50%',
        minWidth: 100,
        header: false
      }, {
        collapsible: false,
        region: 'center',
        header: false,
        margin: '5 0 0 0',
        xtype: 'editor-tab-panel',
        minWidth: 100,
        padding: 0,
        width: '50%',
        height: "100%"
      }
    ]
  });

}).call(this);
