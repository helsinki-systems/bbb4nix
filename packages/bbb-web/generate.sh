#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jdk

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

# A surprise tool that will help us later ;)
PATH="$(nix-build --no-out-link "../checkouts/gradle2nix")/bin:${PATH}"
export PATH

# Build without the sandbox (I'm serious - it caches all dependencies)
cd ../checkouts/bigbluebutton/bigbluebutton-web
rm -rf .gradle-home
mkdir .gradle-home
export GRADLE_USER_HOME="${PWD}/.gradle-home"
echo 'org.gradle.daemon=false' >> "${GRADLE_USER_HOME}/gradle.properties"
sed -i "s:mavenLocal():maven { url '${PWD}/.m2' }:g" build.gradle
mkdir -p .m2/org/bigbluebutton
ln -s "$(nix-build --no-out-link -E '(import <nixpkgs> {}).callPackage ../../../bbb-common-message {}')/repository/org/bigbluebutton/"* .m2/org/bigbluebutton/
ln -s "$(nix-build --no-out-link -E '(import <nixpkgs> {}).callPackage ../../../bbb-common-web {}')/repository/org/bigbluebutton/"* .m2/org/bigbluebutton/
chmod +x gradlew # Yeah who needs these executability flags anyway
./gradlew assemble

# Count the dependencies that were cached
gradleCaches=("${GRADLE_USER_HOME}/caches/modules-"*"/files-"*)
gradleCache="${gradleCaches[*]}"
nDeps="$(find "${gradleCache}" -type f -name '*.pom' | wc -l)"

# Overwrite build.gradle to generate a new one consisting of only dependencies.
# We find these dependencies by checking what was cached by Gradle.
{
	echo 'repositories {'
	echo '  jcenter()'
	echo '  maven { url "https://repo.grails.org/grails/core" }'
	echo '}'
	echo
	# Generate one configuration for each dependency.
	# This is required because one configuration depending on two versions of the same dependency
	# means only the newest dependency is used.
	echo 'configurations {'
	for i in $(seq 0 "${nDeps}"); do
		echo "  compile${i}"
	done
	echo '}'
	echo
	# Generate all dependencies that were previously cached by Gradle
	i=0
	echo 'dependencies {'
	while IFS= read -r path; do
		IFS=/ read -r group name version _ < <(echo "${path#"${gradleCache}/"}")
		echo "  compile${i} \"${group}:${name}:${version}\""
		i=$((++i))
	done < <(find "${gradleCache}" -type f -name '*.pom')
	echo '}'
	echo
	# Add a dummy task so our buildfile does "something"
	echo 'task dummy {'
	echo '  println "Hello World"'
	echo '}'
} > build.gradle

# Generate JSON file with all dependencies
gradle2nix

cp -vf gradle-env.json ../../../bbb-web/

# Test build
cd ../..
buildProject bbb-web
