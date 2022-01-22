{ stdenv, lib, fetchurl, zlib, patchelf, runtimeShell, coreutils, nodejs-12_x, makeWrapper }:

let
  version = "1.10.2";
in

stdenv.mkDerivation {
  inherit version;
  pname = "meteor";
  src = fetchurl {
    url = "https://static-meteor.netdna-ssl.com/packages-bootstrap/${version}/meteor-bootstrap-os.linux.x86_64.tar.gz";
    sha256 = "17s1n92nznasaaprvxg289a1fcizq2nj51xqw7akgw5f77q19vmw";
  };

  sourceRoot = ".meteor";

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    sed -i "s:'uname':'${coreutils}/bin/uname':g" packages/meteor-tool/*/*/tools/utils/archinfo.js
    patchShebangs .
  '';

  installPhase = ''
    mkdir $out

    cp -r packages $out
    chmod -R +w $out/packages

    cp -r package-metadata $out

    devBundle=$(find $out/packages/meteor-tool -name dev_bundle)
    ln -s $devBundle $out/dev_bundle

    toolsDir=$(dirname $(find $out/packages -print | grep "meteor-tool/.*/tools/index.js$"))
    ln -s $toolsDir $out/tools

    # Patch Meteor to dynamically fixup shebangs and ELF metadata where
    # necessary.
    pushd $out
    patch -p1 < ${./main.patch}
    popd
    sed -i 's_require..kexec...executable, newArgv.;_console.log("kexecing from springboard to:", executable, newArgv); require("kexec")(executable, newArgv);_g' $out/tools/cli/main.js
    substituteInPlace $out/tools/cli/main.js \
      --replace "@INTERPRETER@" "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace "@RPATH@" "${lib.makeLibraryPath [ stdenv.cc.cc zlib ]}" \
      --replace "@PATCHELF@" "${patchelf}/bin/patchelf"

    # sed -i 's_files.pathJoin(nodeModulesDir, ".temp_files.pathJoin("/tmp", ".temp_' $(find $out -name meteor-npm.js)
    sed -i 's_const dirsToRebuild = \[\]_return_' $(find $out -name meteor-npm.js)

    # Patch node.
    node=$devBundle/bin/node
    rm $node
    ln -s ${nodejs-12_x}/bin/node $node
    wrapProgram $_ --add-flags "--no-wasm-code-gc"

    # Patch mongo.
    for p in $devBundle/mongodb/bin/mongo{,d}; do
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath "$(patchelf --print-rpath $p):${lib.makeLibraryPath [ stdenv.cc.cc zlib ]}" \
        $p
    done

    # Patch node dlls.
    for p in $(find $out/packages -name '*.node'); do
      patchelf \
        --set-rpath "$(patchelf --print-rpath $p):${stdenv.cc.cc.lib}/lib" \
        $p || true
    done

    # Meteor needs an initial package-metadata in $HOME/.meteor,
    # otherwise it fails spectacularly.
    mkdir -p $out/bin
    cat << EOF > $out/bin/meteor
    #!${runtimeShell}

    if [[ ! -f \$HOME/.meteor/package-metadata/v2.0.1/packages.data.db ]]; then
      mkdir -p \$HOME/.meteor/package-metadata/v2.0.1
      cp $out/package-metadata/v2.0.1/packages.data.db "\$HOME/.meteor/package-metadata/v2.0.1"
      chown "\$(whoami)" "\$HOME/.meteor/package-metadata/v2.0.1/packages.data.db"
      chmod +w "\$HOME/.meteor/package-metadata/v2.0.1/packages.data.db"
    fi

    $node \''${TOOL_NODE_FLAGS} $out/tools/index.js "\$@"
    EOF
    chmod +x $out/bin/meteor

    patchShebangs $out
    find $out -name '*.js' -print0 | while read -r -d "" js; do
      sed -i "s|/usr/bin/env node|${nodejs-12_x}/bin/node|g" "$js"
    done
  '';

  meta = with lib; {
    description = "Complete open source platform for building web and mobile apps in pure JavaScript";
    homepage = "http://www.meteor.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cstrahan ];
  };
}
