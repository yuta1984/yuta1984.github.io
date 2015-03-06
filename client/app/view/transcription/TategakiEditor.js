// Generated by CoffeeScript 1.8.0
(function() {
  (function() {
    Ext.define("GSW.view.transcription.TategakiEditor", {
      extend: "Ext.panel.Panel",
      xtype: "tategaki-editor",
      requires: ["GSW.view.transcription.form.RubyForm", "GSW.view.transcription.ContextMenu"],
      bodyBorder: false,
      layout: "fit",
      padding: 0,
      margin: 0,
      dockedItems: [
        {
          dock: "top",
          xtype: "toolbar",
          margin: 0,
          padding: 0,
          border: 1,
          style: {
            "background-color": "rgb(235,235,235)"
          },
          items: [
            {
              iconCls: null,
              text: "Text",
              xtype: "splitbutton",
              menu: [
                {
                  text: "ルビ",
                  value: "ruby",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "追加 (add)",
                  value: "add",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "削除 (del)",
                  value: "del",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "空白 (gap)",
                  value: "gap",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "ハイライト (hi)",
                  value: "hi",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "不明瞭 (unclear)",
                  value: "unclear",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "選択肢 (choice)",
                  value: "choice",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "破損 (damage)",
                  value: "damage",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }
              ]
            }, {
              iconCls: null,
              text: "Dates/Names",
              xtype: "splitbutton",
              menu: [
                {
                  text: "日付 (date)",
                  value: "date",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "団体・組織名 (orgName)",
                  value: "orgName",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "人名 (persName)",
                  value: "persName",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "役職名 (roleName)",
                  value: "roleName",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "場所名 (placeName)",
                  value: "placeName",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }, {
                  text: "地域・地方名 (region)",
                  value: "region",
                  handler: function(item, e) {
                    return this.up("tategaki-editor").onMarkupButtonPressed(item, e);
                  }
                }
              ]
            }, {
              iconCls: null,
              text: "Misk",
              xtype: "splitbutton",
              menu: [
                {
                  text: "リンク (link)",
                  value: "link"
                }, {
                  text: "外字 (gaiji)",
                  value: "gaiji"
                }
              ]
            }, "-", {
              iconCls: null,
              xtype: "button",
              text: "Delete markup"
            }
          ]
        }
      ],
      constructor: function(config) {
        return this.callParent(arguments);
      },
      listeners: {
        afterrender: function() {
          this.buildEditor();
          return this.updateText();
        }
      },
      updateText: function() {
        var image, text;
        image = this.up('transcription-panel').getImage();
        text = image.get('transcription');
        if (text.length === 0) {
          text = "<div class='tategaki-column'></div>";
        }
        return this.source(text);
      },
      saveText: function() {
        var image, source;
        source = this.getSource();
        image = this.up('transcription-panel').getImage();
        image.set('transcription', source);
        return image.notifyRemote('transcription');
      },
      buildEditor: function() {
        var iframeId;
        iframeId = void 0;
        iframeId = "iframe-" + this.getId();
        this.setHtml("<iframe id='" + iframeId + "' width='100%' height='100%' style='border: none;'></iframe>");
        this.editor = new window.TategakiEditor(iframeId);
        $(".tategaki-editor", this.editor.doc).css("height", "100%");
        this.editor.on("element:selected", function() {});
        this.editor.on("change", (function(_this) {
          return function() {
            return _this.saveText();
          };
        })(this));
        this.editor.on("contextmenu", (function(_this) {
          return function(e) {
            var offset;
            offset = void 0;
            if (_this.editor.selectedElement()) {
              _this.menu = Ext.create("GSW.view.transcription.ContextMenu", {
                editor: _this
              });
              offset = _this.editor.getIframeOffset();
              _this.menu.showAt(offset.left + e.clientX, offset.top + e.clientY);
              return e.preventDefault();
            }
          };
        })(this));
        return this.editor.on("mousedown", (function(_this) {
          return function(e) {
            if (_this.menu) {
              return _this.menu.close();
            }
          };
        })(this));
      },
      source: function(s) {
        return this.editor.source(s);
      },
      getSource: function() {
        return this.editor.getHtmlSource();
      },
      getTeiSource: function() {
        var html;
        html = void 0;
        html = this.getSource();
        return $(html);
      },
      markup: function(item, attrs) {
        var teiAttrs;
        teiAttrs = void 0;
        if (attrs == null) {
          attrs = {};
        }
        teiAttrs = {};
        teiAttrs["type"] = item.value;
        teiAttrs["class"] = "tei-element tei:" + item.value;
        return this.editor.markup("span", teiAttrs);
      },
      ruby: function(text) {
        return this.editor.ruby(text, {
          "class": "tei-element tei:ruby"
        });
      },
      openAnnotationDialog: function() {
        if (!this.editor.selectedElement()) {
          return Ext.Msg.alert("アノテーション対象が選択されていません");
        }
      },
      onMarkupButtonPressed: function(item, e) {
        var form;
        form = void 0;
        console.log(item);
        switch (item.value) {
          case "ruby":
            form = Ext.create("GSW.view.transcription.form.RubyForm", {
              editor: this
            });
            return form.show();
        }
      }
    });
  }).call(this);

}).call(this);
