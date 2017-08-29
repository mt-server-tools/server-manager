newserver:parse_args() {

	while [[ -n "$*" ]]; do
		local arg="$1"; shift

		case "$arg" in
		--name)
			MTST_server_name="$1"; shift
			;;
		--admin)
			MTST_game_admin="$1"; shift
			;;
		--description)
			MTST_game_description="$1"; shift
			;;
		--title)
			MTST_game_title="$1"; shift
			;;
		esac
	done

	newserver:verify_requirements
}

newserver:verify_requirements() {
	[[ -n "$MTST_server_name" ]] || faile "Account name required"
}

newserver:create_server_data() {
	local u="$MTST_server_name"

	useradd -m "$u"
	passwd "$u"

	(
		cd ~"$u"/
		mkdir -p .minetest/{worlds,mods,games}
		cp -r "$MTST_default_worlds/leveldb" .minetest/worlds/world
		chown "$u:$u" .minetest
	)
}

newserver:main() {
	newserver:parse_args "$@"

	newserver:create_server_data

	"$MTST_bins/mtst-config.py" "$MTST_default_config"
	"$MTST_bins/mtst-service.py" "$MTST_server_name" "$MTSTS_service_template"
}
