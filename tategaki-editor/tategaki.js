// Generated by CoffeeScript 1.7.1
(function() {
  var TategakiEditor;

  $(document).ready(function() {
    window.tategakiEditor = new TategakiEditor("#tategaki");
    $("#ruby").click(function() {
      var furigana;
      furigana = window.prompt("ルビ文字を入力してください", "ふりがな");
      return window.tategakiEditor.ruby(furigana);
    });
    $("#markup").click(function() {
      var tagName;
      tagName = window.prompt("タグ名を入力してください", "strong");
      return window.tategakiEditor.markup(tagName);
    });
    $("#remove-markup").click(function() {
      window.tategakiEditor.removeMarkup();
      return window.tategakiEditor.resetElementSelection();
    });
    $("#link").click(function() {
      var url;
      url = window.prompt("URLを入力してください", "http://google.com");
      return window.tategakiEditor.makeLink(url);
    });
    return $("#source").click(function() {
      return alert(tategakiEditor.getHtmlSource());
    });
  });

  TategakiEditor = (function() {
    function TategakiEditor(iframeId, options) {
      if (options == null) {
        options = {};
      }
      this.iframeId = iframeId;
      this.colNum = options["colNum"] || 10;
      this.colWidth = options["colWidth"] || 15;
      this.render();
    }

    TategakiEditor.prototype.render = function() {
      var col, cssLink, iframe;
      iframe = $(this.iframeId);
      this.doc = iframe[0].contentWindow.document;
      this.head = $('head', this.doc);
      this.body = $('body', this.doc);
      cssLink = $('<link rel="stylesheet" type="text/css" href="./tategaki.css"/>');
      this.editor = $('<div contenteditable class="tategaki-editor"></div>').height(this.body.height());
      col = $('<div class="tategaki-column"><ruby class="">色<rt class="">いろ</rt></ruby>は<ruby class="">匂<rt class="">にほ</rt></ruby>えど <ruby class="">散<rt class="">ち</rt></ruby>りぬるを <ruby class="">我<rt>わ</rt></ruby>が<ruby class="">世<rt class="">よ</rt></ruby><ruby class="">誰<rt>たれ</rt></ruby>ぞ <ruby class="">常<rt class="">つね</rt></ruby>ならん</div><div class="tategaki-column"><ruby class="selected">有為<rt class="">うゐ</rt></ruby>の<ruby class="">奥山<rt class="">おくやま</rt></ruby> <ruby class="">今日<rt class="">けふ</rt></ruby><ruby class="">越<rt class="">こ</rt></ruby>えて <ruby class="">浅<rt class="">あさ</rt></ruby>き<ruby class="">夢<rt class="">ゆめ</rt></ruby><ruby class="">見<rt class="">み</rt></ruby>し <ruby class="">酔<rt class="">よ</rt></ruby>ひもせす</div>');
      this.editor.append(col);
      this.head.append(cssLink);
      this.body.append(this.editor);
      this.editor.resize((function(_this) {
        return function(e) {
          return console.log(e);
        };
      })(this));
      return this.bindKeyEventHandlers();
    };

    TategakiEditor.prototype.bindKeyEventHandlers = function() {
      this.editor.on("keydown", (function(_this) {
        return function(e) {
          switch (e.keyCode) {
            case 38:
              _this.moveCaretToPrevChar();
              e.stopPropagation();
              return e.preventDefault();
            case 40:
              _this.moveCaretToNextChar();
              e.stopPropagation();
              return e.preventDefault();
            case 37:
              _this.moveCaretToNextLine();
              e.stopPropagation();
              return e.preventDefault();
            case 39:
              _this.moveCaretToPrevLine();
              e.stopPropagation();
              return e.preventDefault();
          }
        };
      })(this));
      return this.editor.on("keydown click focus", (function(_this) {
        return function() {
          return _this.highlightSelected();
        };
      })(this));
    };

    TategakiEditor.prototype.highlightSelected = function() {
      this.resetElementSelection();
      this.selected = $(this.selectedElement());
      if (!this.selected.hasClass("tategaki-column")) {
        return this.selected.addClass("selected");
      }
    };

    TategakiEditor.prototype.getHtmlSource = function() {
      return $(this.editor).html();
    };

    TategakiEditor.prototype.markup = function(elemName, attrs) {
      var e, key, markup, range, sel, val;
      if (attrs == null) {
        attrs = {};
      }
      sel = this.doc.getSelection();
      range = sel.getRangeAt(0);
      if (range.collapsed) {
        return;
      }
      markup = this.doc.createElement(elemName);
      for (key in attrs) {
        val = attrs[key];
        markup.setAttribute(key, val);
      }
      try {
        range.surroundContents(markup);
        sel.removeAllRanges();
        return sel.addRange(range);
      } catch (_error) {
        e = _error;
        return alert("行をまたぐマークアップはできません");
      }
    };

    TategakiEditor.prototype.makeLink = function(url) {
      return this.markup("a", {
        href: url
      });
    };

    TategakiEditor.prototype.ruby = function(furigana) {
      var e, furiganaElem, furiganaText, range, rubyElem, sel;
      sel = this.doc.getSelection();
      range = sel.getRangeAt(0);
      if (range.collapsed) {
        return;
      }
      rubyElem = this.doc.createElement("ruby");
      try {
        range.surroundContents(rubyElem);
        furiganaText = this.doc.createTextNode(furigana);
        furiganaElem = this.doc.createElement("rt");
        furiganaElem.appendChild(furiganaText);
        rubyElem.appendChild(furiganaElem);
        sel.removeAllRanges();
        return sel.addRange(range);
      } catch (_error) {
        e = _error;
        return alert("行をまたぐルビは付けられません");
      }
    };

    TategakiEditor.prototype.removeMarkup = function() {
      if (this.selected.hasClass("tategaki-column")) {
        return null;
      }
      console.log(this.selected);
      this.selected.contents().unwrap();
      return this.selected = null;
    };

    TategakiEditor.prototype.moveCaretToNextLine = function() {
      var next, range, sel, x, y;
      if (!(next = this.nextColumn())) {
        return;
      }
      x = next.offsetLeft + next.offsetWidth / 2;
      y = this.getCaretCoordinates().top;
      try {
        sel = this.doc.getSelection();
        range = this.doc.caretRangeFromPoint(x, y);
        sel.removeAllRanges();
        return sel.addRange(range);
      } catch (_error) {}
    };

    TategakiEditor.prototype.moveCaretToPrevLine = function() {
      var prev, range, sel, x, y;
      if (!(prev = this.prevColumn())) {
        return;
      }
      x = prev.offsetLeft + prev.offsetWidth / 2;
      y = this.getCaretCoordinates().top;
      try {
        sel = this.doc.getSelection();
        range = this.doc.caretRangeFromPoint(x, y);
        sel.removeAllRanges();
        return sel.addRange(range);
      } catch (_error) {}
    };

    TategakiEditor.prototype.getCaretCoordinates = function() {
      var parent, position, range, span;
      range = this.doc.getSelection().getRangeAt(0).cloneRange();
      span = $("<span></span>");
      range.insertNode(span[0]);
      position = $(span).offset();
      parent = span[0].parentNode;
      parent.removeChild(span[0]);
      parent.normalize();
      return position;
    };

    TategakiEditor.prototype.moveCaretToNextChar = function() {
      var el, nextNode, range, sel;
      if (!this.editor.is(":focus")) {
        return null;
      }
      range = this.doc.getSelection().getRangeAt(0).cloneRange();
      sel = this.doc.getSelection();
      el = range.startContainer;
      if (el.length === range.startOffset) {
        nextNode = this.findNextTextNode(el);
        if (!nextNode) {
          return;
        }
        range.setStart(nextNode, 0);
      } else {
        range.setStart(el, range.startOffset + 1);
      }
      sel.removeAllRanges();
      return sel.addRange(range);
    };

    TategakiEditor.prototype.moveCaretToPrevChar = function() {
      var el, prevNode, range, sel;
      if (!this.editor.is(":focus")) {
        return null;
      }
      range = this.doc.getSelection().getRangeAt(0).cloneRange();
      sel = this.doc.getSelection();
      el = range.startContainer;
      if (range.startOffset === 0) {
        prevNode = this.findPrevTextNode(el);
        if (!prevNode) {
          return;
        }
        range.setStart(prevNode, prevNode.length);
        range.setEnd(prevNode, prevNode.length);
      } else {
        range.setStart(el, range.startOffset - 1);
        range.setEnd(el, range.endOffset - 1);
      }
      sel.removeAllRanges();
      return sel.addRange(range);
    };

    TategakiEditor.prototype.findNextTextNode = function(el) {
      if (el.nextSibling) {
        if (el.nextSibling.nodeType === 3) {
          if (el.nextSibling.length > 0) {
            return el.nextSibling;
          } else {
            return this.findNextTextNode(el.nextSibling);
          }
        } else if (el.nextSibling.hasChildNodes()) {
          if (el.nextSibling.firstChild.nodeType === 3) {
            return el.nextSibling.firstChild;
          }
          return this.findNextTextNode(el.nextSibling.firstChild);
        }
      } else {
        while (!el.parentNode.nextSibling) {
          el = el.parentNode;
          if (el === this.editor[0]) {
            return null;
          }
        }
        return this.findNextTextNode(el.parentNode);
      }
    };

    TategakiEditor.prototype.findPrevTextNode = function(el) {
      if (el.previousSibling) {
        if (el.previousSibling.nodeType === 3) {
          if (el.previousSibling.length > 0) {
            return el.previousSibling;
          } else {
            return this.findPrevTextNode(el.previousSibling);
          }
        } else if (el.previousSibling.hasChildNodes()) {
          if (el.previousSibling.lastChild.nodeType === 3) {
            return el.previousSibling.lastChild;
          }
          return this.findPrevTextNode(el.previousSibling.lastChild);
        }
      } else {
        while (!el.parentNode.previousSibling) {
          el = el.parentNode;
          if (el === this.editor[0]) {
            return null;
          }
        }
        return this.findPrevTextNode(el.parentNode);
      }
    };

    TategakiEditor.prototype.getCaretPosition = function() {
      var range;
      if (!this.editor.is(":focus")) {
        return null;
      }
      range = this.doc.getSelection().getRangeAt(0);
      return {
        el: range.startContainer,
        offset: range.startOffset
      };
    };

    TategakiEditor.prototype.setCaretPosition = function(colIndex, offset) {
      var range, sel;
      if (!this.editor.is(":focus")) {
        return null;
      }
      range = this.doc.createRange();
      sel = this.doc.getSelection();
      range.setStart(this.editor[0].childNodes[colIndex], offset);
      range.collapse(true);
      sel.removeAllRanges();
      return sel.addRange(range);
    };

    TategakiEditor.prototype.prevColumn = function() {
      var current;
      if (current = this.currentColumn()) {
        return current.previousSibling;
      } else {
        return null;
      }
    };

    TategakiEditor.prototype.nextColumn = function() {
      var current;
      if (current = this.currentColumn()) {
        return current.nextSibling;
      } else {
        return null;
      }
    };

    TategakiEditor.prototype.currentColumn = function() {
      var node, p;
      if (!this.editor.is(":focus")) {
        return null;
      }
      if (!(node = this.doc.getSelection().focusNode)) {
        return null;
      }
      console.log(node);
      if (node.nodeType === 1) {
        p = node;
      } else {
        p = node.parentElement;
      }
      while (!$(p).hasClass("tategaki-column")) {
        p = p.parentElement;
      }
      return p;
    };

    TategakiEditor.prototype.selectedElement = function() {
      var node;
      if (!this.editor.is(":focus")) {
        return null;
      }
      node = this.doc.getSelection().focusNode;
      if (node.nodeType === 1) {
        return node;
      } else {
        return node.parentElement;
      }
    };

    TategakiEditor.prototype.resetElementSelection = function() {
      return this.editor.find(".selected").removeClass("selected");
    };

    return TategakiEditor;

  })();

}).call(this);