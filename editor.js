'use strict';

(function () {

    function delta (root, name) {
        if (root && root[name]) {
            var res = Number(root[name]);
            if ((res !== 1) && (res !== -1)) { return 0; }
            return res;
        }
        return 0;
    }

    function ring (name, inc, size, init) {
        var res;
        res = parseInt(localStorage [name]);
        if (res || res === 0) {
            res += inc;
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
        e.removeAttribute('style');
        for (var p in prop) {
            e.style [p] = prop [p];
        }
    }

    function editorState (op) {
        var drot = delta(op, 'rot');
        var dper = delta(op, 'per');
        var rot = ring('drom.editor.rot', drot, 4, 0);
        var per = ring('drom.editor.per', dper, 7, 3);
        var sizeTXT = ((per + 2) * 10) + '%';
        var sizeSVG = ((8 - per) * 10) + '%';

        var styleTXT, styleSVG;
        if (rot === 1) {        // SVG|TXT
            styleSVG = {width: sizeSVG, height: '100%', cssFloat: 'left', overflow: 'hidden'};
            styleTXT = {height: '100%'};
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
        if (document.location.search) {
            WaveDrom.cm.setValue(decodeURIComponent(window.location.search.substr(1)));
            // document.getElementById ('InputJSON_0').value = decodeURIComponent(window.location.search.substr(1));
        }
        window.ondragover = function(e) { e.preventDefault(); return false; };
        window.ondrop = function(e) { e.preventDefault(); return false; };

        if (typeof process === 'object') { // nodewebkit detection
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
        document.location.search = encodeURIComponent(document.getElementById('InputJSON_0').value);
    }

    function menuOpen (e) {
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
        if (closestById(e.target, 'Menu') && (doc.style.display === 'none')) {
            doc.style.display = 'inline';
        } else {
            doc.style.display = 'none';
        }
    }

    function gotoWaveDromHome () {
        window.open('http://wavedrom.com').focus();
    }

    function gotoWaveDromGuide () {
        window.open('tutorial.html').focus();
    }

    function loadJSON () {

        function chooseFile(name) {
            var chooser = document.querySelector(name);

            chooser.addEventListener('change', function() {
                var fs = require('fs');
                var filename = chooser.value;
                if (!filename) { return; }
                fs.readFile(filename, 'utf-8', function(err, data) {
                    if (err) {
                        console.log('error');
                    }
                    WaveDrom.cm.setValue(data);
                });
            }, false);

            chooser.click();
        }

        if (typeof process === 'object') { // nodewebkit detection
            chooseFile('#fileDialogLoad');
        }
    }

    function saveJSON () {
        var a;

        function sjson () {
            return localStorage.waveform;
        }

        function chooseFile(name) {
            var chooser = document.querySelector(name);

            chooser.addEventListener('change', function() {
                var fs = require('fs');
                var filename = this.value;
                if (!filename) { return; }
                fs.writeFile(filename, sjson(), function(err) {
                    if (err) {
                        console.log('error');
                    }
                });
                this.value = '';
            }, false);

            chooser.click();
        }

        if (typeof process === 'object') { // nodewebkit detection
            chooseFile('#fileDialogSave');
        } else {
            a = document.createElement('a');
            a.href = 'data:text/json;base64,' + btoa(sjson());
            a.download = 'wavedrom.json';
            var theEvent = document.createEvent('MouseEvent');
            theEvent.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            a.dispatchEvent(theEvent);
            a.click();
        }
    }

    function ssvg () {
        var svg, ser;

        svg = document.getElementById('svgcontent_0');
        ser = new XMLSerializer();
        return '<?xml version="1.0" standalone="no"?>\n'
            + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
            + '<!-- Created with WaveDrom -->\n'
            + ser.serializeToString(svg);
    }

    function saveSVG () {
        var a;

        function chooseFile(name) {
            var chooser = document.querySelector(name);

            chooser.addEventListener('change', function() {
                var fs = require('fs');
                var filename = this.value;
                if (!filename) { return; }
                fs.writeFile(filename, ssvg(), function(err) {
                    if(err) {
                        console.log('error');
                    }
                });
                this.value = '';
            }, false);
            chooser.click();
        }

        if (typeof process === 'object') { // nodewebkit detection
            chooseFile('#fileDialogSVG');
        } else {
            a = document.createElement('a');
            a.href = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(ssvg())));
            a.download = 'wavedrom.svg';
            var theEvent = document.createEvent('MouseEvent');
            theEvent.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            a.dispatchEvent(theEvent);
            // a.click();
        }
    }

    function pngdata (done) {

        var img = new Image();
        var canvas = document.createElement('canvas');

        function onload () {
            canvas.width = img.width;
            canvas.height = img.height;
            var context = canvas.getContext('2d');
            context.drawImage(img, 0, 0);
            var res = canvas.toDataURL('image/png');
            done(res);
        }

        var svgBody = ssvg();
        var svgdata = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgBody)));
        img.src = svgdata;

        if (img.complete) {
            onload();
        } else {
            img.onload = onload;
        }
    }

    function savePNG () {
        var a;

        function chooseFile(name) {
            var chooser = document.querySelector(name);

            chooser.addEventListener('change', function() {
                var fs = require('fs');
                var filename = this.value;
                if (!filename) { return; }
                pngdata(function (data) {
                    data = data.replace(/^data:image\/\w+;base64,/, '');
                    var buf = new Buffer(data, 'base64');
                    fs.writeFile(filename, buf, function(err) {
                        if (err) {
                            console.log('error');
                        }
                    });
                    this.value = '';
                });
            }, false);
            chooser.click();
        }

        if (typeof process === 'object') { // nodewebkit detection
            chooseFile('#fileDialogPNG');
        } else {
            a = document.createElement('a');
            pngdata(function (res) {
                a.href = res;
                a.download = 'wavedrom.png';
                var theEvent = document.createEvent('MouseEvent');
                theEvent.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
                a.dispatchEvent(theEvent);
                // a.click();
            });
        }
    }

    WaveDrom.editorInit = editorInit;
    WaveDrom.menuOpen = menuOpen;
    WaveDrom.loadJSON = loadJSON;
    WaveDrom.saveJSON = saveJSON;
    WaveDrom.saveSVG = saveSVG;
    WaveDrom.savePNG = savePNG;
    WaveDrom.editorState = editorState;
    WaveDrom.setFullURL = setFullURL;
    WaveDrom.gotoWaveDromGuide = gotoWaveDromGuide;
    WaveDrom.gotoWaveDromHome = gotoWaveDromHome;

})();

/* eslint-env node, browser */
/* global WaveDrom */
/* eslint no-console: 1 */
