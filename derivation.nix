{ stdenv, lib, babashka }:

stdenv.mkDerivation rec {
  pname = "kak-babashka";
  version = "0.1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins/
    sed "
      /^declare-option.*babashka_path/{
        s,'bb','${babashka}/bin/bb',
      }
    " rc/babashka.kak >$out/share/kak/autoload/plugins/babashka.kak
  '';

  meta = with lib; {
    description = "Evaluate babashka expressions while editing any file";
    homepage = "https://github.com/eraserhd/kak-babashka";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
