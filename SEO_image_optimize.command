#!/bin/bash
source ~/.nvm/nvm.sh
#MY_DIRNAME=$(dirname $0)
MY_DIRNAME=$(cd $(dirname $0);pwd)
cd $MY_DIRNAME

echo "環境構築を開始します..."
echo ""

# brewがインストールされているか確認
if ! command -v brew &> /dev/null
then
    echo "brewがインストールされていません。"
    read -p "brewをインストールしますか？ (y/n): " install_brew
    if [ "$install_brew" = "y" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
else
    echo "brewとインストールされているパッケージを更新します。"
    brew update
    brew upgrade
fi

echo "brew確認完了..."
echo ""

if ! command -v nvm &> /dev/null
then
    echo "nvmがインストールされていません。"
    read -p "nvmをインストールしますか？ (y/n): " install_nvm
    if [ "$install_nvm" = "y" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        if [ -f ~/.bash_profile ]; then
            source ~/.bash_profile
        elif [ -f ~/.zshrc ]; then
            source ~/.zshrc
        fi
    fi
else
    echo "インストールされているnodeのバージョンを確認します。"
    if ! node --version | grep v21.7.3 &> /dev/null
    then
        echo "nodeのバージョンが21.7.3ではありませんので、インストールして切り替えます。"
        nvm install stable --latest-npm
        nvm alias default stable
        echo "nodeをstableバージョンに切り替えました。"
    fi
      echo "node確認完了..."
      echo ""
fi

# package.json を作成
cat <<EOF >package.json
{
  "name": "image-format-converter",
  "version": "2.0.0",
  "license": "UNLICENSED",
  "private": true,
  "scripts": {
    "image-format-converter": "node ./image-format-converter.js"
  },
  "type": "module",
  "devDependencies": {
    "ansi-colors": "^4.1.3",
    "fancy-log": "^2.0.0",
    "globule": "^1.3.4",
    "sharp": "^0.33.3"
  }
}
EOF

echo "package.jsonを作成しました。"

# image-format-converter.js を作成
cat <<'EOF' >image-format-converter.js
import c from 'ansi-colors'
import log from 'fancy-log'
import fs from 'fs'
import globule from 'globule'
import sharp from 'sharp'

class ImageFormatConverter {
  constructor(options = {}) {
    this.srcBase = options.srcBase || '変換前'
    this.destBase = options.destBase || '変換済'
    this.includeExtensionName = options.includeExtensionName || false
    this.formats = options.formats || [
      // {
      //   type: 'avif',
      //   quality: 50
      // },
      {
        type: 'webp',
        quality: 50
      },
      {
        type: 'jpg',
        quality: 50
      },
      {
        type: 'png',
        quality: 50
      }
    ]
    this.srcImages = `${this.srcBase}/**/*.{jpg,jpeg,png,webp,avif,gif,svg}`
    this.init()
  }

  init = async () => {
    const imagePathList = this.findImagePaths()
    await this.convertImages(imagePathList)
  }

  /**
   * globパターンで指定した画像パスを配列化して返す
   * @return { array } 画像パスの配列
   */
  findImagePaths = () => {
    return globule.find({
      src: [this.srcImages]
    })
  }

  /**
   * 画像を変換する
   * @param { string } imagePath 画像パス
   * @param { object } format 画像形式と圧縮品質
   */

  convertImageFormat = async (imagePath, format) => {
    const reg = /\/(.*)\.(jpe?g|png|webp|avif|gif|svg)$/i
    const [, imageName, imageExtension] = imagePath.match(reg)
    const imageFileName = this.includeExtensionName
      ? `${imageName}.${imageExtension}`
      : imageName
    const destPath = `${this.destBase}/${imageFileName}.${format.type}`

    // 画像がJPEG形式であるかをチェック
    if (imageExtension.toLowerCase() === 'jpg' || imageExtension.toLowerCase() === 'jpeg') {
      // 画像がJPEG形式である場合、かつformat.typeが'jpg'または'webp'である場合のみ変換を行う
      if (format.type.toLowerCase() === 'jpg' || format.type.toLowerCase() === 'webp') {
        await sharp(imagePath)
        .toFormat(format.type, { quality: format.quality })
        .toFile(destPath)
        .then((info) => {
          log(
            `成功 ${c.blue(imagePath)} → ${c.yellow(
              format.type.toUpperCase()
            )} ${c.green(destPath)}`
          )
        })
        .catch((err) => {
          log(
            c.red(
              `エラー ${c.yellow(
                format.type.toUpperCase()
              )} ${c.red(destPath)}\n${err}`
            )
          )
        })
      }
    } else if (imageExtension.toLowerCase() === 'png') {
      // 画像がPNG形式である場合、かつformat.typeが'png'または'webp'である場合のみ変換を行う
      if (format.type.toLowerCase() === 'png' || format.type.toLowerCase() === 'webp') {
        await sharp(imagePath)
        .toFormat(format.type, { quality: format.quality })
        .toFile(destPath)
        .then((info) => {
          log(
            `成功 ${c.blue(imagePath)} → ${c.yellow(
              format.type.toUpperCase()
            )} ${c.green(destPath)}`
          )
        })
        .catch((err) => {
          log(
            c.red(
              `エラー ${c.yellow(
                format.type.toUpperCase()
              )} ${c.red(destPath)}\n${err}`
            )
          )
        })
      }
    } else if (format.type.toLowerCase() === 'webp') {
      // 画像がJPEG形式でもPNG形式でもない場合、かつformat.typeが'webp'である場合のみ変換を行う
      if (format.type.toLowerCase() === 'webp') {
        await sharp(imagePath)
        .toFormat(format.type, { quality: format.quality })
        .toFile(destPath)
        .then((info) => {
          log(
            `成功 ${c.blue(imagePath)} → ${c.yellow(
              format.type.toUpperCase()
            )} ${c.green(destPath)}`
          )
        })
        .catch((err) => {
          log(
            c.red(
              `エラー ${c.yellow(
                format.type.toUpperCase()
              )} ${c.red(destPath)}\n${err}`
            )
          )
        })
      }
    } else if (format.type.toLowerCase() === 'avif' || format.type.toLowerCase() === 'gif' || format.type.toLowerCase() === 'svg') {
      // 画像がJPEG形式でもPNG形式でもないが、format.typeが'webp'でない場合は、その旨をログに出力
      fs.copyFileSync(imagePath, destPath)
      log(`変換対象外: ${c.blue(imagePath)}`)
    } else {
      // なにもしない
    }
  }

  /**
   * 配列内の画像パスのファイルを変換する
   * @param { array } imagePathList 画像パスの配列
   */
  convertImages = async (imagePathList) => {
    if (imagePathList.length === 0) {
      log(c.red('No images found to convert'))
      return
    }
    for (const imagePath of imagePathList) {
      const reg = new RegExp(`^${this.srcBase}/(.*/)?`)
      const path = imagePath.match(reg)[1] || ''
      const destDir = `${this.destBase}/${path}`
      if (!fs.existsSync(destDir)) {
        try {
          fs.mkdirSync(destDir, { recursive: true })
          log(`Created directory ${c.green(destDir)}`)
        } catch (err) {
          log(`Failed to create directory ${c.green(destDir)}\n${err}`)
        }
      }
      const conversionPromises = this.formats.map((format) =>
        this.convertImageFormat(imagePath, format)
      )
      await Promise.all(conversionPromises)
    }
  }
}
const imageFormatConverter = new ImageFormatConverter()
EOF

echo "image-format-converter.jsを作成しました。"

# 依存関係をインストール
echo "依存関係をインストールします..."
npm i ansi-colors fancy-log globule sharp -D
echo "依存関係をインストールしました..."
echo ""

# スクリプトを実行
echo "画像変換処理を開始します..."
npm run image-format-converter
echo "画像変換処理を完了しました..."
echo ""

# クリーンアップ
echo "クリーンアップを開始します..."
rm -rf node_modules package-lock.json package.json image-format-converter.js

echo "処理が終了しました。"
