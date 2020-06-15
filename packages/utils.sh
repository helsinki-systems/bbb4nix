# Common utilities used by multiple scripts

# Returns whether one of $@ was changed (uses git)
oneIsChanged() {
	for f in "${@}"; do
		if [[ "$(git diff "${f}" | wc -l)" != 0 ]]; then
			return 0 # File is changed
		fi
		if ! git ls-files --error-unmatch "${f}" &>/dev/null; then
			return 0 # File is untracked
		fi
	done
	return 1 # Nothing changed
}

# Run a build of a project
buildProject() {
	defaultnix="$(dirname "${BASH_SOURCE[0]}")/${1}"
	nix-build --no-out-link --expr "(import <nixpkgs> {}).pkgs.callPackage ${defaultnix} {}"
}


# Add sbtix into $PATH
sbtixLoad() {
	PATH="$(nix-build --no-out-link "$(dirname "${BASH_SOURCE[0]}")/checkouts/sbtix")/bin:${PATH}"
	export PATH
}

# Switch sbtix from program to library
sbtixDoLibrary() {
	sed -i \
		-e 's/buildSbtProgram/buildSbtLibrary/g' \
		default.nix
}

# Fix sbtix paths (they point to your $HOME)
sbtixFixLocal() {
	sed \
		-Ei repo.nix \
		-e 's|nix-local-preloaded/file:/[^/]*/[^/]*/[^/]*/[^/]*|nix-public|g' \
		-e 's|file:/[^/]*/[^/]*/[^/]*/[^/]*|https://repo1.maven.org/maven2|g'
}
