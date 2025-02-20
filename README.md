# Nix開発環境

このリポジトリは、Nixを使用して再現性のある開発環境を提供します。

## 環境のセットアップ

### 前提条件

- Nixがインストールされていること
- flakesが有効化されていること

### 利用可能な開発環境

1. Node.js環境
```bash
# ローカルのflake.nixを使用してNode.js環境を起動
nix develop .#node
```

2. Deno環境
```bash
# ローカルのflake.nixを使用してDeno環境を起動
nix develop .#deno
```

3. 統合環境（Node.js + Deno）
```bash
# ローカルのflake.nixを使用して統合環境を起動
nix develop .#full
```

## 環境の詳細

### Deno環境 (v2.2.0)

`environments/deno/shell.nix`で定義された環境には以下が含まれています：

- Deno v2.2.0
- pnpm（Node.jsパッケージマネージャー）
- その他基本的な開発ツール

### Node.js環境

`environments/node/shell.nix`で定義された環境には以下が含まれています：

- Node.js v22
- pnpm（Node.jsパッケージマネージャー）
- その他基本的な開発ツール

### 統合環境

`environments/full/shell.nix`で定義された環境には以下が含まれています：

- Deno v2.2.0
- Node.js v22
- pnpm（Node.jsパッケージマネージャー）
- その他基本的な開発ツール

この環境は、DenoとNode.jsの両方の機能を必要とするプロジェクトに最適です。

#### バージョンの更新方法

Denoのバージョンを更新する場合は以下の手順で行います：

1. 新しいバイナリのハッシュ値を取得：
```bash
nix-prefetch-url https://github.com/denoland/deno/releases/download/v{新しいバージョン}/deno-x86_64-unknown-linux-gnu.zip
```

2. `environments/deno/shell.nix`の以下の値を更新：
   - `version = "{新しいバージョン}";`
   - `sha256 = "取得したハッシュ値";`

3. キャッシュをクリアして再ビルド：
```bash
nix store gc
nix develop .#deno
```

## 注意点

- `.`はローカルの`flake.nix`を指定するために使用します
- `nix develop`を実行するとデフォルトでbashが開きます
- キャッシュに問題がある場合は`nix store gc`でクリアできます

## 参考

- [Nixでの開発環境構築](https://zenn.dev/stmn_inc/articles/create-environment-to-nix-flake)

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
