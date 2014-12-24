(function () {
    'use strict';

    var inp, out, cm, tree, parse;

    parse = require('shift-parser').default;

    inp = document.getElementById('input');
    out = document.getElementById('output');
    inp.value = localStorage.shiftAST || 'function add (a, b) {\n  [x, y] = [a, b];\n}';

    function refresh () {
        var v;
        v = cm.getValue();
        tree = parse(v);
        localStorage.shiftAST = v;
        out.innerHTML = JSON.stringify(tree, null, 2);
    }

    cm = CodeMirror.fromTextArea(
        inp,
        {
            mode: 'javascript',
            lineNumbers: true,
            indentUnit: 2,
            tabSize: 2,
            matchBrackets: true,
            autoCloseBrackets: true,
            highlightSelectionMatche: true,
            autofocus: true
        }
    );
    cm.on('change', function () {
        setTimeout(refresh, 750);
    });
    refresh();
})();

/* global console, CodeMirror */
