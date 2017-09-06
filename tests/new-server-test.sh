#!/bin/bash

cd "$(dirname "$0")/.."

. tests/test_framework.sh

. sh-src/new-server.sh

t:report "Test parse_args"

t:expect "parse_args should error on fail" "$(newserver:parse_args)" '^\s*$'

newserver:parse_args -a "my admin" -t "A title" -s "server name" --hostname "example.com" --description "desc"

t:expect "Hostname" "$MTST_hostname" "example.com"
t:expect "Admin" "$MTST_game_admin" "myadmin"
t:expect "Title" "$MTST_game_title" "A title"
t:expect "Server name" "$MTST_sys_servername" "servername"

t:report "Test accounts/ports data"

MTST_accounts="./accounts.tmp"

# FIXME faulty test
t:expect "Failure on access non-existent account" "$(newserver:get_available_port 2>&1)" "^\S+$"

echo "# account:port" > "$MTST_accounts"
MTST_sys_servername="server1"

newserver:get_available_port
t:expect "Get initial port number" "$MTST_port" "30000"
newserver:register_port
newserver:get_available_port
t:expect "Get next port number" "$MTST_port" "30001"

# FIXME set the config and service file locations

t:report "Check config data"
newserver:get_config_data

t:report "Check service data"
newserver:get_service_data

echo "$MTST_config_data"
