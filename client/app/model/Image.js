// Generated by CoffeeScript 1.8.0
(function() {
  Ext.define('GSW.model.Image', {
    extend: 'GSW.model.Base',
    fields: [
      {
        name: 'title',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'url',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'url_thumbnail',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'transcription',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'translation',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'notes',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'manuscriptId',
        reference: 'Manuscript'
      }
    ],
    update: function(attr, value) {
      var params, url;
      this.set(attr, value);
      url = this.buildURL() + ".json";
      params = {};
      params["image[" + attr + "]"] = value;
      return Ext.Ajax.request({
        method: 'PUT',
        withCredentials: true,
        cors: true,
        useDefaultXhrHeader: false,
        url: url,
        params: params,
        success: function(data) {
          return console.log(data);
        }
      });
    },
    statics: {
      fromJSON: function(data) {
        var config;
        config = {
          id: data._id.$oid,
          title: data.title,
          url: data.image_data.url,
          url_thumbnail: data.image_data.thumbnail.url,
          transcription: data.transcription || '',
          translation: data.translation || '',
          notes: data.note || ''
        };
        return new this(config);
      }
    },
    buildURL: function() {
      var manuscriptId, projectId, server;
      server = GSW.app.getServerURL();
      manuscriptId = this.manuscript.id;
      projectId = this.manuscript.project.id;
      return [server, "projects", projectId, "manuscripts", manuscriptId, "images", this.id].join("/");
    }
  });

}).call(this);
