#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

# Check out all static projects

set -euo pipefail
cd "$(dirname "${0}")"

pullOrClone() {
	if [ -d "${1}" ]; then
		(
			cd "${1}" || exit 1
			git pull
		)
	else
		git clone "${2}" "${1}"
	fi
}

pullOrClone sbtix https://gitlab.com/teozkr/Sbtix.git/
