{ fetchFromGitHub, buildGoModule, libreoffice-still-unwrapped }:
let
  pname = "bbb-soffice-conversion-server";

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = pname;
    rev = "4dcc6c7425080bd7113b265f635f837b44db4d36";
    sha256 = "0icq85vn4ajbq5b6qsjavbh4w4kar50rbq3isgwcilkqpy93qi01";
  };

  libreoffice = libreoffice-still-unwrapped.overrideAttrs (oA: {
    patches = oA.patches or [] ++ [ "${src}/libreoffice.patch" ];
  });
in buildGoModule {
  inherit pname src;

  version = "unstable-2021-07-14";

  buildInputs = [ libreoffice ];

  passthru = {
    inherit libreoffice;
  };

  vendorSha256 = "153kfk81r88viidzc97m29w70kc8901pznhmjbhj5njzxv89f21f";
}
