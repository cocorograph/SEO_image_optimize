# SEO_image_optimize
SEOなど、Web使用用途で画像最適化を行うための、Squoosh CLIを使った画像最適化スクリプトです
制作会社さんなどに有用かと思います。

本スクリプトでは下記のインストールが前提となっています。
- node.js
- squoosh-cli
- gtimeout

## インストール方法
### node.js
いわずもがな。
[https://nodejs.org/ja/download/](https://nodejs.org/ja/download/)

### squoosh-cli
squooshをcliで使えるようにするためのもの。
Terminal.appで下記を実行
`sudo npm i -g @squoosh/cli`

### gtimeout
bash で gtimeout (タイムアウト処理) が使えるようにするためのもの。
Terminal.appで下記を実行
`brew install coreutils`

上記インストールで準備完了！

## 実行方法（簡易）
1. 本スクリプトをダウンロード
2. ダウンロードしたcommanddファイルを、最適化したい画像が格納されたディレクトリに移動
3. ダブルクリックで実行

詳細はこちらの記事でも解説しています。
[SEOの画像最適化を一括で超簡単に行う方法【squoosh-cli】](https://cocorograph.co/knowledge/easy-to-optimize-images/)
