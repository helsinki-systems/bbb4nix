#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

# Check out all static projects

set -euo pipefail
cd "$(dirname "${0}")"

pullOrClone() {
	if [ -d "${1}" ]; then
		(
			cd "${1}" || exit 1
			git checkout "${3}"
			git pull
		)
	else
		git clone -b "${3}" "${2}" "${1}"
	fi
}

pullOrClone gradle2nix https://github.com/tadfisher/gradle2nix lenient-configs
