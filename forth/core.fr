\ From: John Hayes S1I
\ Subject: core.fr
\ Date: Mon, 27 Nov 95 13:10

\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.2
\ THIS PROGRAM TESTS THE CORE WORDS OF AN ANS FORTH SYSTEM.
\ THE PROGRAM ASSUMES A TWO'S COMPLEMENT IMPLEMENTATION WHERE
\ THE RANGE OF SIGNED NUMBERS IS -2^(N-1) ... 2^(N-1)-1 AND
\ THE RANGE OF UNSIGNED NUMBERS IS 0 ... 2^(N)-1.
\ I HAVEN'T FIGURED OUT HOW TO TEST KEY, QUIT, ABORT, OR ABORT"...
\ I ALSO HAVEN'T THOUGHT OF A WAY TO TEST ENVIRONMENT?...

CR
TESTING CORE WORDS
HEX

\ ------------------------------------------------------------------------
TESTING BASIC ASSUMPTIONS

T{ -> }T					\ START WITH CLEAN SLATE
( TEST IF ANY BITS ARE SET; ANSWER IN BASE 1 )
T{ : BITSSET? IF 0 0 ELSE 0 THEN ; -> }T
T{  0 BITSSET? -> 0 }T		( ZERO IS ALL BITS CLEAR )
T{  1 BITSSET? -> 0 0 }T		( OTHER NUMBER HAVE AT LEAST ONE BIT )
T{ -1 BITSSET? -> 0 0 }T

\ ------------------------------------------------------------------------
TESTING BOOLEANS: INVERT AND OR XOR

T{ 0 0 AND -> 0 }T
T{ 0 1 AND -> 0 }T
T{ 1 0 AND -> 0 }T
T{ 1 1 AND -> 1 }T

T{ 0 INVERT 1 AND -> 1 }T
T{ 1 INVERT 1 AND -> 0 }T

0	 CONSTANT 0S
0 INVERT CONSTANT 1S

T{ 0S INVERT -> 1S }T
T{ 1S INVERT -> 0S }T

T{ 0S 0S AND -> 0S }T
T{ 0S 1S AND -> 0S }T
T{ 1S 0S AND -> 0S }T
T{ 1S 1S AND -> 1S }T

T{ 0S 0S OR -> 0S }T
T{ 0S 1S OR -> 1S }T
T{ 1S 0S OR -> 1S }T
T{ 1S 1S OR -> 1S }T

T{ 0S 0S XOR -> 0S }T
T{ 0S 1S XOR -> 1S }T
T{ 1S 0S XOR -> 1S }T
T{ 1S 1S XOR -> 0S }T

\ ------------------------------------------------------------------------
TESTING 2* 2/ LSHIFT RSHIFT

( WE TRUST 1S, INVERT, AND BITSSET?; WE WILL CONFIRM RSHIFT LATER )
1S 1 RSHIFT INVERT CONSTANT MSB
T{ MSB BITSSET? -> 0 0 }T

T{ 0S 2* -> 0S }T
T{ 1 2* -> 2 }T
T{ 4000 2* -> 8000 }T
T{ 1S 2* 1 XOR -> 1S }T
T{ MSB 2* -> 0S }T

T{ 0S 2/ -> 0S }T
T{ 1 2/ -> 0 }T
T{ 4000 2/ -> 2000 }T
T{ 1S 2/ -> 1S }T				\ MSB PROPOGATED
T{ 1S 1 XOR 2/ -> 1S }T
T{ MSB 2/ MSB AND -> MSB }T

T{ 1 0 LSHIFT -> 1 }T
T{ 1 1 LSHIFT -> 2 }T
T{ 1 2 LSHIFT -> 4 }T
T{ 1 F LSHIFT -> 8000 }T			\ BIGGEST GUARANTEED SHIFT
T{ 1S 1 LSHIFT 1 XOR -> 1S }T
T{ MSB 1 LSHIFT -> 0 }T

T{ 1 0 RSHIFT -> 1 }T
T{ 1 1 RSHIFT -> 0 }T
T{ 2 1 RSHIFT -> 1 }T
T{ 4 2 RSHIFT -> 1 }T
T{ 8000 F RSHIFT -> 1 }T			\ BIGGEST
T{ MSB 1 RSHIFT MSB AND -> 0 }T		\ RSHIFT ZERO FILLS MSBS
T{ MSB 1 RSHIFT 2* -> MSB }T

\ ------------------------------------------------------------------------
TESTING COMPARISONS: 0= = 0< < > U< MIN MAX
0 INVERT			CONSTANT MAX-UINT
0 INVERT 1 RSHIFT		CONSTANT MAX-INT
0 INVERT 1 RSHIFT INVERT	CONSTANT MIN-INT
0 INVERT 1 RSHIFT		CONSTANT MID-UINT
0 INVERT 1 RSHIFT INVERT	CONSTANT MID-UINT+1

0S CONSTANT <FALSE>
1S CONSTANT <TRUE>

T{ 0 0= -> <TRUE> }T
T{ 1 0= -> <FALSE> }T
T{ 2 0= -> <FALSE> }T
T{ -1 0= -> <FALSE> }T
T{ MAX-UINT 0= -> <FALSE> }T
T{ MIN-INT 0= -> <FALSE> }T
T{ MAX-INT 0= -> <FALSE> }T

T{ 0 0 = -> <TRUE> }T
T{ 1 1 = -> <TRUE> }T
T{ -1 -1 = -> <TRUE> }T
T{ 1 0 = -> <FALSE> }T
T{ -1 0 = -> <FALSE> }T
T{ 0 1 = -> <FALSE> }T
T{ 0 -1 = -> <FALSE> }T

T{ 0 0< -> <FALSE> }T
T{ -1 0< -> <TRUE> }T
T{ MIN-INT 0< -> <TRUE> }T
T{ 1 0< -> <FALSE> }T
T{ MAX-INT 0< -> <FALSE> }T

T{ 0 1 < -> <TRUE> }T
T{ 1 2 < -> <TRUE> }T
T{ -1 0 < -> <TRUE> }T
T{ -1 1 < -> <TRUE> }T
T{ MIN-INT 0 < -> <TRUE> }T
T{ MIN-INT MAX-INT < -> <TRUE> }T
T{ 0 MAX-INT < -> <TRUE> }T
T{ 0 0 < -> <FALSE> }T
T{ 1 1 < -> <FALSE> }T
T{ 1 0 < -> <FALSE> }T
T{ 2 1 < -> <FALSE> }T
T{ 0 -1 < -> <FALSE> }T
T{ 1 -1 < -> <FALSE> }T
T{ 0 MIN-INT < -> <FALSE> }T
T{ MAX-INT MIN-INT < -> <FALSE> }T
T{ MAX-INT 0 < -> <FALSE> }T

