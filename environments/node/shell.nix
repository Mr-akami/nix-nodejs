{ packages ? import <nixpkgs> {} }:

let
  # 共通の設定を読み込む
  baseShell = import ../../shells/shell.nix { inherit packages; };
in
packages.mkShell {
  # 基本シェルから設定を継承
  inherit (baseShell) pure;

  # 基本シェルから buildInputs を継承
  buildInputs = baseShell.buildInputs ++ (with packages; [
    nodejs_22 # Node.js v22
    nodePackages.pnpm # pnpmを追加
  ]);

  shellHook = ''
    ${baseShell.shellHook}
    echo "Node.js development environment activated"
    echo "Node.js version: $(node --version)"
    echo "pnpm version: $(pnpm --version)" 
  '';
}