{ lib, stdenvNoCC, fetchurl, unzip, }:

let rev = "4d65b3cdaa726a29276d1ca5669c5eb38beee223";
in stdenvNoCC.mkDerivation {
  pname = "sakomoji";
  version = "${rev}";

  src = fetchurl {
    url = "https://git.sako.lol/sako/sakomoji/archive/${rev}.zip";
    hash = "sha256-OhLzoYFnjVs1hKYglUEbDWCjNRGBNZENh5kg+K3lpX8=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out
    cp *.gif $out

    runHook postInstall
  '';

  meta = {
    description = "sakomoji";
    homepage = "https://sako.lol";
  };
}