T{ 0 1 > -> <FALSE> }T
T{ 1 2 > -> <FALSE> }T
T{ -1 0 > -> <FALSE> }T
T{ -1 1 > -> <FALSE> }T
T{ MIN-INT 0 > -> <FALSE> }T
T{ MIN-INT MAX-INT > -> <FALSE> }T
T{ 0 MAX-INT > -> <FALSE> }T
T{ 0 0 > -> <FALSE> }T
T{ 1 1 > -> <FALSE> }T
T{ 1 0 > -> <TRUE> }T
T{ 2 1 > -> <TRUE> }T
T{ 0 -1 > -> <TRUE> }T
T{ 1 -1 > -> <TRUE> }T
T{ 0 MIN-INT > -> <TRUE> }T
T{ MAX-INT MIN-INT > -> <TRUE> }T
T{ MAX-INT 0 > -> <TRUE> }T

T{ 0 1 U< -> <TRUE> }T
T{ 1 2 U< -> <TRUE> }T
T{ 0 MID-UINT U< -> <TRUE> }T
T{ 0 MAX-UINT U< -> <TRUE> }T
T{ MID-UINT MAX-UINT U< -> <TRUE> }T
T{ 0 0 U< -> <FALSE> }T
T{ 1 1 U< -> <FALSE> }T
T{ 1 0 U< -> <FALSE> }T
T{ 2 1 U< -> <FALSE> }T
T{ MID-UINT 0 U< -> <FALSE> }T
T{ MAX-UINT 0 U< -> <FALSE> }T
T{ MAX-UINT MID-UINT U< -> <FALSE> }T

T{ 0 1 MIN -> 0 }T
T{ 1 2 MIN -> 1 }T
T{ -1 0 MIN -> -1 }T
T{ -1 1 MIN -> -1 }T
T{ MIN-INT 0 MIN -> MIN-INT }T
T{ MIN-INT MAX-INT MIN -> MIN-INT }T
T{ 0 MAX-INT MIN -> 0 }T
T{ 0 0 MIN -> 0 }T
T{ 1 1 MIN -> 1 }T
T{ 1 0 MIN -> 0 }T
T{ 2 1 MIN -> 1 }T
T{ 0 -1 MIN -> -1 }T
T{ 1 -1 MIN -> -1 }T
T{ 0 MIN-INT MIN -> MIN-INT }T
T{ MAX-INT MIN-INT MIN -> MIN-INT }T
T{ MAX-INT 0 MIN -> 0 }T

T{ 0 1 MAX -> 1 }T
T{ 1 2 MAX -> 2 }T
T{ -1 0 MAX -> 0 }T
T{ -1 1 MAX -> 1 }T
T{ MIN-INT 0 MAX -> 0 }T
T{ MIN-INT MAX-INT MAX -> MAX-INT }T
T{ 0 MAX-INT MAX -> MAX-INT }T
T{ 0 0 MAX -> 0 }T
T{ 1 1 MAX -> 1 }T
T{ 1 0 MAX -> 1 }T
T{ 2 1 MAX -> 2 }T
T{ 0 -1 MAX -> 0 }T
T{ 1 -1 MAX -> 1 }T
T{ 0 MIN-INT MAX -> 0 }T
T{ MAX-INT MIN-INT MAX -> MAX-INT }T
T{ MAX-INT 0 MAX -> MAX-INT }T

\ ------------------------------------------------------------------------
TESTING STACK OPS: 2DROP 2DUP 2OVER 2SWAP ?DUP DEPTH DROP DUP OVER ROT SWAP

T{ 1 2 2DROP -> }T
T{ 1 2 2DUP -> 1 2 1 2 }T
T{ 1 2 3 4 2OVER -> 1 2 3 4 1 2 }T
T{ 1 2 3 4 2SWAP -> 3 4 1 2 }T
T{ 0 ?DUP -> 0 }T
T{ 1 ?DUP -> 1 1 }T
T{ -1 ?DUP -> -1 -1 }T
T{ DEPTH -> 0 }T
T{ 0 DEPTH -> 0 1 }T
T{ 0 1 DEPTH -> 0 1 2 }T
T{ 0 DROP -> }T
T{ 1 2 DROP -> 1 }T
T{ 1 DUP -> 1 1 }T
T{ 1 2 OVER -> 1 2 1 }T
T{ 1 2 3 ROT -> 2 3 1 }T
T{ 1 2 SWAP -> 2 1 }T

\ ------------------------------------------------------------------------
TESTING >R R> R@

T{ : GR1 >R R> ; -> }T
T{ : GR2 >R R@ R> DROP ; -> }T
T{ 123 GR1 -> 123 }T
T{ 123 GR2 -> 123 }T
T{ 1S GR1 -> 1S }T   ( RETURN STACK HOLDS CELLS )

\ ------------------------------------------------------------------------
TESTING ADD/SUBTRACT: + - 1+ 1- ABS NEGATE

T{ 0 5 + -> 5 }T
T{ 5 0 + -> 5 }T
T{ 0 -5 + -> -5 }T
T{ -5 0 + -> -5 }T
T{ 1 2 + -> 3 }T
T{ 1 -2 + -> -1 }T
T{ -1 2 + -> 1 }T
T{ -1 -2 + -> -3 }T
T{ -1 1 + -> 0 }T
T{ MID-UINT 1 + -> MID-UINT+1 }T

T{ 0 5 - -> -5 }T
T{ 5 0 - -> 5 }T
T{ 0 -5 - -> 5 }T
T{ -5 0 - -> -5 }T
T{ 1 2 - -> -1 }T
T{ 1 -2 - -> 3 }T
T{ -1 2 - -> -3 }T
T{ -1 -2 - -> 1 }T
T{ 0 1 - -> -1 }T
T{ MID-UINT+1 1 - -> MID-UINT }T

T{ 0 1+ -> 1 }T
T{ -1 1+ -> 0 }T
T{ 1 1+ -> 2 }T
T{ MID-UINT 1+ -> MID-UINT+1 }T

T{ 2 1- -> 1 }T
T{ 1 1- -> 0 }T
T{ 0 1- -> -1 }T
T{ MID-UINT+1 1- -> MID-UINT }T

T{ 0 NEGATE -> 0 }T
T{ 1 NEGATE -> -1 }T
T{ -1 NEGATE -> 1 }T
T{ 2 NEGATE -> -2 }T
T{ -2 NEGATE -> 2 }T

T{ 0 ABS -> 0 }T
T{ 1 ABS -> 1 }T
T{ -1 ABS -> 1 }T
T{ MIN-INT ABS -> MID-UINT+1 }T

