// Generated by CoffeeScript 1.8.0
(function() {
  Ext.define('GSW.view.transcription.EditorTabPanel', {
    extend: 'Ext.tab.Panel',
    xtype: 'editor-tab-panel',
    requires: ['GSW.view.transcription.TategakiEditor'],
    items: [
      {
        title: 'Transcription',
        xtype: 'tategaki-editor'
      }, {
        title: 'Translation'
      }, {
        title: 'Notes'
      }
    ]
  });

}).call(this);
