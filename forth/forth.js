(function () {
    'use strict';

//     function wordRegexp(words) {
//         return new RegExp('^((' + words.join(')|(') + '))(\\s+\|\$)', 'i');
//     }
//
//     var words = wordRegexp(
// 'INVERT AND OR XOR\
//  2\\\* 2\\\/ LSHIFT RSHIFT\
//  0\\\= \\\= 0\\\< \\\< \\\> U\\\< MIN MAX\
//  2DROP 2DUP 2OVER 2SWAP \\\?DUP DEPTH DROP DUP OVER ROT SWAP\
//  \\\>R R\\\> R\\\@\
//  \\\+ \\\- 1\\\+ 1\\\- ABS NEGATE\
//  S\\\>D \\\* M\\\* UM\\\*\
//  FM\\\/MOD SM\\\/REM UM\\\/MOD \\\*\\\/ \\\*\\\/MOD \\\/ \\\/MOD MOD\
//  HERE \\\, \\\@ \\\! CELL\\\+ CELLS C\\\, C\\\@ C\\\! CHARS 2\\\@ 2\\\! ALIGN ALIGNED \\\+\\\! ALLOT\
//  CHAR \\\[CHAR\\\] \\\[ \\\] BL\
//  FIND EXECUTE IMMEDIATE COUNT LITERAL STATE\
//  \\\; DOES> >BODY\
//  EVALUATE\
//  SOURCE \\\>IN WORD\
//  \\\<\\\# \\\# \\\#S \\\#\\\> HOLD SIGN BASE \\\>NUMBER HEX DECIMAL\
//  FILL MOVE\
//  \\\. CR EMIT SPACE SPACES TYPE U\\\. \\\.R U\\\.R\
//  ACCEPT\
//  TRUE FALSE\
//  \\\<\\\> U\\\> 0\\\<\\\> 0\\\>\
//  NIP TUCK ROLL PICK\
//  2\\\>R 2R\\\@ 2R\\\>\
//  WITHIN UNUSED MARKER\
//  I J\
//  TO\
//  \\\:NONAME\
//  COMPILE, \\\[COMPILE\\\]'.split(' '));
//
//     var immediateWords = wordRegexp(
// 'IF ELSE THEN BEGIN WHILE REPEAT UNTIL RECURSE\
//  \\\?DO DO LOOP \\\+LOOP UNLOOP LEAVE EXIT AGAIN CASE OF ENDOF ENDCASE'.split(' ')
//     );
//
    CodeMirror.defineMode('forth', function() {

        var state = '';

        function tokenBase(stream) {
            if (stream.eatSpace()) {
                return null;
            }

            if (state === '') { // interpretation
                if (stream.match(/^(\:)\s+\S+(\s|$)+/)) {
                    state = ' compilation';
                    return 'def' + state;
                }
            } else { // compilation
                if (stream.match(/^(\;)\s+/)) {
                    state = '';
                    return 'builtin compilation';
                }
            }
            // if (stream.match(words)) {
            //     return 'builtin' + state;
            // }
            // if (stream.match(immediateWords)) {
            //     return 'keyword' + state;
            // }
            // if (stream.match(words)) {
            //     return 'builtin' + state;
            // }
            // if (stream.match(/^(\'|\[\'\]|VARIABLE|CONSTANT|CREATE|POSTPONE|VALUE)\s+\S+(\s|$)+/)) {
            //     return 'def' + state;
            // }
            //
            // if (stream.match(/^\\\s+/)) {
            //     stream.skipToEnd();
            //     return 'comment' + state;
            // }
            // if (stream.match(/^TESTING\s+/)) {
            //     stream.skipToEnd();
            //     return 'comment' + state;
            // }
            // if (stream.match(/^\((\s|$)+([^\)])*\)/)) {
            //     return 'comment' + state;
            // }
            // if (stream.match(/^[-+]?[0-9]+\s+/)) {
            //     return 'number' + state;
            // }
            //
            // if (stream.match(/^(\:|\'|\[\'\]|VARIABLE|CONSTANT|CREATE|POSTPONE|VALUE)\s+\S+(\s|$)+/)) {
            //     return 'def' + state;
            // }
            //
            // if (stream.match(/^.\(\s+([^\)])*\)/)) {
            //     return 'string' + state;
            // }
            // if (stream.match(/^S\"\s+([^\"])*\"/)) {
            //     return 'string' + state;
            // }
            // if (stream.match(/^\.\"\s+([^\"])*\"/)) {
            //     return 'string' + state;
            // }
            //
            if (stream.match(/^\S*/)) {
                return 'variable' + state;
            }
            return 'error' + state;
        }

        return {
            token: function(stream) {
                return tokenBase(stream);
            }
        };
    });
})();