\ ------------------------------------------------------------------------
TESTING MULTIPLY: S>D * M* UM*

T{ 0 S>D -> 0 0 }T
T{ 1 S>D -> 1 0 }T
T{ 2 S>D -> 2 0 }T
T{ -1 S>D -> -1 -1 }T
T{ -2 S>D -> -2 -1 }T
T{ MIN-INT S>D -> MIN-INT -1 }T
T{ MAX-INT S>D -> MAX-INT 0 }T

T{ 0 0 M* -> 0 S>D }T
T{ 0 1 M* -> 0 S>D }T
T{ 1 0 M* -> 0 S>D }T
T{ 1 2 M* -> 2 S>D }T
T{ 2 1 M* -> 2 S>D }T
T{ 3 3 M* -> 9 S>D }T
T{ -3 3 M* -> -9 S>D }T
T{ 3 -3 M* -> -9 S>D }T
T{ -3 -3 M* -> 9 S>D }T
T{ 0 MIN-INT M* -> 0 S>D }T
T{ 1 MIN-INT M* -> MIN-INT S>D }T
T{ 2 MIN-INT M* -> 0 1S }T
T{ 0 MAX-INT M* -> 0 S>D }T
T{ 1 MAX-INT M* -> MAX-INT S>D }T
T{ 2 MAX-INT M* -> MAX-INT 1 LSHIFT 0 }T
T{ MIN-INT MIN-INT M* -> 0 MSB 1 RSHIFT }T
T{ MAX-INT MIN-INT M* -> MSB MSB 2/ }T
T{ MAX-INT MAX-INT M* -> 1 MSB 2/ INVERT }T

T{ 0 0 * -> 0 }T				\ TEST IDENTITIES
T{ 0 1 * -> 0 }T
T{ 1 0 * -> 0 }T
T{ 1 2 * -> 2 }T
T{ 2 1 * -> 2 }T
T{ 3 3 * -> 9 }T
T{ -3 3 * -> -9 }T
T{ 3 -3 * -> -9 }T
T{ -3 -3 * -> 9 }T

T{ MID-UINT+1 1 RSHIFT 2 * -> MID-UINT+1 }T
T{ MID-UINT+1 2 RSHIFT 4 * -> MID-UINT+1 }T
T{ MID-UINT+1 1 RSHIFT MID-UINT+1 OR 2 * -> MID-UINT+1 }T

T{ 0 0 UM* -> 0 0 }T
T{ 0 1 UM* -> 0 0 }T
T{ 1 0 UM* -> 0 0 }T
T{ 1 2 UM* -> 2 0 }T
T{ 2 1 UM* -> 2 0 }T
T{ 3 3 UM* -> 9 0 }T

T{ MID-UINT+1 1 RSHIFT 2 UM* -> MID-UINT+1 0 }T
T{ MID-UINT+1 2 UM* -> 0 1 }T
T{ MID-UINT+1 4 UM* -> 0 2 }T
T{ 1S 2 UM* -> 1S 1 LSHIFT 1 }T
T{ MAX-UINT MAX-UINT UM* -> 1 1 INVERT }T

\ ------------------------------------------------------------------------
TESTING DIVIDE: FM/MOD SM/REM UM/MOD */ */MOD / /MOD MOD

T{ 0 S>D 1 FM/MOD -> 0 0 }T
T{ 1 S>D 1 FM/MOD -> 0 1 }T
T{ 2 S>D 1 FM/MOD -> 0 2 }T
T{ -1 S>D 1 FM/MOD -> 0 -1 }T
T{ -2 S>D 1 FM/MOD -> 0 -2 }T
T{ 0 S>D -1 FM/MOD -> 0 0 }T
T{ 1 S>D -1 FM/MOD -> 0 -1 }T
T{ 2 S>D -1 FM/MOD -> 0 -2 }T
T{ -1 S>D -1 FM/MOD -> 0 1 }T
T{ -2 S>D -1 FM/MOD -> 0 2 }T
T{ 2 S>D 2 FM/MOD -> 0 1 }T
T{ -1 S>D -1 FM/MOD -> 0 1 }T
T{ -2 S>D -2 FM/MOD -> 0 1 }T
T{  7 S>D  3 FM/MOD -> 1 2 }T
T{  7 S>D -3 FM/MOD -> -2 -3 }T
T{ -7 S>D  3 FM/MOD -> 2 -3 }T
T{ -7 S>D -3 FM/MOD -> -1 2 }T
T{ MAX-INT S>D 1 FM/MOD -> 0 MAX-INT }T
T{ MIN-INT S>D 1 FM/MOD -> 0 MIN-INT }T
T{ MAX-INT S>D MAX-INT FM/MOD -> 0 1 }T
T{ MIN-INT S>D MIN-INT FM/MOD -> 0 1 }T
T{ 1S 1 4 FM/MOD -> 3 MAX-INT }T
T{ 1 MIN-INT M* 1 FM/MOD -> 0 MIN-INT }T
T{ 1 MIN-INT M* MIN-INT FM/MOD -> 0 1 }T
T{ 2 MIN-INT M* 2 FM/MOD -> 0 MIN-INT }T
T{ 2 MIN-INT M* MIN-INT FM/MOD -> 0 2 }T
T{ 1 MAX-INT M* 1 FM/MOD -> 0 MAX-INT }T
T{ 1 MAX-INT M* MAX-INT FM/MOD -> 0 1 }T
T{ 2 MAX-INT M* 2 FM/MOD -> 0 MAX-INT }T
T{ 2 MAX-INT M* MAX-INT FM/MOD -> 0 2 }T
T{ MIN-INT MIN-INT M* MIN-INT FM/MOD -> 0 MIN-INT }T
T{ MIN-INT MAX-INT M* MIN-INT FM/MOD -> 0 MAX-INT }T
T{ MIN-INT MAX-INT M* MAX-INT FM/MOD -> 0 MIN-INT }T
T{ MAX-INT MAX-INT M* MAX-INT FM/MOD -> 0 MAX-INT }T

