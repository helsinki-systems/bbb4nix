#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

sbtixLoad

# Generate nix expressions
cd ../checkouts/bigbluebutton/bbb-common-message
sbtix-gen-all2

# Patch sbtix files
sbtixDoLibrary
sbtixFixLocal

# Add missing dependencies
sed -i '$ d' manual-repo.nix
sed -i '$ d' manual-repo.nix
cat >> manual-repo.nix <<'EOF'
    "nix-public/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.pom" = {
      url = "https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.pom";
      sha256 = "sha256-gXHd2q93kXrnNlXuyGTtjkOC97m0kGgkfr3PxrQknTQ=";
    };
    "nix-public/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.jar" = {
      url = "https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.jar";
      sha256 = "sha256-Xvqfu1SlixoSIFpfrFZfaYKr/rD/Rb28MYdI71/To/8=";
    };
    "nix-sonatype-releases/org/apache/apache/21/apache-21.pom" = {
      url = "https://oss.sonatype.org/content/repositories/releases/org/apache/apache/21/apache-21.pom";
      sha256 = "sha256-rxDBCNoBTxfK+se1KytLWjocGCZfoq+XoyXZFDU3s4A=";
    };
  };
}
EOF

# Copy back expressions
cp -vf repo.nix manual-repo.nix ../../../bbb-common-message/
cp -vf project/repo.nix ../../../bbb-common-message/project-repo.nix

# Test build
cd ../..
buildProject bbb-common-message
