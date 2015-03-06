// Generated by CoffeeScript 1.8.0

/**
The main application class. An instance of this class is created by app.js when it calls
Ext.application(). This is the ideal place to handle application launch and initialization
details.
 */

(function() {
  Ext.define("GSW.Application", {
    extend: "Ext.app.Application",
    name: "GSW",
    appProperty: 'app',
    stores: ["GSW.store.ResourceStore", "GSW.store.UserStore"],
    models: ["GSW.model.Project", "GSW.model.User", "GSW.model.Manuscript", "GSW.model.Image", "GSW.model.Surface", "GSW.model.Zone", "GSW.model.AbstractAnnotation", "GSW.model.ImageAnnotation", "GSW.model.TextAnnotation"],
    launch: function() {
      return this.fetchProject((function(_this) {
        return function(data) {
          data = JSON.parse(data.responseText);
          console.log(data);
          _this.loadProject(data);
          return Ext.getBody().unmask();
        };
      })(this));
    },
    loadGoogleMap: function() {
      var script;
      script = document.createElement('script');
      script.type = 'text/javascript';
      script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&callback=initializ e';
      return document.body.appendChild(script);
    },
    fetchProject: function(callback) {
      var getParams, params;
      Ext.getBody().mask("Loading...");
      getParams = document.URL.split("?");
      params = Ext.urlDecode(getParams[getParams.length - 1]);
      return Ext.Ajax.request({
        withCredentials: true,
        url: "" + (this.getServerURL()) + "projects/" + params.projectId + ".json",
        success: callback
      });
    },
    loadProject: function(data) {
      var store;
      this.project = GSW.model.Project.fromJSON(data);
      console.log({
        root: this.project.toTreeModel()
      });
      store = Ext.getStore("GSW.store.ResourceStore");
      Ext.getCmp("navigation-tree-panel").setTitle(this.project.get('name'));
      return store.setRootNode(this.project.toTreeModel());
    },
    getProject: function() {
      return this.project;
    },
    getServerURL: function() {
      if (document.URL = ~/localhost/) {
        return "http://localhost/gsweb/";
      } else {
        return "https://gsweb.herokuapp.com/";
      }
    }
  });

}).call(this);