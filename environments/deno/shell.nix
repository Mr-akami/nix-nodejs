# nixpkgsをインポートするための基本的な関数定義
# packagesパラメータが指定されていない場合は、システムのnixpkgsを使用
{ packages ? import <nixpkgs> {} }:

let
  # 基本的な開発環境の設定をインポート
  # inheritキーワードは、現在のスコープからpackagesを渡すための簡潔な書き方
  baseShell = import ../../shells/shell.nix { inherit packages; };

  # Denoの実行環境を定義
  # stdenv.mkDerivationは、Nixパッケージをビルドするための基本的な関数
  denoLatest = packages.stdenv.mkDerivation rec {
    # パッケージ名を定義
    pname = "deno";
    # バージョンを指定（recキーワードにより、この値は下部で${version}として参照可能）
    version = "2.2.0";

    # ソースコードの取得設定
    # fetchurlは、指定されたURLからファイルをダウンロードする関数
    src = packages.fetchurl {
      # ダウンロードするバイナリのURL
      url = "https://github.com/denoland/deno/releases/download/v${version}/deno-x86_64-unknown-linux-gnu.zip";
      # ファイルの整合性を確認するためのハッシュ値
      # nix-prefetch-urlコマンドで取得可能
      sha256 = "0fsvgars9dmxiw1ril151djhg63rwf8r38haz1qzqkjrbcjbh6ir";
    };

    # ビルドに必要なツール（この場合はzipファイルの解凍に必要なunzip）
    nativeBuildInputs = [ packages.unzip ];

    # ソースの展開フェーズの定義
    # ''で囲まれた部分はシェルスクリプトとして実行される
    unpackPhase = ''
      # バイナリを配置するディレクトリを作成
      mkdir -p $out/bin
      # zipファイルを解凍
      unzip $src -d $out/bin
      # バイナリに実行権限を付与
      chmod +x $out/bin/deno
    '';

    # インストールフェーズの定義
    installPhase = ''
      # インストール完了メッセージを表示
      echo "Deno installed at $out/bin/deno"
    '';
  };
in
# 開発シェル環境の定義
packages.mkShell {
  # 環境で利用可能にするパッケージのリスト
  # baseShellのbuildInputsに、Denoとpnpmを追加
  buildInputs = baseShell.buildInputs ++ [
    denoLatest
    packages.nodePackages.pnpm
  ];

  # シェルが起動したときに実行されるスクリプト
  shellHook = ''
    # 基本的な開発環境のシェルフックを実行
    ${baseShell.shellHook}
    # 環境情報を表示
    echo "Deno development environment activated"
    echo "Deno version: $(deno --version)"
    echo "pnpm version: $(pnpm --version)" 
  '';
}
