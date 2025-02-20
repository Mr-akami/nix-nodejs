https://zenn.dev/stmn_inc/articles/create-environment-to-nix-flake
この記事を参考につくった

- nix develop .#node と nix develop #node の違いは
  - . はローカルの flake.nix を指定

nix develop すると bash が開かれる。host の zsh を引き継ぎたいけどどうやるんだっけ。毎回やり方を忘れている。
