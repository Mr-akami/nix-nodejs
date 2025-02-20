{ packages ? import <nixpkgs> {} }:

let
  # 共通の設定を読み込む
  baseShell = import ../../shells/shell.nix { inherit packages; };
  # denoをビルド
  denoLatest = packages.deno.overrideAttrs (oldAttrs: {
    version = "2.2.0";
    src = packages.fetchurl {
      url = "https://github.com/denoland/deno/releases/download/v2.2.0/deno-x86_64-unknown-linux-gnu.zip";
      sha256 = "sha256-KoB1bWj4eNjAvsgPsVxNA/WciWjpdMwCpGPEzVHgWo0=";
    };
  });

  # denoLatest = packages.stdenv.mkDerivation rec {
  #   pname = "deno";
  #   version = "1.40.1"; # 任意のDenoバージョン

  #   src = packages.fetchFromGitHub {
  #     owner = "denoland";
  #     repo = "deno";
  #     rev = "v2.2.0";  # GitHubのタグを指定
  #     sha256 = "13asw18wvi33lh1cqx79d24rrx839mfb23y8pv0dhy7qd1npb01a"; # `nix-prefetch-url` で取得
  #   };

  #   buildInputs = [ packages.cmake packages.rustc packages.cargo ];

  #   installPhase = ''
  #     mkdir -p $out/bin
  #     cp target/release/deno $out/bin/
  #   '';
  # };
in
packages.mkShell {
  # 基本シェルから設定を継承
#   inherit (baseShell) pure;

  # 基本シェルから buildInputs を継承
  buildInputs = baseShell.buildInputs ++ (with packages; [
    denoLatest # deno latest
    nodePackages.pnpm # pnpmを追加
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    echo "Deno development environment activated"
    echo "Deno version: $(deno --version)"
    echo "pnpm version: $(pnpm --version)" 
  '';
}