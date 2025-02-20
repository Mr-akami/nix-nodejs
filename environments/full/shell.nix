# nixpkgsをインポートするための基本的な関数定義
{ packages ? import <nixpkgs> {} }:

# 開発シェル環境の定義
packages.mkShell {
  # 必要なパッケージを直接指定
  buildInputs = [
    # Denoの環境をインポート
    (import ../deno/shell.nix { inherit packages; }).buildInputs
    # Node.jsの環境をインポート
    (import ../node/shell.nix { inherit packages; }).buildInputs
  ];

  # シェルが起動したときに実行されるスクリプト
  shellHook = ''
    echo "Full development environment activated"
    echo "----------------------------------------"
    echo "Deno version: $(deno --version)"
    echo "Node.js version: $(node --version)"
    echo "pnpm version: $(pnpm --version)"
    echo "----------------------------------------"
  '';
} 