T{ 0 S>D 1 SM/REM -> 0 0 }T
T{ 1 S>D 1 SM/REM -> 0 1 }T
T{ 2 S>D 1 SM/REM -> 0 2 }T
T{ -1 S>D 1 SM/REM -> 0 -1 }T
T{ -2 S>D 1 SM/REM -> 0 -2 }T
T{ 0 S>D -1 SM/REM -> 0 0 }T
T{ 1 S>D -1 SM/REM -> 0 -1 }T
T{ 2 S>D -1 SM/REM -> 0 -2 }T
T{ -1 S>D -1 SM/REM -> 0 1 }T
T{ -2 S>D -1 SM/REM -> 0 2 }T
T{ 2 S>D 2 SM/REM -> 0 1 }T
T{ -1 S>D -1 SM/REM -> 0 1 }T
T{ -2 S>D -2 SM/REM -> 0 1 }T
T{  7 S>D  3 SM/REM -> 1 2 }T
T{  7 S>D -3 SM/REM -> 1 -2 }T
T{ -7 S>D  3 SM/REM -> -1 -2 }T
T{ -7 S>D -3 SM/REM -> -1 2 }T
T{ MAX-INT S>D 1 SM/REM -> 0 MAX-INT }T
T{ MIN-INT S>D 1 SM/REM -> 0 MIN-INT }T
T{ MAX-INT S>D MAX-INT SM/REM -> 0 1 }T
T{ MIN-INT S>D MIN-INT SM/REM -> 0 1 }T
T{ 1S 1 4 SM/REM -> 3 MAX-INT }T
T{ 2 MIN-INT M* 2 SM/REM -> 0 MIN-INT }T
T{ 2 MIN-INT M* MIN-INT SM/REM -> 0 2 }T
T{ 2 MAX-INT M* 2 SM/REM -> 0 MAX-INT }T
T{ 2 MAX-INT M* MAX-INT SM/REM -> 0 2 }T
T{ MIN-INT MIN-INT M* MIN-INT SM/REM -> 0 MIN-INT }T
T{ MIN-INT MAX-INT M* MIN-INT SM/REM -> 0 MAX-INT }T
T{ MIN-INT MAX-INT M* MAX-INT SM/REM -> 0 MIN-INT }T
T{ MAX-INT MAX-INT M* MAX-INT SM/REM -> 0 MAX-INT }T

T{ 0 0 1 UM/MOD -> 0 0 }T
T{ 1 0 1 UM/MOD -> 0 1 }T
T{ 1 0 2 UM/MOD -> 1 0 }T
T{ 3 0 2 UM/MOD -> 1 1 }T
T{ MAX-UINT 2 UM* 2 UM/MOD -> 0 MAX-UINT }T
T{ MAX-UINT 2 UM* MAX-UINT UM/MOD -> 0 2 }T
T{ MAX-UINT MAX-UINT UM* MAX-UINT UM/MOD -> 0 MAX-UINT }T

: IFFLOORED
   [ -3 2 / -2 = INVERT ] LITERAL IF POSTPONE \ THEN ;

: IFSYM
   [ -3 2 / -1 = INVERT ] LITERAL IF POSTPONE \ THEN ;

\ THE SYSTEM MIGHT DO EITHER FLOORED OR SYMMETRIC DIVISION.
\ SINCE WE HAVE ALREADY TESTED M*, FM/MOD, AND SM/REM WE CAN USE THEM IN TEST.

IFFLOORED : T/MOD  >R S>D R> FM/MOD ;
IFFLOORED : T/     T/MOD SWAP DROP ;
IFFLOORED : TMOD   T/MOD DROP ;
IFFLOORED : T*/MOD >R M* R> FM/MOD ;
IFFLOORED : T*/    T*/MOD SWAP DROP ;
IFSYM     : T/MOD  >R S>D R> SM/REM ;
IFSYM     : T/     T/MOD SWAP DROP ;
IFSYM     : TMOD   T/MOD DROP ;
IFSYM     : T*/MOD >R M* R> SM/REM ;
IFSYM     : T*/    T*/MOD SWAP DROP ;

T{ 0 1 /MOD -> 0 1 T/MOD }T
T{ 1 1 /MOD -> 1 1 T/MOD }T
T{ 2 1 /MOD -> 2 1 T/MOD }T
T{ -1 1 /MOD -> -1 1 T/MOD }T
T{ -2 1 /MOD -> -2 1 T/MOD }T
T{ 0 -1 /MOD -> 0 -1 T/MOD }T
T{ 1 -1 /MOD -> 1 -1 T/MOD }T
T{ 2 -1 /MOD -> 2 -1 T/MOD }T
T{ -1 -1 /MOD -> -1 -1 T/MOD }T
T{ -2 -1 /MOD -> -2 -1 T/MOD }T
T{ 2 2 /MOD -> 2 2 T/MOD }T
T{ -1 -1 /MOD -> -1 -1 T/MOD }T
T{ -2 -2 /MOD -> -2 -2 T/MOD }T
T{ 7 3 /MOD -> 7 3 T/MOD }T
T{ 7 -3 /MOD -> 7 -3 T/MOD }T
T{ -7 3 /MOD -> -7 3 T/MOD }T
T{ -7 -3 /MOD -> -7 -3 T/MOD }T
T{ MAX-INT 1 /MOD -> MAX-INT 1 T/MOD }T
T{ MIN-INT 1 /MOD -> MIN-INT 1 T/MOD }T
T{ MAX-INT MAX-INT /MOD -> MAX-INT MAX-INT T/MOD }T
T{ MIN-INT MIN-INT /MOD -> MIN-INT MIN-INT T/MOD }T

T{ 0 1 / -> 0 1 T/ }T
T{ 1 1 / -> 1 1 T/ }T
T{ 2 1 / -> 2 1 T/ }T
T{ -1 1 / -> -1 1 T/ }T
T{ -2 1 / -> -2 1 T/ }T
T{ 0 -1 / -> 0 -1 T/ }T
T{ 1 -1 / -> 1 -1 T/ }T
T{ 2 -1 / -> 2 -1 T/ }T
T{ -1 -1 / -> -1 -1 T/ }T
T{ -2 -1 / -> -2 -1 T/ }T
T{ 2 2 / -> 2 2 T/ }T
T{ -1 -1 / -> -1 -1 T/ }T
T{ -2 -2 / -> -2 -2 T/ }T
T{ 7 3 / -> 7 3 T/ }T
T{ 7 -3 / -> 7 -3 T/ }T
T{ -7 3 / -> -7 3 T/ }T
T{ -7 -3 / -> -7 -3 T/ }T
T{ MAX-INT 1 / -> MAX-INT 1 T/ }T
T{ MIN-INT 1 / -> MIN-INT 1 T/ }T
T{ MAX-INT MAX-INT / -> MAX-INT MAX-INT T/ }T
T{ MIN-INT MIN-INT / -> MIN-INT MIN-INT T/ }T

