function _8c5c8efcec4b21fe99d3ac3b53238dc88871a1b5(){};(function(){function a(f){var g="    ";if(isNaN(parseInt(f))){g=f}else{switch(f){case 1:g=" ";break;case 2:g="  ";break;case 3:g="   ";break;case 4:g="    ";break;case 5:g="     ";break;case 6:g="      ";break;case 7:g="       ";break;case 8:g="        ";break;case 9:g="         ";break;case 10:g="          ";break;case 11:g="           ";break;case 12:g="            ";break}}var e=["\n"];for(ix=0;ix<100;ix++){e.push(e[ix]+g)}return e}function b(){this.step="    ";this.shift=a(this.step)}b.prototype.xml=function(l,f){var h=l.replace(/>\s{0,}</g,"><").replace(/</g,"~::~<").replace(/\s*xmlns\:/g,"~::~xmlns:").replace(/\s*xmlns\=/g,"~::~xmlns=").split("~::~"),i=h.length,m=false,k=0,j="",g=0,e=f?a(f):this.shift;for(g=0;g<i;g++){if(h[g].search(/<!/)>-1){j+=e[k]+h[g];m=true;if(h[g].search(/-->/)>-1||h[g].search(/\]>/)>-1||h[g].search(/!DOCTYPE/)>-1){m=false}}else{if(h[g].search(/-->/)>-1||h[g].search(/\]>/)>-1){j+=h[g];m=false}else{if(/^<\w/.exec(h[g-1])&&/^<\/\w/.exec(h[g])&&/^<[\w:\-\.\,]+/.exec(h[g-1])==/^<\/[\w:\-\.\,]+/.exec(h[g])[0].replace("/","")){j+=h[g];if(!m){k--}}else{if(h[g].search(/<\w/)>-1&&h[g].search(/<\//)==-1&&h[g].search(/\/>/)==-1){j=!m?j+=e[k++]+h[g]:j+=h[g]}else{if(h[g].search(/<\w/)>-1&&h[g].search(/<\//)>-1){j=!m?j+=e[k]+h[g]:j+=h[g]}else{if(h[g].search(/<\//)>-1){j=!m?j+=e[--k]+h[g]:j+=h[g]}else{if(h[g].search(/\/>/)>-1){j=!m?j+=e[k]+h[g]:j+=h[g]}else{if(h[g].search(/<\?/)>-1){j+=e[k]+h[g]}else{if(h[g].search(/xmlns\:/)>-1||h[g].search(/xmlns\=/)>-1){j+=e[k]+h[g]}else{j+=h[g]}}}}}}}}}}return(j[0]=="\n")?j.slice(1):j};b.prototype.json=function(f,e){var e=e?e:this.step;if(typeof JSON==="undefined"){return f}if(typeof f==="string"){return JSON.stringify(JSON.parse(f),null,e)}if(typeof f==="object"){return JSON.stringify(f,null,e)}return f};b.prototype.css=function(l,j){var i=l.replace(/\s{1,}/g," ").replace(/\{/g,"{~::~").replace(/\}/g,"~::~}~::~").replace(/\;/g,";~::~").replace(/\/\*/g,"~::~/*").replace(/\*\//g,"*/~::~").replace(/~::~\s{0,}~::~/g,"~::~").split("~::~"),e=i.length,h=0,k="",g=0,f=j?a(j):this.shift;for(g=0;g<e;g++){if(/\{/.exec(i[g])){k+=f[h++]+i[g]}else{if(/\}/.exec(i[g])){k+=f[--h]+i[g]}else{if(/\*\\/.exec(i[g])){k+=f[h]+i[g]}else{k+=f[h]+i[g]}}}}return k.replace(/^\n{1,}/,"")};function d(f,e){return e-(f.replace(/\(/g,"").length-f.replace(/\)/g,"").length)}function c(f,e){return f.replace(/\s{1,}/g," ").replace(/ AND /ig,"~::~"+e+e+"AND ").replace(/ BETWEEN /ig,"~::~"+e+"BETWEEN ").replace(/ CASE /ig,"~::~"+e+"CASE ").replace(/ ELSE /ig,"~::~"+e+"ELSE ").replace(/ END /ig,"~::~"+e+"END ").replace(/ FROM /ig,"~::~FROM ").replace(/ GROUP\s{1,}BY/ig,"~::~GROUP BY ").replace(/ HAVING /ig,"~::~HAVING ").replace(/ IN /ig," IN ").replace(/ JOIN /ig,"~::~JOIN ").replace(/ CROSS~::~{1,}JOIN /ig,"~::~CROSS JOIN ").replace(/ INNER~::~{1,}JOIN /ig,"~::~INNER JOIN ").replace(/ LEFT~::~{1,}JOIN /ig,"~::~LEFT JOIN ").replace(/ RIGHT~::~{1,}JOIN /ig,"~::~RIGHT JOIN ").replace(/ ON /ig,"~::~"+e+"ON ").replace(/ OR /ig,"~::~"+e+e+"OR ").replace(/ ORDER\s{1,}BY/ig,"~::~ORDER BY ").replace(/ OVER /ig,"~::~"+e+"OVER ").replace(/\(\s{0,}SELECT /ig,"~::~(SELECT ").replace(/\)\s{0,}SELECT /ig,")~::~SELECT ").replace(/ THEN /ig," THEN~::~"+e+"").replace(/ UNION /ig,"~::~UNION~::~").replace(/ USING /ig,"~::~USING ").replace(/ WHEN /ig,"~::~"+e+"WHEN ").replace(/ WHERE /ig,"~::~WHERE ").replace(/ WITH /ig,"~::~WITH ").replace(/ ALL /ig," ALL ").replace(/ AS /ig," AS ").replace(/ ASC /ig," ASC ").replace(/ DESC /ig," DESC ").replace(/ DISTINCT /ig," DISTINCT ").replace(/ EXISTS /ig," EXISTS ").replace(/ NOT /ig," NOT ").replace(/ NULL /ig," NULL ").replace(/ LIKE /ig," LIKE ").replace(/\s{0,}SELECT /ig,"SELECT ").replace(/\s{0,}UPDATE /ig,"UPDATE ").replace(/ SET /ig," SET ").replace(/~::~{1,}/g,"~::~").split("~::~")}b.prototype.sql=function(q,g){var n=q.replace(/\s{1,}/g," ").replace(/\'/ig,"~::~'").split("~::~"),l=n.length,j=[],p=0,h=this.step,r=true,k=false,f=0,m="",i=0,e=g?a(g):this.shift;for(i=0;i<l;i++){if(i%2){j=j.concat(n[i])}else{j=j.concat(c(n[i],h))}}l=j.length;for(i=0;i<l;i++){f=d(j[i],f);if(/\s{0,}\s{0,}SELECT\s{0,}/.exec(j[i])){j[i]=j[i].replace(/\,/g,",\n"+h+h+"")}if(/\s{0,}\s{0,}SET\s{0,}/.exec(j[i])){j[i]=j[i].replace(/\,/g,",\n"+h+h+"")}if(/\s{0,}\(\s{0,}SELECT\s{0,}/.exec(j[i])){p++;m+=e[p]+j[i]}else{if(/\'/.exec(j[i])){if(f<1&&p){p--}m+=j[i]}else{m+=e[p]+j[i];if(f<1&&p){p--}}}var o=0}m=m.replace(/^\n{1,}/,"").replace(/\n{1,}/g,"\n");return m};b.prototype.xmlmin=function(g,e){var f=e?g:g.replace(/\<![ \r\n\t]*(--([^\-]|[\r\n]|-[^\-])*--[ \r\n\t]*)\>/g,"").replace(/[ \r\n\t]{1,}xmlns/g," xmlns");return f.replace(/>\s{0,}</g,"><")};b.prototype.jsonmin=function(e){if(typeof JSON==="undefined"){return e}return JSON.stringify(JSON.parse(e),null,0)};b.prototype.cssmin=function(g,e){var f=e?g:g.replace(/\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\//g,"");return f.replace(/\s{1,}/g," ").replace(/\{\s{1,}/g,"{").replace(/\}\s{1,}/g,"}").replace(/\;\s{1,}/g,";").replace(/\/\*\s{1,}/g,"/*").replace(/\*\/\s{1,}/g,"*/")};b.prototype.sqlmin=function(e){return e.replace(/\s{1,}/g," ").replace(/\s{1,}\(/,"(").replace(/\s{1,}\)/,")")};window.vkbeautify=new b()})();