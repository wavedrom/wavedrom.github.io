'use strict';

(function(){

    var e, val;

    function ssvg () {
        var svg, ser;

        svg = document.getElementById('svgcontent_0');
        ser = new XMLSerializer();
        return '<?xml version="1.0" standalone="no"?>\n'
            + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n'
            + '<!-- Created with WaveDrom -->\n'
            + ser.serializeToString(svg);
    }

    function pngdata () {
        var svgdata, img, canvas, context;

        svgdata = 'data:image/svg+xml;base64,' + btoa(ssvg());
        img = new Image();
        img.src = svgdata;
        canvas = document.createElement('canvas');
        canvas.width = img.width;
        canvas.height = img.height;
        context = canvas.getContext('2d');
        context.drawImage(img, 0, 0);
        return canvas.toDataURL('image/png');
    }

    // die if Enternet Explorer
    function killBill () {
        if (navigator.appName.indexOf('Explorer') >= 0) {
            var content;

            content = document.getElementById('content');
            content.parentNode.removeChild(e);
            document.write('<h1>Sorry, Internet Explorer is not supported.</h1>');
            document.body.style.backgroundColor = '#ffdddd';
            window.stop();
        }
    }

    function nodeWebkit () {
        // node-webkit detection
        val = localStorage.waveform;
        if (val === undefined || val === '' || val === null) {
            val = '{signal: [\n  {name: \'clk\', wave: \'p.....|...\'},\n  {name: \'dat\', wave: \'x.345x|=.x\', data: [\'head\', \'body\', \'tail\', \'data\']},\n  {name: \'req\', wave: \'0.1..0|1.0\'},\n  {},\n  {name: \'ack\', wave: \'1.....|01.\'}\n]}\n';
            localStorage.waveform = val;
        }

        if (typeof process !== 'object') {
            return;
        }

        var gui = require('nw.gui'),
            fs = require('fs'),
            path = require('path');

        var args = gui.App.argv,
            data,
            rawdata;

        if (args[0] && args[0] === 'source' && args[1]) {
            val = fs.readFileSync(
                path.resolve(process.env.PWD, args[1]),
                {encoding: 'utf8'}
            );
            localStorage.waveform = val;
        } else {
            return;
        }

        if (args[2] && args[3]) {
            e.value = val;
            WaveDrom.EditorRefresh();

            if (args[2] === 'svg') {
                data = ssvg();
            }
            if (args[2] === 'png') {
                rawdata = pngdata().replace(/^data:image\/\w+;base64,/, '');
                data = new Buffer(rawdata, 'base64');
            }

            fs.writeFileSync(
                path.resolve(process.env.PWD, args[3]),
                data,
                {encoding: 'utf8'}
            );
            gui.App.quit();
        }
    }

    killBill();

    e = document.getElementById('InputJSON_0');

    nodeWebkit();

    e.value = val;

    var cm = CodeMirror.fromTextArea(
        e,
        {
            lineNumbers: true,
            mode: {
                name: 'javascript',
                json: true
            },
            matchBrackets: true,
            autoCloseBrackets: true,
            highlightSelectionMatche: true,
            autofocus: true
        }
    );
    cm.on('change', function (cmm) {
        function c () {
            var v = cmm.getValue();
            e.value = v;
            localStorage.waveform = v;

            var scroller = document.getElementById('SVGScroll');
            var state = {
                left: scroller.scrollLeft,
                top: scroller.scrollTop
            };
            WaveDrom.EditorRefresh();
            scroller.scrollTop = state.top;
            scroller.scrollLeft = state.left;
        }
        setTimeout(c, 750);
    });

    WaveDrom.cm = cm;

})();

/* eslint-env browser */
/* global CodeMirror, WaveDrom */
