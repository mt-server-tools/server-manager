#!/bin/bash

cd "$(dirname "$0")"

. test_framework.sh

. ../sh-src/new-server.sh

t:expect "parse_args should error on fail" "$(newserver:parse_args)" '^\s*$'

newserver:parse_args -a "my admin" -t "A title" -s "server name" --hostname "example.com" --description "desc"

t:expect "Hostname" "$MTST_hostname" "example.com"
t:expect "Admin" "$MTST_game_admin" "myadmin"
t:expect "Title" "$MTST_game_title" "A title"
t:expect "Server name" "$MTST_sys_servername" "servername"
