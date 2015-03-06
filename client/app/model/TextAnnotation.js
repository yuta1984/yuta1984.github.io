// Generated by CoffeeScript 1.8.0
(function() {
  Ext.define('GSW.model.TextAnnotation', {
    extend: 'GSW.model.AbstractAnnotation',
    fields: [
      {
        name: 'elementURI',
        type: 'string',
        defaultValue: ''
      }
    ],
    getBodyType: function() {
      return "text/plain";
    },
    getTargetURI: function() {
      return this.get('elementURI');
    },
    getTargetType: function() {
      return "Text";
    },
    getMotivation: function() {
      return "commenting";
    },
    toTriples: function() {
      var triples;
      triples = this.callSuper();
      triples.push([this.getTargetURI(), this.p("rdf", "type"), this.p("dctypes", "Text")]);
      return triples;
    }
  });

}).call(this);
