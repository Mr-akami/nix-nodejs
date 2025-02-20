{
  description = "Development environments managed with Nix";

  inputs = {
    # 公式リポジトリからパッケージをインストールします
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixのflakeで便利なユーティリティ関数を提供するライブラリ 
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
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
        packages = {
          default = packages.deno;  # ここに `defaultPackage` を追加
        };
      
        devShells = {
          default = import ./shells/shell.nix { inherit packages; };
          node = import ./environments/node/shell.nix { inherit packages; };
          deno = import ./environments/deno/shell.nix { inherit packages; };
          full = import ./environments/full/shell.nix { inherit packages; };
        };
      }
    );
}