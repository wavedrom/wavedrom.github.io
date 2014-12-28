(function () {
    'use strict';

    var inp, cm;

    inp = document.getElementById('input');

    cm = CodeMirror.fromTextArea(
        inp,
        {
            mode: 'forth',
            theme: 'colorforth',
            lineNumbers: true,
            indentUnit: 2,
            tabSize: 2,
            matchBrackets: true,
            autoCloseBrackets: true,
            highlightSelectionMatche: true,
            autofocus: true
        }
    );
})();

/* global console, CodeMirror */
