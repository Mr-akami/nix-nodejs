https://zenn.dev/stmn_inc/articles/create-environment-to-nix-flake
この記事を参考につくった

- nix develop .#node と nix develop #node の違いは
  - . はローカルの flake.nix を指定

nix develop すると bash が開かれる。host の zsh を引き継ぎたいけどどうやるんだっけ。毎回やり方を忘れている。

sha256 の取得

1. nix-prefetch-url --unpack https://github.com/denoland/deno/releases/download/v2.2.0/deno-x86_64-unknown-linux-gnu.zip
2. SRI 形式にする
   nix hash to-sri --type sha256 13asw18wvi33lh1cqx79d24rrx839mfb23y8pv0dhy7qd1npb01a

ビルドを失敗しても SRI が出るので上記は必要ない
