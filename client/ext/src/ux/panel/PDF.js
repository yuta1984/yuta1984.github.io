Ext.create('Ext.ux.panel.PDF', {
    title    : 'PDF Panel',
    width    : 489,
    height   : 633,
    pageScale: 0.75,                                           // Initial scaling of the PDF. 1 = 100%
    src      : 'http://cdn.mozilla.net/pdfjs/tracemonkey.pdf', // URL to the PDF - Same Domain or Server with CORS Support
    renderTo : Ext.getBody()
});