T{ 0 1 MOD -> 0 1 TMOD }T
T{ 1 1 MOD -> 1 1 TMOD }T
T{ 2 1 MOD -> 2 1 TMOD }T
T{ -1 1 MOD -> -1 1 TMOD }T
T{ -2 1 MOD -> -2 1 TMOD }T
T{ 0 -1 MOD -> 0 -1 TMOD }T
T{ 1 -1 MOD -> 1 -1 TMOD }T
T{ 2 -1 MOD -> 2 -1 TMOD }T
T{ -1 -1 MOD -> -1 -1 TMOD }T
T{ -2 -1 MOD -> -2 -1 TMOD }T
T{ 2 2 MOD -> 2 2 TMOD }T
T{ -1 -1 MOD -> -1 -1 TMOD }T
T{ -2 -2 MOD -> -2 -2 TMOD }T
T{ 7 3 MOD -> 7 3 TMOD }T
T{ 7 -3 MOD -> 7 -3 TMOD }T
T{ -7 3 MOD -> -7 3 TMOD }T
T{ -7 -3 MOD -> -7 -3 TMOD }T
T{ MAX-INT 1 MOD -> MAX-INT 1 TMOD }T
T{ MIN-INT 1 MOD -> MIN-INT 1 TMOD }T
T{ MAX-INT MAX-INT MOD -> MAX-INT MAX-INT TMOD }T
T{ MIN-INT MIN-INT MOD -> MIN-INT MIN-INT TMOD }T

T{ 0 2 1 */ -> 0 2 1 T*/ }T
T{ 1 2 1 */ -> 1 2 1 T*/ }T
T{ 2 2 1 */ -> 2 2 1 T*/ }T
T{ -1 2 1 */ -> -1 2 1 T*/ }T
T{ -2 2 1 */ -> -2 2 1 T*/ }T
T{ 0 2 -1 */ -> 0 2 -1 T*/ }T
T{ 1 2 -1 */ -> 1 2 -1 T*/ }T
T{ 2 2 -1 */ -> 2 2 -1 T*/ }T
T{ -1 2 -1 */ -> -1 2 -1 T*/ }T
T{ -2 2 -1 */ -> -2 2 -1 T*/ }T
T{ 2 2 2 */ -> 2 2 2 T*/ }T
T{ -1 2 -1 */ -> -1 2 -1 T*/ }T
T{ -2 2 -2 */ -> -2 2 -2 T*/ }T
T{ 7 2 3 */ -> 7 2 3 T*/ }T
T{ 7 2 -3 */ -> 7 2 -3 T*/ }T
T{ -7 2 3 */ -> -7 2 3 T*/ }T
T{ -7 2 -3 */ -> -7 2 -3 T*/ }T
T{ MAX-INT 2 MAX-INT */ -> MAX-INT 2 MAX-INT T*/ }T
T{ MIN-INT 2 MIN-INT */ -> MIN-INT 2 MIN-INT T*/ }T

T{ 0 2 1 */MOD -> 0 2 1 T*/MOD }T
T{ 1 2 1 */MOD -> 1 2 1 T*/MOD }T
T{ 2 2 1 */MOD -> 2 2 1 T*/MOD }T
T{ -1 2 1 */MOD -> -1 2 1 T*/MOD }T
T{ -2 2 1 */MOD -> -2 2 1 T*/MOD }T
T{ 0 2 -1 */MOD -> 0 2 -1 T*/MOD }T
T{ 1 2 -1 */MOD -> 1 2 -1 T*/MOD }T
T{ 2 2 -1 */MOD -> 2 2 -1 T*/MOD }T
T{ -1 2 -1 */MOD -> -1 2 -1 T*/MOD }T
T{ -2 2 -1 */MOD -> -2 2 -1 T*/MOD }T
T{ 2 2 2 */MOD -> 2 2 2 T*/MOD }T
T{ -1 2 -1 */MOD -> -1 2 -1 T*/MOD }T
T{ -2 2 -2 */MOD -> -2 2 -2 T*/MOD }T
T{ 7 2 3 */MOD -> 7 2 3 T*/MOD }T
T{ 7 2 -3 */MOD -> 7 2 -3 T*/MOD }T
T{ -7 2 3 */MOD -> -7 2 3 T*/MOD }T
T{ -7 2 -3 */MOD -> -7 2 -3 T*/MOD }T
T{ MAX-INT 2 MAX-INT */MOD -> MAX-INT 2 MAX-INT T*/MOD }T
T{ MIN-INT 2 MIN-INT */MOD -> MIN-INT 2 MIN-INT T*/MOD }T

\ ------------------------------------------------------------------------
TESTING HERE , @ ! CELL+ CELLS C, C@ C! CHARS 2@ 2! ALIGN ALIGNED +! ALLOT

HERE 1 ALLOT
HERE
CONSTANT 2NDA
CONSTANT 1STA
T{ 1STA 2NDA U< -> <TRUE> }T		\ HERE MUST GROW WITH ALLOT
T{ 1STA 1+ -> 2NDA }T			\ ... BY ONE ADDRESS UNIT
( MISSING TEST: NEGATIVE ALLOT )

HERE 1 ,
HERE 2 ,
CONSTANT 2ND
CONSTANT 1ST
T{ 1ST 2ND U< -> <TRUE> }T			\ HERE MUST GROW WITH ALLOT
T{ 1ST CELL+ -> 2ND }T			\ ... BY ONE CELL
T{ 1ST 1 CELLS + -> 2ND }T
T{ 1ST @ 2ND @ -> 1 2 }T
T{ 5 1ST ! -> }T
T{ 1ST @ 2ND @ -> 5 2 }T
T{ 6 2ND ! -> }T
T{ 1ST @ 2ND @ -> 5 6 }T
T{ 1ST 2@ -> 6 5 }T
T{ 2 1 1ST 2! -> }T
T{ 1ST 2@ -> 2 1 }T
T{ 1S 1ST !  1ST @ -> 1S }T		\ CAN STORE CELL-WIDE VALUE

HERE 1 C,
HERE 2 C,
CONSTANT 2NDC
CONSTANT 1STC
T{ 1STC 2NDC U< -> <TRUE> }T		\ HERE MUST GROW WITH ALLOT
T{ 1STC CHAR+ -> 2NDC }T			\ ... BY ONE CHAR
T{ 1STC 1 CHARS + -> 2NDC }T
T{ 1STC C@ 2NDC C@ -> 1 2 }T
T{ 3 1STC C! -> }T
T{ 1STC C@ 2NDC C@ -> 3 2 }T
T{ 4 2NDC C! -> }T
T{ 1STC C@ 2NDC C@ -> 3 4 }T

ALIGN 1 ALLOT HERE ALIGN HERE 3 CELLS ALLOT
CONSTANT A-ADDR  CONSTANT UA-ADDR
T{ UA-ADDR ALIGNED -> A-ADDR }T
T{    1 A-ADDR C!  A-ADDR C@ ->    1 }T
T{ 1234 A-ADDR  !  A-ADDR  @ -> 1234 }T
T{ 123 456 A-ADDR 2!  A-ADDR 2@ -> 123 456 }T
T{ 2 A-ADDR CHAR+ C!  A-ADDR CHAR+ C@ -> 2 }T
T{ 3 A-ADDR CELL+ C!  A-ADDR CELL+ C@ -> 3 }T
T{ 1234 A-ADDR CELL+ !  A-ADDR CELL+ @ -> 1234 }T
T{ 123 456 A-ADDR CELL+ 2!  A-ADDR CELL+ 2@ -> 123 456 }T

