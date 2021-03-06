// Generated by CoffeeScript 1.8.0
(function() {
  var SHEET_KEY, fire, generateBillboard, generateDescriptions, loadLocations, setupViewer, viewer;

  SHEET_KEY = "10k-arsvozpn1y5U-3OwfM_qYPNQTMN7UIJilHHNJrjs";

  loadLocations = function(callback) {
    var locations;
    console.log("load locations");
    locations = {};
    return Tabletop.init({
      key: SHEET_KEY,
      simpleSheet: false,
      callback: function(data) {
        var d, locName, location, _i, _j, _len, _len1, _ref, _ref1;
        console.log(data);
        _ref = data["Location master"].elements;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          d = _ref[_i];
          if (!(d["Coordinates"].length > 0)) {
            continue;
          }
          locations[d["Name ENG"]] = {
            name: d["Name ENG"],
            type: d["Type"],
            lat: parseFloat(d["Coordinates"].split(", ")[0]),
            long: parseFloat(d["Coordinates"].split(", ")[1]),
            alt: parseFloat(d["Altitude"]),
            comment: d["Comment"],
            damages: [],
            im: d["im"] + ".png"
          };
        }
        _ref1 = data["Damage descriptions"].elements;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          d = _ref1[_j];
          locName = d["English location name"];
          location = locations[locName];
          if (!location) {
            continue;
          }
          location.damages.push(d);
        }
        return callback(locations);
      }
    });
  };

  generateDescriptions = function(location) {
    var d, descriptionHTML, id, name, text, types, _i, _len, _ref;
    descriptionHTML = "";
    _ref = location.damages;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      d = _ref[_i];
      name = location.name;
      id = d["XML ID"];
      types = d["Type"];
      text = d["Text"];
      text = text.replace(location.name, "<span style='color: yellow; font-weight: bold;'>" + name + "</span>");
      descriptionHTML += "<div style=\"padding: 5px;\">\n  <p style=\"color: red; font-size: 18px;\">" + types + "</p>\n  <div>..." + text + "...</div>\n  <a href=\"transcription/shinetsu.html#" + id + "\" target=\"_blank\" style=\"color: blue;\">View source</a>\n</div>";
    }
    return descriptionHTML;
  };

  generateBillboard = function(location) {
    var width;
    width = location["im"].length === 6 ? 100 : 50;
    return new Cesium.BillboardGraphics({
      image: location["im"],
      width: width,
      height: 50
    });
  };

  setupViewer = function() {
    var layers, osm, viewer;
    viewer = new Cesium.Viewer('mapdiv', {
      animation: true,
      baseLayerPicker: false,
      fullscreenButton: false,
      geocoder: false,
      homeButton: false,
      navigationHelpButton: false,
      sceneModePicker: false,
      scene3DOnly: true,
      timeline: false,
      imageryProvider: new Cesium.OpenStreetMapImageryProvider({
        url: '//cyberjapandata.gsi.go.jp/xyz/relief/'
      }),
      terrainProvider: new Cesium.JapanGSITerrainProvider({
        heightPower: 2.0
      })
    });
    layers = viewer.scene.imageryLayers;
    osm = layers.addImageryProvider(new Cesium.OpenStreetMapImageryProvider());
    osm.alpha = 0.6;
    return viewer;
  };

  viewer = setupViewer();

  fire = 'fh.png';

  loadLocations(function(locations) {
    var descHTML, l, name;
    console.log(locations);
    for (name in locations) {
      l = locations[name];
      descHTML = generateDescriptions(l);
      viewer.entities.add({
        name: name,
        position: Cesium.Cartesian3.fromDegrees(l.long, l.lat, l.alt * 2),
        description: descHTML,
        billboard: generateBillboard(l),
        point: {
          pixelSize: 5,
          color: Cesium.Color.RED,
          outlineColor: Cesium.Color.WHITE,
          outlineWidth: 2
        },
        label: {
          text: name,
          font: '12pt monospace',
          style: Cesium.LabelStyle.FILL_AND_OUTLINE,
          outlineWidth: 2,
          verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
          pixelOffset: new Cesium.Cartesian2(0, 30)
        }
      });
    }
    return viewer.zoomTo(viewer.entities);
  });

}).call(this);
