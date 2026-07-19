#!/bin/bash
#
# import_bash take care of pragma once and relative path issues, and other things like avoiding circular deps;
#
# shellcheck disable=SC2317,SC2329
. ./pragma_once.sh || return 0
# this script will iterate all arguments importing they as source, only if they are not imported already, and if no arguments are given it will read it from stdin;

set -eumo pipefail;
# get_inpu_array takes an array variable and a list of arguments or the stdin and populate the array variable with those items. STDIN will be used only if no arguments are given
get_input_array(){
	[[ $# == 0 ]] && {
		echo "get_input_array: array name is required" >&2;
		return 1;
	}

	declare -p "$1" >/dev/null || {
		# create the var as array if it does not exists
		declare -a "$1";
	}
	local -n arr="$1";
	set +u
	local arr_attr=${arr@a};
	set -u
	[[ "${arr_attr}" != *a* ]] && {
		echo "$1 is not an array";
		return 1;
	}
	shift;
	[[ $# == 0 ]] && return;
	local use_stdin=0;
	[[ $1 == -i ]] && use_stdin=1 && shift;
	while [ $# -gt 0 ];
	do
		arr+=( "$1" );
		shift;
	done
	(( use_stdin == 1 )) && {
		mapfile -t stdin_arr;
		arr=( "${arr[@]}" "${stdin_arr[@]}" );
	}
	return 0
}

# shellcheck disable=SC2329,SC1090
import_bash(){
	local -a sources=();
	get_input_array sources "$@";
	[ ${#sources[@]} == 0 ] && get_input_array sources -i;
	[ ${#sources[@]} == 0 ] && error "zero sources";
	local csd;
	local pragma_once_dir;
	pragma_once_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}" --relative-to .)")";
	csd="$(dirname "$(realpath "${BASH_SOURCE[1]}" --relative-to .)")";
	for (( i=0; i<${#sources[@]}; i++ )); do
		local PRAGMA_SOURCE_FILE;
		PRAGMA_SOURCE_FILE="$(realpath "${sources[i]}" --relative-to . 2>&1 || true)";
		[ ! -f "$PRAGMA_SOURCE_FILE" ] && continue;
		source "${pragma_once_dir}/pragma_once.sh" || {
			echo "failed to import ${pragma_once_dir}/pragma_once.sh">&2
			continue;
		}
		source "$csd/${sources[i]}";
	done
}
