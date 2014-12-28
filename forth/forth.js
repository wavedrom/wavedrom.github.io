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
 HERE \\\, \\\@ \\\! CELL\\\+ CELLS C\\\, C\\\@ C\\\! CHARS 2\\\@ 2\\\! ALIGN ALIGNED \\\+\\\! ALLOT\
 CHAR \\\[CHAR\\\] \\\[ \\\] BL\
 FIND EXECUTE IMMEDIATE COUNT LITERAL STATE\
 \\\; DOES> >BODY\
 EVALUATE\
 SOURCE \\\>IN WORD\
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
 \\\:NONAME\
 COMPILE, \\\[COMPILE\\\]'.split(' '));

    var immediateWords = wordRegexp(
'IF ELSE THEN BEGIN WHILE REPEAT UNTIL RECURSE\
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
        return {
            startState: function() {
                return {
                    state: ''
                };
            },
            token: function tokenBase(stream, stt) {
                if (stream.eatSpace()) {
                    return null;
                }
                if (stt.state === '') { // interpretation
                    if (stream.match(/^(\:)\s+\S+(\s|$)+/)) {
                        stt.state = ' compilation';
                        return 'def' + stt.state;
                    }
                    if (stream.match(/^(\'|\[\'\]|VARIABLE|CONSTANT|CREATE|POSTPONE|VALUE)\s+\S+(\s|$)+/)) {
                        return 'def' + stt.state;
                    }
                } else { // compilation
                    if (stream.match(/^(\;)(\s|$)+/)) {
                        stt.state = '';
                        return 'builtin compilation';
                    }
                }
                if (stream.match(/^\\(\s|$)+/)) {
                    stream.skipToEnd();
                    return 'comment' + stt.state;
                }
                if (stream.match(/^\((\s|$)+([^\)])*\)/)) {
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
                if (stream.match(/^\S*/)) {
                    return 'variable' + stt.state;
                }
                return 'error' + stt.state;
            }
        };
    });
})();
