infoe() {
	echo "Info: $*" >&2
}
warne() {
	echo "Warn: $*" >&2
}
faile() {
	echo "Fail: $* (wrap test in subshell)" >&2
	exit
}

t:ok() {
	echo "[32;1m$*[0m"
}

t:fail() {
	echo "[31;1m$*[0m"
}

t:warn() {
	echo "[33;1m$*[0m"
}

t:expect() {
	local testname="$1"; shift
	local target="$1"; shift
	local value="$1"; shift

	[[ "$target" =~ $value ]] && {
		t:ok "$testname"
	} || {
		t:fail "$testname : expected [$value] but found [$target]"
	}
}
