#%include varify.sh

### new-server Usage:help
#
# The `new-server` command helps set up a new game server in a dedicated account
#
# Required parameters:
#
# -s, --sys-servername NAME
# 	A system username to create to confine the server
#
# -a, --admin ADMIN
# 	The playername of the game admin
#
# -t, --title TITLE
# 	A title for the server, shown in online lists
#
# --hostname ADDRESS
# 	The address or host name of the server
#
# Optional parameters:
#
# --description DESCRIPTION
# 	A nice description for players to see in online lists
#
###/doc

bb:varcollapse() {
	echo "$1" | sed -r 's/[^a-zA-Z0-9]+//g'
}

newserver:parse_args() {

	while [[ -n "$*" ]]; do
		local arg="$1"; shift

		case "$arg" in
		-a|--admin)
			MTST_game_admin="$(bb:varcollapse "$1")"; shift
			;;
		-t|--title)
			MTST_game_title="$1"; shift
			;;
		-s|--sys-servername)
			MTST_sys_servername="$(bb:varcollapse "$1")"; shift
			;;
		--hostname)
			MTST_hostname="$1"; shift
			;;
		--description)
			MTST_game_description="$1"; shift
			;;
		esac
	done

	newserver:verify_requirements
}

newserver:verify_requirements() {
	[[ -n "$MTST_sys_servername" ]] || faile "Account name required"
	[[ -n "$MTST_game_admin" ]] || faile "Admin player name required"
	[[ -n "$MTST_game_title" ]] || faile "Game title required"
	[[ -n "$MTST_hostname" ]] || faile "Hostname required"
}

newserver:create_server_data() {
	local u="$MTST_sys_servername"

	useradd -m "$u"
	passwd "$u"

	(
		cd ~"$u"/
		mkdir -p .minetest/{worlds,mods,games}
		cp -r "$MTST_default_worlds/leveldb" .minetest/worlds/world
		
		echo "$MTST_config_data" > .minetest/minetest.conf

		chown -R "$u:$u" .minetest
	)

	echo "$MTST_service_data" > "/etc/systemd/system/mt-$MTST_sys_servername.service"
	newserver:register_port
}

newserver:get_available_port() {
	local lastport="$(grep -v -P '^(\s*#|\s*$)' "$MTST_accounts" | cut -d: -f2 | sort | tail -n 1)" || faile "Accounts file [$MTST_accounts] not available"

	if [[ -z "$lastport" ]]; then
		MTST_port=30000
	else
		MTST_port=$((lastport + 1))
	fi
}

newserver:register_port() {
	echo "$MTST_sys_servername:$MTST_port" >> "$MTST_accounts"
}

newserver:get_config_data() {
	newserver:get_available_port || faile "Could not get port data"

	local config_params=(-t "$MTST_game_title" -a "$MTST_hostname" -p "$MTST_port" -n "$MTST_game_admin")
	MTST_config_data="$(autojinja "$MTST_default_config" "${config_params[@]}")" || return "$?"
}

newserver:get_service_data() {
	local service_params=(-u "$MTST_sys_servername" -d "$MTST_sys_servername for minetest")
	MTST_service_data="$(autojinja "$MTSTS_service_template" "$MTST_server_name" "${service_params[@]}")" || return "$?"
}

newserver:main() {
	newserver:parse_args "$@"

	newserver:get_config_data
	newserver:get_service_data

	newserver:create_server_data "$@"
}
