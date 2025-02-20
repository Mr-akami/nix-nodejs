{
  description = "Development environments managed with Nix";

  inputs = {
    # 公式リポジトリからパッケージをインストールします
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixのflakeで便利なユーティリティ関数を提供するライブラリ 
    flake-utils.url = "github:numtide/flake-utils";
    # NixGLのサポート
    nixGL.url = "github:guibou/nixGL";
  };

  outputs = { self, nixpkgs, flake-utils, nixGL }: 
    # eachDefaultSystemは各プラットフォーム向けの設定を自動生成
    # systemにはx86_64-darwin, aarch64-linuxなどが自動的に渡される
    flake-utils.lib.eachDefaultSystem (system:
      let
        # legacyPackagesは従来のnixpkgsパッケージ群を指す
        # 現在でも標準的に使用され、多くのパッケージがこの形式で定義されている
        # flakeのコンテキストではパフォーマンス面でも推奨される方法
        packages = nixpkgs.legacyPackages.${system};
      in
      {
      
        devShells = {
          default = import ./shells/shell.nix { inherit packages; };
          node = import ./environments/node/shell.nix { inherit packages; };
          deno = import ./environments/deno/shell.nix { inherit packages; };
          full = import ./environments/full/shell.nix { inherit packages; };
          cuda = import ./environments/cuda/shell.nix { inherit packages; };
          "cuda-pytorch" = import ./environments/cuda-pytorch/shell.nix { inherit packages; };
        };
      }
    );
}