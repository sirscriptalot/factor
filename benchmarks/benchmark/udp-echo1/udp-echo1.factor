! Copyright (C) 2011 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: benchmark.udp-echo0 ;
in: benchmark.udp-echo1

: udp-echo1-benchmark ( -- ) 10,000 200 udp-echo ;

main: udp-echo1-benchmark