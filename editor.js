function editorState (op) {
    "use strict";
    var rot, drot, per, dper, sizeTXT, sizeSVG, styleTXT, styleSVG;

    function delta (root, name) {
        if (root && root[name]) {
            var res = Number(root[name]);
            if ((res !== 1) && (res !== -1)) { return 0; }
            return res;
        }
        return 0;
    }

    function ring (name, delta, size, init) {
        var res;
        res = parseInt(localStorage [name]);
        if (res || res === 0) {
            res += delta;
            if (res >= size) {
                res -= size;
            } else if (res < 0) {
                res += size;
            }
        } else {
            res = init;
        }
        localStorage [name] = res;
        return res;
    }

    function setStyle (id, prop) {
        var e = document.getElementById(id);
        e.removeAttribute("style");
        for (var p in prop) {
            e.style [p] = prop [p];
        }
    }

    drot = delta(op, 'rot');
    dper = delta(op, 'per');
    rot = ring('drom.editor.rot', drot, 4, 0);
    per = ring('drom.editor.per', dper, 7, 3);
    sizeTXT = ((per + 2) * 10) + '%';
    sizeSVG = ((8 - per) * 10) + '%';

    if (rot === 1) {        // SVG|TXT
        styleSVG = {width: sizeSVG, height: '100%', cssFloat: 'left', overflow: 'hidden'};
        styleTXT = {                height: '100%'};
    } else if (rot === 2) { // SVG/TXT
        styleSVG = {width: '100%', height: sizeSVG, overflow: 'hidden'};
        styleTXT = {height: sizeTXT};
    } else if (rot === 3) { // TXT|SVG
        styleSVG = {width: sizeSVG, height: '100%', cssFloat: 'right', overflow: 'hidden'};
        styleTXT = {width: sizeTXT, height: '100%'};
    } else {                // TXT/SVG
        styleSVG = {width: '100%', height: sizeSVG, position: 'absolute', bottom: 0, overflow: 'hidden'};
        styleTXT = {height: sizeTXT};
    }
    setStyle('SVG', styleSVG);
    setStyle('TXT', styleTXT);
    WaveDrom.EditorRefresh();
}

function editorInit () {
    "use strict";
    if (document.location.search) {
      cm.setValue(decodeURIComponent(window.location.search.substr(1)));
      // document.getElementById ('InputJSON_0').value = decodeURIComponent(window.location.search.substr(1));
    }
    window.ondragover = function(e) { e.preventDefault(); return false; };
    window.ondrop = function(e) { e.preventDefault(); return false; };

    if (typeof process === "object") { // nodewebkit detection
      var holder = document.getElementById('content');
      holder.ondragover = function () { this.className = 'hover'; return false; };
      holder.ondragend = function () { this.className = ''; return false; };
      holder.ondrop = function (e) {
        e.preventDefault();

        for (var i = 0; i < e.dataTransfer.files.length; ++i) {
          console.log(e.dataTransfer.files[i].path);
        }
        return false;
      };
    }
    editorState();
}

function setFullURL () {
    "use strict";
    document.location.search = encodeURIComponent(document.getElementById('InputJSON_0').value);
}

function menuOpen (e) {
    "use strict";
    function closestById(el, id) {
        while (el.id !== id) {
            el = el.parentNode;
            if (!el) {
                return null;
            }
        }
        return el;
    }

    var doc = document.getElementById('menux');
    if (closestById(e.target, 'Menu') && (doc.style.display === "none")) {
        doc.style.display = "inline";
    } else {
        doc.style.display = "none";
    }
}

function gotoWaveDromHome () {
    "use strict";
    window.open("https://wavedrom.com").focus();
}

function gotoWaveDromGuide () {
    "use strict";
    window.open("tutorial.html").focus();
}

function saveJSON () {
    "use strict";

    var a;

    function sjson () {
        return localStorage.waveform;
    }

    function chooseFile(name) {
        var chooser = document.querySelector(name);

        chooser.addEventListener("change", function() {
            var fs = require('fs');
            var filename = this.value;
            if (!filename) { return; }
            fs.writeFile(filename, sjson(), function(err) {
                if(err) {
                    console.log("error");
                }
            });
            this.value = '';
        }, false);

        chooser.click();
    }

    if (typeof process === "object") { // nodewebkit detection
        chooseFile('#fileDialog');
    } else {
        a = document.createElement('a');
        a.href = 'data:text/json;base64,' + btoa(sjson());
        a.download = 'wavedrom.json';
        var theEvent = document.createEvent("MouseEvent");
        theEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        a.dispatchEvent(theEvent);
        // a.click();
    }
}

function saveSVG () {
    "use strict";

    var a;

    function ssvg () {
        var svg, ser;

        svg = document.getElementById("svgcontent_0");
        ser = new XMLSerializer();
        return '<?xml version="1.0" standalone="no"?>\n'
            + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
            + '<!-- Created with WaveDrom -->\n'
            + ser.serializeToString(svg);
    }

    function chooseFile(name) {
        var chooser = document.querySelector(name);

        chooser.addEventListener("change", function() {
            var fs = require('fs');
            var filename = this.value;
            if (!filename) { return; }
            fs.writeFile(filename, ssvg(), function(err) {
                if(err) {
                    console.log("error");
                }
            });
            this.value = '';
        }, false);
        chooser.click();
    }

    if (typeof process === "object") { // nodewebkit detection
        chooseFile('#fileDialogSVG');
    } else {
        a = document.createElement('a');
        a.href = 'data:image/svg+xml;base64,' + btoa(ssvg());
        a.download = 'wavedrom.svg';
        var theEvent = document.createEvent("MouseEvent");
        theEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        a.dispatchEvent(theEvent);
        // a.click();
    }
}

function savePNG () {
    "use strict";

    var a;

    function pngdata () {
        var svg, ser, ssvg, svgdata, img, canvas, context;

        svg = document.getElementById("svgcontent_0");
        ser = new XMLSerializer();
        ssvg = '<?xml version="1.0" standalone="no"?>\n'
            + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
            + '<!-- Created with WaveDrom -->\n'
            + ser.serializeToString(svg);

        svgdata = 'data:image/svg+xml;base64,' + btoa(ssvg);
        img = new Image();
        img.src = svgdata;
        canvas = document.createElement('canvas');
        canvas.width = img.width;
        canvas.height = img.height;
        context = canvas.getContext('2d');
        context.drawImage(img, 0, 0);
        return canvas.toDataURL('image/png');
    }

    function chooseFile(name) {
        var chooser = document.querySelector(name);

        chooser.addEventListener("change", function() {
            var fs = require('fs');
            var filename = this.value;
            if (!filename) { return; }
            var data = pngdata().replace(/^data:image\/\w+;base64,/, "");
            var buf = new Buffer(data, 'base64');
            fs.writeFile(filename, buf, function(err) {
                if(err) {
                    console.log("error");
                }
            });
            this.value = '';
        }, false);
        chooser.click();
    }

    if (typeof process === "object") { // nodewebkit detection
        chooseFile('#fileDialogPNG');
    } else {
        a = document.createElement('a');
        a.href = pngdata();
        a.download = 'wavedrom.png';
        var theEvent = document.createEvent("MouseEvent");
        theEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        a.dispatchEvent(theEvent);
        // a.click();
    }
}

/* eslint-env node, browser */
/* eslint quotes:0, new-cap:0 */
/* global WaveDrom, cm */