: BITS ( X -- U )
   0 SWAP BEGIN DUP WHILE DUP MSB AND IF >R 1+ R> THEN 2* REPEAT DROP ;
( CHARACTERS >= 1 AU, <= SIZE OF CELL, >= 8 BITS )
T{ 1 CHARS 1 < -> <FALSE> }T
T{ 1 CHARS 1 CELLS > -> <FALSE> }T
( TBD: HOW TO FIND NUMBER OF BITS? )

( CELLS >= 1 AU, INTEGRAL MULTIPLE OF CHAR SIZE, >= 16 BITS )
T{ 1 CELLS 1 < -> <FALSE> }T
T{ 1 CELLS 1 CHARS MOD -> 0 }T
T{ 1S BITS 10 < -> <FALSE> }T

T{ 0 1ST ! -> }T
T{ 1 1ST +! -> }T
T{ 1ST @ -> 1 }T
T{ -1 1ST +! 1ST @ -> 0 }T

\ ------------------------------------------------------------------------
TESTING CHAR [CHAR] [ ] BL S"

T{ BL -> 20 }T
T{ CHAR X -> 58 }T
T{ CHAR HELLO -> 48 }T
T{ : GC1 [CHAR] X ; -> }T
T{ : GC2 [CHAR] HELLO ; -> }T
T{ GC1 -> 58 }T
T{ GC2 -> 48 }T
T{ : GC3 [ GC1 ] LITERAL ; -> }T
T{ GC3 -> 58 }T
T{ : GC4 S" XY" ; -> }T
T{ GC4 SWAP DROP -> 2 }T
T{ GC4 DROP DUP C@ SWAP CHAR+ C@ -> 58 59 }T

\ ------------------------------------------------------------------------
TESTING ' ['] FIND EXECUTE IMMEDIATE COUNT LITERAL POSTPONE STATE

