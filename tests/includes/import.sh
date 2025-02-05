#! /bin/bash

# test that the nesting relation is inclusion by default and when declared
#

set -e
if [[ -z $STORE_HOST ]]; then source ../define.sh; fi

curl_clear_repository_content ;

curl_graph_store_update -H "Content-Type: application/trig" <<EOF
@base <http://dydra.com/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .

[]{ <http://example.org/someErroneousSubject>  <http://example.org/p> <http://example.org/o> . }
EOF

curl_graph_store_get > /tmp/test.out

fgrep -c http://example.org/s /tmp/test.out | fgrep -s "1"
fgrep -c http://example.org/p /tmp/test.out | fgrep -s "1"
fgrep -c http://example.org/o /tmp/test.out | fgrep -s "1"
fgrep -c includes /tmp/test.out | fgrep -s "1"

curl_clear_repository_content ;

curl_graph_store_update -H "Content-Type: application/trig" <<EOF
@base <http://dydra.com/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix nng: <http://dydra.com/nng#> .

[nng:NamedGraph]{ <http://example.org/s>  <http://example.org/p> <http://example.org/o> . }
EOF

curl_graph_store_get > /tmp/test.out

fgrep -c includes /tmp/test.out | fgrep -s "1"
