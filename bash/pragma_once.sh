#!/bin/bash
# Prevent multiple sourcing, but allows it if the source changed
# Use like:
#  source pragma_once.sh && return 0;
# When in subdir, may be useful to use something like
#  source $(dirname $(realpath $BASH_SOURCE))/../pragma_once.sh || return 0;
# dependencies: 
#   - md5sum
#   - realpath
if [[ -z "${BASH_VERSION}" || ${BASH_VERSINFO[0]} -lt 4 ]]; then
	src="$(realpath "${BASH_SOURCE[1]}")"; # the caller script that sourced the pragma_once
	#echo "checking pragma_once for $src" >&2
	srckey=$(echo $src|md5sum|cut -d' ' -f1);
	v_prev="_${srckey}_md5_previous";
	declare v_curr="_${srckey}_md5";
	declare "$v_prev"="${!v_curr:-}";
	declare -g "${v_curr}"="$(md5sum "${src}")";
	[ "${!v_curr}" != "${!v_prev}" ];
	return;
fi

declare -g -A __SOURCED_CACHE
src="$(realpath "${BASH_SOURCE[1]}")"
curr_hash=$(md5sum "$src" | cut -d' ' -f1)
result=1
[[ "${__SOURCED_CACHE[$src]:-}" != "$curr_hash" ]] && result=0 # allow load the file
__SOURCED_CACHE["$src"]="$curr_hash"
return $result
