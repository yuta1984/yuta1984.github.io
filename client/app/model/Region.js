// Generated by CoffeeScript 1.8.0
(function() {
  Ext.define('GSW.model.Region', {
    extend: 'GSW.model.Base',
    fields: [
      {
        name: 'x',
        type: 'integer',
        defaultValue: 0
      }, {
        name: 'y',
        type: 'integer',
        defaultValue: 0
      }, {
        name: 'w',
        type: 'integer',
        defaultValue: 0
      }, {
        name: 'h',
        type: 'integer',
        defaultValue: 0
      }, {
        name: 'annotation',
        type: 'string',
        defaultValue: ''
      }, {
        name: 'image_id',
        reference: 'Image'
      }, {
        name: 'user_id',
        reference: 'User'
      }
    ],
    crop: function() {
      var image;
      image = this.getImage() || this.get('image');
      return image.crop(this.get('x'), this.get('y'), this.get('w'), this.get('h'));
    },
    update: function(attr, value) {
      this.set(attr, value);
      this.updateOnServer(attr, value);
      return this.notifyUpdate(attr, value);
    },
    createOnServer: function(callback) {
      var params, url;
      console.log("creating model on server", this);
      url = this.buildURL("create") + ".json";
      console.log("create url", url);
      params = {
        "region[x]": this.get('x'),
        "region[y]": this.get('y'),
        "region[w]": this.get('w'),
        "region[h]": this.get('h'),
        "region[annotation]": this.get('annotation'),
        "region[image_id]": this.get('image_id'),
        "region[user_id]": this.get('user_id')
      };
      return Ext.Ajax.request({
        method: 'POST',
        withCredentials: true,
        cors: true,
        useDefaultXhrHeader: false,
        url: url,
        params: params,
        success: (function(_this) {
          return function(res) {
            var data;
            data = JSON.parse(res.responseText);
            console.log(data);
            _this.set('id', data._id.$oid);
            return callback();
          };
        })(this)
      });
    },
    notifyCreation: function() {
      var attrs, params;
      attrs = {
        x: this.get('x'),
        y: this.get('y'),
        w: this.get('w'),
        h: this.get('h'),
        id: this.get('id'),
        annotation: this.get('annotation'),
        image_id: this.image.id,
        user_id: GSW.app.me.id
      };
      params = {
        type: "create:region",
        attrs: attrs
      };
      return TogetherJS.send(params);
    },
    notifyUpdate: function(attr, value) {
      var data;
      data = {
        type: "update:region",
        id: this.id,
        attrs: {}
      };
      data["attrs"][attr] = value;
      return TogetherJS.send(data);
    },
    updateOnServer: function(attr, value) {
      var params, url;
      url = this.buildURL("update") + ".json";
      params = {};
      params["region[" + attr + "]"] = value;
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
        var config, region;
        config = {
          id: data._id.$oid,
          x: data.x || 0,
          y: data.y || 0,
          w: data.w || 0,
          h: data.h || 0,
          annotation: data.annotation || "",
          image_id: data.image_id || "",
          user_id: data.user_id.$oid || "",
          user: Ext.getStore('GSW.store.UserStore').getById(data.user_id)
        };
        region = new this(config);
        Ext.getStore('GSW.store.RegionStore').add(region);
        return region;
      },
      create: function(data) {
        var region;
        region = new this(data);
        region.set('user_id', GSW.app.me.id);
        data.image.regions().add(region);
        Ext.getStore('GSW.store.RegionStore').add(region);
        region.createOnServer(function() {
          return region.notifyCreation();
        });
        return region;
      }
    },
    buildURL: function(action) {
      var image, manuscript, project, server;
      server = GSW.app.getServerURL();
      image = this.getImage();
      console.log("image", image);
      manuscript = image.getManuscript();
      console.log("manuscript", manuscript);
      project = manuscript.getProject();
      console.log("project", project);
      switch (action) {
        case "update":
          return [server, "projects", project.id, "manuscripts", manuscript.id, "images", image.id, "regions", this.id].join("/");
        case "create":
          return [server, "projects", project.id, "manuscripts", manuscript.id, "images", image.id, "regions"].join("/");
        default:
          return [server, "projects", project.id, "manuscripts", manuscript.id, "images", image.id, "regions", this.id].join("/");
      }
    }
  });

}).call(this);
