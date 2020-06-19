{ lib, cmake }: rec {
  cmakeVersion = "cmake-" + lib.versions.majorMinor cmake.version; # TODO Use this
  mkCmakeModules = pkgs: [ ("-DCMAKE_MODULE_PATH=" + (lib.concatStringsSep ";" (map (pkg: "${pkg}/share/${cmakeVersion}/Modules") pkgs))) ];
}
