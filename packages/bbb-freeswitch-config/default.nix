{ stdenvNoCC, callPackage, xmlstarlet, extraConfigure ? "" }: let
  src = callPackage ../sources/bbb-freeswitch-core {};

in stdenvNoCC.mkDerivation {
  pname = "bbb-freeswitch-config";
  inherit (src) version;

  inherit src;

  nativeBuildInputs = [ xmlstarlet ];

  configurePhase = ''
    pushd opt/freeswitch/etc/freeswitch
    runHook preConfigure

    # Insert sounds location
    xml ed -P -L -i '/include/X-PRE-PROCESS[1]' -t elem -n X-PRE-PROCESS -v "" \
      -i '/include/X-PRE-PROCESS[1]' -t attr -n cmd -v set \
      -i '/include/X-PRE-PROCESS[1]' -t attr -n data -v sounds_dir=${callPackage ../bbb-freeswitch-sounds {}} \
      vars.xml

    ${extraConfigure}

    runHook postConfigure
    popd &>/dev/null
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r opt/freeswitch/etc/freeswitch $out
    runHook postInstall
  '';
}
