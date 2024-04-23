# SEO_image_optimize

SEOなど、Web使用用途で画像最適化を行うための、sharpを使った画像最適化スクリプトです。
v2になって、sqoosh-cliからsharpでの変換に変更しています。
制作会社さんなどに有用かと思います。

本スクリプトではNode.jsのインストールが前提となっています。


## Node.jsインストール方法

[https://nodejs.org/ja/download/](https://nodejs.org/ja/download/)


## 使い方

SEO_image_optimize.command が本体です。
SEO_image_optimize.command と同一ディレクトリに、変換前、変換済フォルダが必要です。
変換前フォルダに、圧縮したい画像を入れて、SEO_image_optimize.commandをダブルクリックして実行してください。
変換前フォルダに格納されているディレクトリ構成どおりに、変換済フォルダに画像が格納されます。

権限不足で実行できない場合は、ターミナルで以下のコマンドで権限を付与してから再度実行してください。

```
chmod +x 変換実行.command
```
