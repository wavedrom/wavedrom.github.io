(function () {
    'use strict';

    function wordRegexp(words) {
        return new RegExp('^((' + words.join(')|(') + '))(\\s+\|\$)', 'i');
    }

    var words = wordRegexp(
'INVERT AND OR XOR\
 2\\\* 2\\\/ LSHIFT RSHIFT\
 0\\\= \\\= 0\\\< \\\< \\\> U\\\< MIN MAX\
 2DROP 2DUP 2OVER 2SWAP \\\?DUP DEPTH DROP DUP OVER ROT SWAP\
 \\\>R R\\\> R\\\@\
 \\\+ \\\- 1\\\+ 1\\\- ABS NEGATE\
 S\\\>D \\\* M\\\* UM\\\*\
 FM\\\/MOD SM\\\/REM UM\\\/MOD \\\*\\\/ \\\*\\\/MOD \\\/ \\\/MOD MOD\
 HERE \\\, \\\@ \\\! CELL\\\+ CELLS C\\\, C\\\@ C\\\! CHARS 2\\\@ 2\\\!\
 ALIGN ALIGNED \\\+\\\! ALLOT\
 CHAR \\\[CHAR\\\] \\\[ \\\] BL\
 FIND EXECUTE IMMEDIATE COUNT LITERAL STATE\
 \\\; DOES> >BODY\
 EVALUATE\
 SOURCE \\\>IN\
 \\\<\\\# \\\# \\\#S \\\#\\\> HOLD SIGN BASE \\\>NUMBER HEX DECIMAL\
 FILL MOVE\
 \\\. CR EMIT SPACE SPACES TYPE U\\\. \\\.R U\\\.R\
 ACCEPT\
 TRUE FALSE\
 \\\<\\\> U\\\> 0\\\<\\\> 0\\\>\
 NIP TUCK ROLL PICK\
 2\\\>R 2R\\\@ 2R\\\>\
 WITHIN UNUSED MARKER\
 I J\
 TO\
 COMPILE, \\\[COMPILE\\\]\
 SAVE\\\-INPUT RESTORE\\\-INPUT\
 PAD ERASE\
 2LITERAL DNEGATE\
 D\\\- D\\\+ D0\\\< D0\\\= D2\\\* D2\\\/ D\\\< D\\\= DMAX DMIN D\\\>S DABS\
 M\\\+ M\\\*\\\/ D\\\. D\\\.R 2ROT DU\\\<\
 CATCH THROW\
 FREE RESIZE ALLOCATE\
 CS\\\-PICK CS\\\-ROLL\
 GET\\\-CURRENT SET\\\-CURRENT FORTH\\\-WORDLIST GET\\\-ORDER SET\\\-ORDER\
 PREVIOUS SEARCH\\\-WORDLIST WORDLIST FIND ALSO ONLY FORTH DEFINITIONS ORDER\
 \\\-TRAILING \\\/STRING SEARCH COMPARE CMOVE CMOVE\\\> BLANK SLITERAL'.split(' '));

    var immediateWords = wordRegexp(
'IF ELSE THEN BEGIN WHILE REPEAT UNTIL RECURSE\
 \\\[IF\\\] \\\[ELSE\\\] \\\[THEN\\\]\
 \\\?DO DO LOOP \\\+LOOP UNLOOP LEAVE EXIT AGAIN CASE OF ENDOF ENDCASE'.split(' ')
    );


//
//
// if (stream.match(/^(\:|\'|\[\'\]|VARIABLE|CONSTANT|CREATE|POSTPONE|VALUE)\s+\S+(\s|$)+/)) {
//     return 'def' + state;
// }
//
//

    CodeMirror.defineMode('forth', function() {
        function searchWordList (wordList, word) {
            var i;
            for (i = wordList.length - 1; i >= 0; i--) {
                if (wordList[i].name === word.toUpperCase()) {
                    return wordList[i];
                }
            }
            return undefined;
        }
        return {
            startState: function() {
                return {
                    state: '',
                    base: 10,
                    wordList: [
                        { name: 'HEX' },
                        { name: 'DECIMAL' }
                    ]
                };
            },
            token: function (stream, stt) {
                var mat;
                if (stream.eatSpace()) {
                    return null;
                }
                if (stt.state === '') { // interpretation
                    if (stream.match(/^(\]|:NONAME)(\s|$)/i)) {
                        stt.state = ' compilation';
                        return 'builtin compilation';
                    }
                    mat = stream.match(/^(\:)\s+(\S+)(\s|$)+/);
                    if (mat) {
                        stt.wordList.push({name: mat[2].toUpperCase()});
                        stt.state = ' compilation';
                        return 'def' + stt.state;
                    }
                    mat = stream.match(/^(\'|\[\'\]|VARIABLE|2VARIABLE|CONSTANT|2CONSTANT|CREATE|POSTPONE|VALUE|WORD)\s+(\S+)(\s|$)+/)
                    if (mat) {
                        stt.wordList.push({name: mat[2].toUpperCase()});
                        return 'def' + stt.state;
                    }
                } else { // compilation
                    // ; [
                    if (stream.match(/^(\;|\[)(\s)/)) {
                        stt.state = '';
                        stream.backUp(1);
                        return 'builtin compilation';
                    }
                    if (stream.match(/^(\;|\[)($)/)) {
                        stt.state = '';
                        return 'builtin compilation';
                    }
                    if (stream.match(/^(POSTPONE)\s+\S+(\s|$)+/)) {
                        return 'builtin';
                    }
                }
                if (stream.match(/^(\\|TESTING)(\s|$)+/)) {
                    stream.skipToEnd();
                    return 'comment' + stt.state;
                }
                if (stream.match(/^\([^\)]*\)/)) {
                    return 'comment' + stt.state;
                }
                if (stream.match(/^.\((\s|$)+([^\)])*\)/)) {
                    return 'string' + stt.state;
                }
                if (stream.match(/^S\"(\s|$)+([^\"])*\"/)) {
                    return 'string' + stt.state;
                }
                if (stream.match(/^\.\"(\s|$)+([^\"])*\"/)) {
                    return 'string' + stt.state;
                }
                if (stream.match(words)) {
                    return 'builtin' + stt.state;
                }
                if (stream.match(immediateWords)) {
                    return 'keyword' + stt.state;
                }
                if (stream.match(/^[-+]?[0-9]+(\s|$)+/)) {
                    return 'number' + stt.state;
                }
                if (stream.match(/^[-+]?[0-9]+\.[0-9]*(\s|$)+/)) {
                    return 'number' + stt.state;
                }
                mat = stream.match(/^(\S+)(\s|$)+/);
                if (mat) {
                    if (searchWordList(stt.wordList, mat[1]) === undefined) {
                        return 'atom' + stt.state;
                    }
                    return 'variable' + stt.state;
                }
                return 'error' + stt.state;
            }
        };
    });
})();
