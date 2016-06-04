! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math namespaces ;
in: tools.deploy.test.7

symbol: my-var

GENERIC: my-generic ( x -- b ) ;

M: integer my-generic sq ;

M: fixnum my-generic call-next-method my-var get call( a -- b ) ;

: test-7 ( -- )
    [ 1 + ] my-var set-global
    12 my-generic 145 assert= ;

main: test-7