(function(){
    'use strict';

    var e, val;

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
            WaveDrom.EditorRefresh();
        }
        setTimeout(c, 750);
    });

WaveDrom.cm = cm;

})();

/* eslint-env browser */
/* global CodeMirror, WaveDrom, ssvg, pngdata */
/* eslint new-cap:0, no-underscore-dangle:1 */
