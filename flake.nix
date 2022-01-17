{
  description = "sMuNiX NUR repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.dtrx = {
    url = "github:dtrx-py/dtrx?ref=master";
    flake = false;
  };
  outputs = { self, nixpkgs, dtrx }:
    let
      config = { allowUnfree = true; };
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      overlay = final: _:
        with final;
        with python3Packages;
        let
          archivers = lib.makeBinPath [
            gnutar
            lhasa
            rpm
            binutils
            cpio
            gzip
            p7zip
            cabextract
            unshield
            unzip
            unrar
            bzip2
            xz
            lzip
          ];
        in {
          dtrx = buildPythonApplication {
            pname = "dtrx";
            version = dtrx.shortRev;
            src = dtrx;
            propagatedBuildInputs = [ setuptools twine ];
            postInstall = ''
              wrapProgram "$out/bin/dtrx" --prefix PATH : "${archivers}"
            '';
            doCheck = true;
            meta = with lib; {
              description =
                "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
              homepage = "https://github.com/dtrx-py/dtrx/";
              license = licenses.gpl3Plus;
              platforms = platforms.all;
            };
          };
        };
      overlays = [ overlay ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      inherit overlay;
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system config overlays; };
        in { inherit (pkgs) dtrx; });
    };
}