T{ : GT1 123 ; -> }T
T{ ' GT1 EXECUTE -> 123 }T
T{ : GT2 ['] GT1 ; IMMEDIATE -> }T
T{ GT2 EXECUTE -> 123 }T
HERE 3 C, CHAR G C, CHAR T C, CHAR 1 C, CONSTANT GT1STRING
HERE 3 C, CHAR G C, CHAR T C, CHAR 2 C, CONSTANT GT2STRING
T{ GT1STRING FIND -> ' GT1 -1 }T
T{ GT2STRING FIND -> ' GT2 1 }T
( HOW TO SEARCH FOR NON-EXISTENT WORD? )
T{ : GT3 GT2 LITERAL ; -> }T
T{ GT3 -> ' GT1 }T
T{ GT1STRING COUNT -> GT1STRING CHAR+ 3 }T

T{ : GT4 POSTPONE GT1 ; IMMEDIATE -> }T
T{ : GT5 GT4 ; -> }T
T{ GT5 -> 123 }T
T{ : GT6 345 ; IMMEDIATE -> }T
T{ : GT7 POSTPONE GT6 ; -> }T
T{ GT7 -> 345 }T

T{ : GT8 STATE @ ; IMMEDIATE -> }T
T{ GT8 -> 0 }T
T{ : GT9 GT8 LITERAL ; -> }T
T{ GT9 0= -> <FALSE> }T

\ ------------------------------------------------------------------------
TESTING IF ELSE THEN BEGIN WHILE REPEAT UNTIL RECURSE

T{ : GI1 IF 123 THEN ; -> }T
T{ : GI2 IF 123 ELSE 234 THEN ; -> }T
T{ 0 GI1 -> }T
T{ 1 GI1 -> 123 }T
T{ -1 GI1 -> 123 }T
T{ 0 GI2 -> 234 }T
T{ 1 GI2 -> 123 }T
T{ -1 GI1 -> 123 }T

T{ : GI3 BEGIN DUP 5 < WHILE DUP 1+ REPEAT ; -> }T
T{ 0 GI3 -> 0 1 2 3 4 5 }T
T{ 4 GI3 -> 4 5 }T
T{ 5 GI3 -> 5 }T
T{ 6 GI3 -> 6 }T

T{ : GI4 BEGIN DUP 1+ DUP 5 > UNTIL ; -> }T
T{ 3 GI4 -> 3 4 5 6 }T
T{ 5 GI4 -> 5 6 }T
T{ 6 GI4 -> 6 7 }T

T{ : GI5 BEGIN DUP 2 > WHILE DUP 5 < WHILE DUP 1+ REPEAT 123 ELSE 345 THEN ; -> }T
T{ 1 GI5 -> 1 345 }T
T{ 2 GI5 -> 2 345 }T
T{ 3 GI5 -> 3 4 5 123 }T
T{ 4 GI5 -> 4 5 123 }T
T{ 5 GI5 -> 5 123 }T

T{ : GI6 ( N -- 0,1,..N ) DUP IF DUP >R 1- RECURSE R> THEN ; -> }T
T{ 0 GI6 -> 0 }T
T{ 1 GI6 -> 0 1 }T
T{ 2 GI6 -> 0 1 2 }T
T{ 3 GI6 -> 0 1 2 3 }T
T{ 4 GI6 -> 0 1 2 3 4 }T

\ ------------------------------------------------------------------------
TESTING DO LOOP +LOOP I J UNLOOP LEAVE EXIT

T{ : GD1 DO I LOOP ; -> }T
T{ 4 1 GD1 -> 1 2 3 }T
T{ 2 -1 GD1 -> -1 0 1 }T
T{ MID-UINT+1 MID-UINT GD1 -> MID-UINT }T

T{ : GD2 DO I -1 +LOOP ; -> }T
T{ 1 4 GD2 -> 4 3 2 1 }T
T{ -1 2 GD2 -> 2 1 0 -1 }T
T{ MID-UINT MID-UINT+1 GD2 -> MID-UINT+1 MID-UINT }T

T{ : GD3 DO 1 0 DO J LOOP LOOP ; -> }T
T{ 4 1 GD3 -> 1 2 3 }T
T{ 2 -1 GD3 -> -1 0 1 }T
T{ MID-UINT+1 MID-UINT GD3 -> MID-UINT }T

T{ : GD4 DO 1 0 DO J LOOP -1 +LOOP ; -> }T
T{ 1 4 GD4 -> 4 3 2 1 }T
T{ -1 2 GD4 -> 2 1 0 -1 }T
T{ MID-UINT MID-UINT+1 GD4 -> MID-UINT+1 MID-UINT }T

T{ : GD5 123 SWAP 0 DO I 4 > IF DROP 234 LEAVE THEN LOOP ; -> }T
T{ 1 GD5 -> 123 }T
T{ 5 GD5 -> 123 }T
T{ 6 GD5 -> 234 }T

T{ : GD6  ( PAT: T{0 0}T,T{0 0}TT{1 0}TT{1 1}T,T{0 0}TT{1 0}TT{1 1}TT{2 0}TT{2 1}TT{2 2}T )
   0 SWAP 0 DO
      I 1+ 0 DO I J + 3 = IF I UNLOOP I UNLOOP EXIT THEN 1+ LOOP
    LOOP ; -> }T
T{ 1 GD6 -> 1 }T
T{ 2 GD6 -> 3 }T
T{ 3 GD6 -> 4 1 2 }T

\ ------------------------------------------------------------------------
TESTING DEFINING WORDS: : ; CONSTANT VARIABLE CREATE DOES> >BODY

T{ 123 CONSTANT X123 -> }T
T{ X123 -> 123 }T
T{ : EQU CONSTANT ; -> }T
T{ X123 EQU Y123 -> }T
T{ Y123 -> 123 }T

T{ VARIABLE V1 -> }T
T{ 123 V1 ! -> }T
T{ V1 @ -> 123 }T

T{ : NOP : POSTPONE ; ; -> }T
T{ NOP NOP1 NOP NOP2 -> }T
T{ NOP1 -> }T
T{ NOP2 -> }T

T{ : DOES1 DOES> @ 1 + ; -> }T
T{ : DOES2 DOES> @ 2 + ; -> }T
T{ CREATE CR1 -> }T
T{ CR1 -> HERE }T
T{ ' CR1 >BODY -> HERE }T
T{ 1 , -> }T
T{ CR1 @ -> 1 }T
T{ DOES1 -> }T
T{ CR1 -> 2 }T
T{ DOES2 -> }T
T{ CR1 -> 3 }T

T{ : WEIRD: CREATE DOES> 1 + DOES> 2 + ; -> }T
T{ WEIRD: W1 -> }T
T{ ' W1 >BODY -> HERE }T
T{ W1 -> HERE 1 + }T
T{ W1 -> HERE 2 + }T

\ ------------------------------------------------------------------------
TESTING EVALUATE

: GE1 S" 123" ; IMMEDIATE
: GE2 S" 123 1+" ; IMMEDIATE
: GE3 S" : GE4 345 ;" ;
: GE5 EVALUATE ; IMMEDIATE

T{ GE1 EVALUATE -> 123 }T			( TEST EVALUATE IN INTERP. STATE )
T{ GE2 EVALUATE -> 124 }T
T{ GE3 EVALUATE -> }T
T{ GE4 -> 345 }T

T{ : GE6 GE1 GE5 ; -> }T			( TEST EVALUATE IN COMPILE STATE )
T{ GE6 -> 123 }T
T{ : GE7 GE2 GE5 ; -> }T
T{ GE7 -> 124 }T

\ ------------------------------------------------------------------------
TESTING SOURCE >IN WORD

: GS1 S" SOURCE" 2DUP EVALUATE
       >R SWAP >R = R> R> = ;
T{ GS1 -> <TRUE> <TRUE> }T

VARIABLE SCANS
: RESCAN?  -1 SCANS +! SCANS @ IF 0 >IN ! THEN ;

T{ 2 SCANS !
345 RESCAN?
-> 345 345 }T

: GS2  5 SCANS ! S" 123 RESCAN?" EVALUATE ;
T{ GS2 -> 123 123 123 123 123 }T

: GS3 WORD COUNT SWAP C@ ;
T{ BL GS3 HELLO -> 5 CHAR H }T
T{ CHAR " GS3 GOODBYE" -> 7 CHAR G }T
T{ BL GS3
DROP -> 0 }T				\ BLANK LINE RETURN ZERO-LENGTH STRING

: GS4 SOURCE >IN ! DROP ;
T{ GS4 123 456
-> }T

\ ------------------------------------------------------------------------
TESTING <# # #S #> HOLD SIGN BASE >NUMBER HEX DECIMAL

: S=  \ ( ADDR1 C1 ADDR2 C2 -- T/F ) COMPARE TWO STRINGS.
   >R SWAP R@ = IF			\ MAKE SURE STRINGS HAVE SAME LENGTH
      R> ?DUP IF			\ IF NON-EMPTY STRINGS
	 0 DO
	    OVER C@ OVER C@ - IF 2DROP <FALSE> UNLOOP EXIT THEN
	    SWAP CHAR+ SWAP CHAR+
         LOOP
      THEN
      2DROP <TRUE>			\ IF WE GET HERE, STRINGS MATCH
   ELSE
      R> DROP 2DROP <FALSE>		\ LENGTHS MISMATCH
   THEN ;

: GP1  <# 41 HOLD 42 HOLD 0 0 #> S" BA" S= ;
T{ GP1 -> <TRUE> }T

: GP2  <# -1 SIGN 0 SIGN -1 SIGN 0 0 #> S" --" S= ;
T{ GP2 -> <TRUE> }T

: GP3  <# 1 0 # # #> S" 01" S= ;
T{ GP3 -> <TRUE> }T

: GP4  <# 1 0 #S #> S" 1" S= ;
T{ GP4 -> <TRUE> }T

24 CONSTANT MAX-BASE			\ BASE 2 .. 36
: COUNT-BITS
   0 0 INVERT BEGIN DUP WHILE >R 1+ R> 2* REPEAT DROP ;
COUNT-BITS 2* CONSTANT #BITS-UD		\ NUMBER OF BITS IN UD

: GP5
   BASE @ <TRUE>
   MAX-BASE 1+ 2 DO			\ FOR EACH POSSIBLE BASE
      I BASE !				\ TBD: ASSUMES BASE WORKS
      I 0 <# #S #> S" 10" S= AND
   LOOP
   SWAP BASE ! ;
T{ GP5 -> <TRUE> }T

: GP6
   BASE @ >R  2 BASE !
   MAX-UINT MAX-UINT <# #S #>		\ MAXIMUM UD TO BINARY
   R> BASE !				\ S: C-ADDR U
   DUP #BITS-UD = SWAP
   0 DO					\ S: C-ADDR FLAG
      OVER C@ [CHAR] 1 = AND		\ ALL ONES
      >R CHAR+ R>
   LOOP SWAP DROP ;
T{ GP6 -> <TRUE> }T

: GP7
   BASE @ >R    MAX-BASE BASE !
   <TRUE>
   A 0 DO
      I 0 <# #S #>
      1 = SWAP C@ I 30 + = AND AND
   LOOP
   MAX-BASE A DO
      I 0 <# #S #>
      1 = SWAP C@ 41 I A - + = AND AND
   LOOP
   R> BASE ! ;

T{ GP7 -> <TRUE> }T

\ >NUMBER TESTS
CREATE GN-BUF 0 C,
: GN-STRING	GN-BUF 1 ;
: GN-CONSUMED	GN-BUF CHAR+ 0 ;
: GN'		[CHAR] ' WORD CHAR+ C@ GN-BUF C!  GN-STRING ;

T{ 0 0 GN' 0' >NUMBER -> 0 0 GN-CONSUMED }T
T{ 0 0 GN' 1' >NUMBER -> 1 0 GN-CONSUMED }T
T{ 1 0 GN' 1' >NUMBER -> BASE @ 1+ 0 GN-CONSUMED }T
T{ 0 0 GN' -' >NUMBER -> 0 0 GN-STRING }T	\ SHOULD FAIL TO CONVERT THESE
T{ 0 0 GN' +' >NUMBER -> 0 0 GN-STRING }T
T{ 0 0 GN' .' >NUMBER -> 0 0 GN-STRING }T

: >NUMBER-BASED
   BASE @ >R BASE ! >NUMBER R> BASE ! ;

T{ 0 0 GN' 2' 10 >NUMBER-BASED -> 2 0 GN-CONSUMED }T
T{ 0 0 GN' 2'  2 >NUMBER-BASED -> 0 0 GN-STRING }T
T{ 0 0 GN' F' 10 >NUMBER-BASED -> F 0 GN-CONSUMED }T
T{ 0 0 GN' G' 10 >NUMBER-BASED -> 0 0 GN-STRING }T
T{ 0 0 GN' G' MAX-BASE >NUMBER-BASED -> 10 0 GN-CONSUMED }T
T{ 0 0 GN' Z' MAX-BASE >NUMBER-BASED -> 23 0 GN-CONSUMED }T

: GN1	\ ( UD BASE -- UD' LEN ) UD SHOULD EQUAL UD' AND LEN SHOULD BE ZERO.
   BASE @ >R BASE !
   <# #S #>
   0 0 2SWAP >NUMBER SWAP DROP		\ RETURN LENGTH ONLY
   R> BASE ! ;
T{ 0 0 2 GN1 -> 0 0 0 }T
T{ MAX-UINT 0 2 GN1 -> MAX-UINT 0 0 }T
T{ MAX-UINT DUP 2 GN1 -> MAX-UINT DUP 0 }T
T{ 0 0 MAX-BASE GN1 -> 0 0 0 }T
T{ MAX-UINT 0 MAX-BASE GN1 -> MAX-UINT 0 0 }T
T{ MAX-UINT DUP MAX-BASE GN1 -> MAX-UINT DUP 0 }T

: GN2	\ ( -- 16 10 )
   BASE @ >R  HEX BASE @  DECIMAL BASE @  R> BASE ! ;
T{ GN2 -> 10 A }T

\ ------------------------------------------------------------------------
TESTING FILL MOVE

CREATE FBUF 00 C, 00 C, 00 C,
CREATE SBUF 12 C, 34 C, 56 C,
: SEEBUF FBUF C@  FBUF CHAR+ C@  FBUF CHAR+ CHAR+ C@ ;

T{ FBUF 0 20 FILL -> }T
T{ SEEBUF -> 00 00 00 }T

T{ FBUF 1 20 FILL -> }T
T{ SEEBUF -> 20 00 00 }T

T{ FBUF 3 20 FILL -> }T
T{ SEEBUF -> 20 20 20 }T

T{ FBUF FBUF 3 CHARS MOVE -> }T		\ BIZARRE SPECIAL CASE
T{ SEEBUF -> 20 20 20 }T

T{ SBUF FBUF 0 CHARS MOVE -> }T
T{ SEEBUF -> 20 20 20 }T

T{ SBUF FBUF 1 CHARS MOVE -> }T
T{ SEEBUF -> 12 20 20 }T

T{ SBUF FBUF 3 CHARS MOVE -> }T
T{ SEEBUF -> 12 34 56 }T

T{ FBUF FBUF CHAR+ 2 CHARS MOVE -> }T
T{ SEEBUF -> 12 12 34 }T

T{ FBUF CHAR+ FBUF 2 CHARS MOVE -> }T
T{ SEEBUF -> 12 34 34 }T

\ ------------------------------------------------------------------------
TESTING OUTPUT: . ." CR EMIT SPACE SPACES TYPE U.

: OUTPUT-TEST
   ." YOU SHOULD SEE THE STANDARD GRAPHIC CHARACTERS:" CR
   41 BL DO I EMIT LOOP CR
   61 41 DO I EMIT LOOP CR
   7F 61 DO I EMIT LOOP CR
   ." YOU SHOULD SEE 0-9 SEPARATED BY A SPACE:" CR
   9 1+ 0 DO I . LOOP CR
   ." YOU SHOULD SEE 0-9 (WITH NO SPACES):" CR
   [CHAR] 9 1+ [CHAR] 0 DO I 0 SPACES EMIT LOOP CR
   ." YOU SHOULD SEE A-G SEPARATED BY A SPACE:" CR
   [CHAR] G 1+ [CHAR] A DO I EMIT SPACE LOOP CR
   ." YOU SHOULD SEE 0-5 SEPARATED BY TWO SPACES:" CR
   5 1+ 0 DO I [CHAR] 0 + EMIT 2 SPACES LOOP CR
   ." YOU SHOULD SEE TWO SEPARATE LINES:" CR
   S" LINE 1" TYPE CR S" LINE 2" TYPE CR
   ." YOU SHOULD SEE THE NUMBER RANGES OF SIGNED AND UNSIGNED NUMBERS:" CR
   ."   SIGNED: " MIN-INT . MAX-INT . CR
   ." UNSIGNED: " 0 U. MAX-UINT U. CR
;

T{ OUTPUT-TEST -> }T


\ ------------------------------------------------------------------------
TESTING INPUT: ACCEPT

CREATE ABUF 80 CHARS ALLOT

: ACCEPT-TEST
   CR ." PLEASE TYPE UP TO 80 CHARACTERS:" CR
   ABUF 80 ACCEPT
   CR ." RECEIVED: " [CHAR] " EMIT
   ABUF SWAP TYPE [CHAR] " EMIT CR
;

T{ ACCEPT-TEST -> }T

\ ------------------------------------------------------------------------
TESTING DICTIONARY SEARCH RULES

T{ : GDX   123 ; : GDX   GDX 234 ; -> }T

T{ GDX -> 123 234 }T

CR .( End of Core word set tests) CR


