(function () {
    'use strict';

    var inp, cm;

    inp = document.getElementById('input');
    inp.value = localStorage.SourceCode || ': nip swap drop ;';

    function refresh () {
        localStorage.SourceCode = cm.getValue();
    }

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
    cm.on('change', function () {
        setTimeout(refresh, 750);
    });
    refresh();
})();

/* global console, CodeMirror */
