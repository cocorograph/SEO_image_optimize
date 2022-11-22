#!/bin/bash

# 一括処理を行う上限ファイル数（拡張子毎）
maxfilenum=500
#タイムアウトの時間設定
single_timeo_sec=5

# 実行ディレクトリへ移動
cd `dirname $0`

# 処理を選択
PS3='処理を数字で選択してください。'
select num in "jpg・pngを圧縮しwebp生成" "jpg・pngを圧縮のみ" "キャンセル"
# @TODO 追加で圧縮の強さを3段階くらいで設定できるようにしたい
do
  case $num in
    "jpg・pngを圧縮しwebp生成")
        # ディレクトリ一覧取得
        dirlist=($(find . -mindepth 1 -type d -name \*))

        # ディレクトリ毎に処理を行うため、変数dirlistを配列で処理
        for filedir in "${dirlist[@]}";
        do
            # jpgファイルの個数を確認
            count_img=($(find ${filedir} -maxdepth 1 -type f -name \*.jpg | wc -l))
            if [ $count_img = 0 ] ; then
                :
            # ファイル個数がmaxfilenum以上だったら
            elif [ $count_img -gt $maxfilenum ] ; then

                # jpgファイル名一覧を取得し、個別に処理
                echo -e '\n##############################################################\n'${filedir}'のjpg最適化・webp変換を個別処理します。（'${count_img}'ファイル）'
                filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.jpg | sort -n))
                i=${count_img}
                for convert_img in "${filelist[@]}";
                do
                    gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ${filedir}/ ${convert_img}
                    if [ $? != 0 ]; then
                      echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                    fi
                    gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ${filedir}/ ${convert_img}
                    if [ $? != 0 ]; then
                      echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                    fi
                    i=$(($i - 1))
                    echo '残り'${i}'ファイル'
                done
                echo -e '\n'${filedir}'のjpg最適化・webp変換完了。\n'

            else

                # ファイル個数がmaxfilenum以下だったらjpg一括処理
                echo -e '\n##############################################################\n'${filedir}'のjpg最適化・webp変換を一括処理します。（'${count_img}'ファイル）'
                i=$((${count_img}*1))
                gtimeout -sKILL $i squoosh-cli --mozjpeg '{}' -d ${filedir}/ ${filedir}/*.jpg
                if [ $? != 0 ]; then
                  echo -e '\n'${filedir}' のjpg最適化およびwebp変換はタイムアウトのため、個別変換に切り替えます。'

                  filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.jpg | sort -n))
                  i=${count_img}
                  for convert_img in "${filelist[@]}";
                  do
                      gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ${filedir}/ ${convert_img}
                      if [ $? != 0 ]; then
                        echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                      fi
                      gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ${filedir}/ ${convert_img}
                      if [ $? != 0 ]; then
                        echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                      fi
                      i=$(($i - 1))
                      echo '残り'${i}'ファイル'
                  done
                  echo -e '\n'${filedir}'のjpg最適化・webp変換完了。\n'

                else
                  gtimeout -sKILL $i squoosh-cli --webp '{}' -d ${filedir}/ ${filedir}/*.jpg
                  if [ $? != 0 ]; then
                    echo -e '\n'${filedir}' のjpgファイルのwebp変換は、タイムアウトのため途中スキップしました。'
                  else
                    echo -e '\n'${filedir}'のjpg最適化・webp変換完了。\n'
                  fi
                fi
            fi

            count_img=($(find ${filedir} -maxdepth 1 -type f -name \*.png | wc -l))
            if [ $count_img = 0 ] ; then
                :
            # ファイル個数がmaxfilenum以上だったら
            elif [ $count_img -gt $maxfilenum ] ; then

                # pngファイル名一覧を取得し、個別に処理
                echo -e '\n##############################################################\n'${filedir}'のpng最適化・webp変換を個別処理します。（'${count_img}'ファイル）'
                filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.png | sort -n))
                i=${count_img}
                for convert_img in "${filelist[@]}";
                do
                    gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ${filedir}/ ${convert_img}
                    if [ $? != 0 ]; then
                      echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                    fi
                    gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ${filedir}/ ${convert_img}
                    if [ $? != 0 ]; then
                      echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                    fi
                    i=$(($i - 1))
                    echo '残り'${i}'ファイル'
                done
                echo -e '\n'${filedir}'のpng最適化・webp変換完了。\n'

            else

                # ファイル個数がmaxfilenum以下だったらpng一括処理
                echo -e '\n##############################################################\n'${filedir}'のpng最適化・webp変換を一括処理します。（'${count_img}'ファイル）'
                i=$((${count_img}*1))
                gtimeout -sKILL $i squoosh-cli --oxipng '{}' -d ${filedir}/ ${filedir}/*.png
                if [ $? != 0 ]; then
                  echo -e '\n'${filedir}' のpng最適化およびwebp変換はタイムアウトのため、個別変換に切り替えます。'

                  filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.png | sort -n))
                  i=${count_img}
                  for convert_img in "${filelist[@]}";
                  do
                      gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ${filedir}/ ${convert_img}
                      if [ $? != 0 ]; then
                        echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                      fi
                      gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ${filedir}/ ${convert_img}
                      if [ $? != 0 ]; then
                        echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                      fi
                      i=$(($i - 1))
                      echo '残り'${i}'ファイル'
                  done
                  echo -e '\n'${filedir}'のpng最適化・webp変換完了。\n'

                else
                  gtimeout -sKILL $i squoosh-cli --webp '{}' -d ${filedir}/ ${filedir}/*.png
                  if [ $? != 0 ]; then
                    echo -e '\n'${filedir}' のpngファイルのwebp変換は、タイムアウトのため途中スキップしました。'
                  else
                    echo -e '\n'${filedir}'のpng最適化・webp変換完了。\n'
                  fi
                fi
            fi

        done

        # カレントディレクトリのjpgファイルの個数を確認
        count_img=($(find . -maxdepth 1 -type f -name \*.jpg | wc -l))
        if [ $count_img = 0 ] ; then
            :
        # ファイル個数がmaxfilenum以上だったら
        elif [ $count_img -gt $maxfilenum ] ; then

            # jpgファイル名一覧を取得し、個別に処理
            echo -e '\n##############################################################\n./のjpg最適化・webp変換を個別処理します。（'${count_img}'ファイル）'
            filelist=($(find . -maxdepth 1 -type f -name \*.jpg | sort -n))
            i=${count_img}
            for convert_img in "${filelist[@]}";
            do
                gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ./ ${convert_img}
                if [ $? != 0 ]; then
                  # タイムアウトしたときの処理
                  echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                fi
                gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ./ ${convert_img}
                if [ $? != 0 ]; then
                  # タイムアウトしたときの処理
                  echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                fi
                i=$(($i - 1))
                echo '残り'${i}'ファイル'
            done
            echo -e '\n./のjpg最適化・webp変換完了。\n'

        else

            # ファイル個数がmaxfilenum以下だったらjpg一括処理
            echo -e '\n##############################################################\n'${filedir}'のjpg最適化・webp変換を一括処理します。（'${count_img}'ファイル）'
            i=$((${count_img}*1))
            gtimeout -sKILL $i squoosh-cli --mozjpeg '{}' -d ./ ./*.jpg
            if [ $? != 0 ]; then
              echo -e '/.のjpg最適化およびwebp変換はタイムアウトのため、個別変換に切り替えます。'

              filelist=($(find . -maxdepth 1 -type f -name \*.jpg | sort -n))
              i=${count_img}
              for convert_img in "${filelist[@]}";
              do
                  gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ./ ${convert_img}
                  if [ $? != 0 ]; then
                    # タイムアウトしたときの処理
                    echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                  fi
                  gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ./ ${convert_img}
                  if [ $? != 0 ]; then
                    # タイムアウトしたときの処理
                    echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                  fi
                  i=$(($i - 1))
                  echo '残り'${i}'ファイル'
              done
              echo -e '\n./のjpg最適化・webp変換完了。\n'

            else
              gtimeout -sKILL $i squoosh-cli --webp '{}' -d ./ ./*.jpg
              if [ $? != 0 ]; then
                echo -e '/.のjpgファイルのwebp変換は、タイムアウトのため途中スキップしました。'
              else
                echo -e '\n./のjpg最適化・webp変換完了。\n'
              fi
            fi
        fi

        # カレントディレクトリのpngファイルの個数を確認
        count_img=($(find . -maxdepth 1 -type f -name \*.png | wc -l))
        if [ $count_img = 0 ] ; then
            :
        # ファイル個数がmaxfilenum以上だったら
        elif [ $count_img -gt $maxfilenum ] ; then

            # pngファイル名一覧を取得し、個別に処理
            echo -e '\n##############################################################\n./のjpg最適化・webp変換を個別処理します。（'${count_img}'ファイル）'
            filelist=($(find . -maxdepth 1 -type f -name \*.png | sort -n))
            i=${count_img}
            for convert_img in "${filelist[@]}";
            do
                gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ./ ${convert_img}
                if [ $? != 0 ]; then
                  # タイムアウトしたときの処理
                  echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                fi
                gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ./ ${convert_img}
                if [ $? != 0 ]; then
                  # タイムアウトしたときの処理
                  echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                fi
                i=$(($i - 1))
                echo '残り'${i}'ファイル'
            done
            echo -e '\n./のpng最適化・webp変換完了。\n'

        else

            # ファイル個数がmaxfilenum以下だったらpng一括処理
            echo -e '\n##############################################################\n'${filedir}'のjpg最適化・webp変換を一括処理します。（'${count_img}'ファイル）'
            i=$((${count_img}*1))
            gtimeout -sKILL $i squoosh-cli --oxipng '{}' -d ./ ./*.png
            if [ $? != 0 ]; then
              echo -e '/.のpng最適化およびwebp変換タイムアウトのため、個別変換に切り替えます。'

              filelist=($(find . -maxdepth 1 -type f -name \*.png | sort -n))
              i=${count_img}
              for convert_img in "${filelist[@]}";
              do
                  gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ./ ${convert_img}
                  if [ $? != 0 ]; then
                    # タイムアウトしたときの処理
                    echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                  fi
                  gtimeout -sKILL ${single_timeo_sec} squoosh-cli --webp '{}' -d ./ ${convert_img}
                  if [ $? != 0 ]; then
                    # タイムアウトしたときの処理
                    echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                  fi
                  i=$(($i - 1))
                  echo '残り'${i}'ファイル'
              done
              echo -e '\n./のpng最適化・webp変換完了。\n'

            else
              gtimeout -sKILL $i squoosh-cli --webp '{}' -d ./ ./*.png
              if [ $? != 0 ]; then
                echo -e '/.のpngファイルのwebp変換は、タイムアウトのため途中スキップしました。'
              else
                echo -e '\n./のpng最適化・webp変換完了。\n'
              fi
            fi
        fi

        break;;
    "jpg・pngを圧縮のみ")
        # ディレクトリ一覧取得
        dirlist=($(find . -mindepth 1 -type d -name \*))

        # ディレクトリ毎に処理を行うため、変数dirlistを配列で処理
        for filedir in "${dirlist[@]}";
        do
            # jpgファイルの個数を確認
            count_img=($(find ${filedir} -maxdepth 1 -type f -name \*.jpg | wc -l))
            if [ $count_img = 0 ] ; then
                :
            # ファイル個数がmaxfilenum以上だったら
            elif [ $count_img -gt $maxfilenum ] ; then

                # jpgファイル名一覧を取得し、個別に処理
                echo -e '\n##############################################################\n'${filedir}'のjpg最適化を個別処理します。（'${count_img}'ファイル）'
                filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.jpg | sort -n))
                i=${count_img}
                for convert_img in "${filelist[@]}";
                do
                    gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ${filedir}/ ${convert_img}
                    if [ $? != 0 ]; then
                      # タイムアウトしたときの処理
                      echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                    fi
                    i=$(($i - 1))
                    echo '残り'${i}'ファイル'
                done
                echo -e '\n'${filedir}'のjpg最適化完了。\n'

            else

                # ファイル個数がmaxfilenum以下だったらjpg一括処理
                echo -e '\n##############################################################\n'${filedir}'のjpg最適化を一括処理します。（'${count_img}'ファイル）'
                i=$((${count_img}*1))
                gtimeout -sKILL $i squoosh-cli --mozjpeg '{}' -d ${filedir}/ ${filedir}/*.jpg
                if [ $? != 0 ]; then
                  echo -e '\n'${filedir}' のjpg最適化はタイムアウトのため、個別変換に切り替えます。'

                  filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.jpg | sort -n))
                  i=${count_img}
                  for convert_img in "${filelist[@]}";
                  do
                      gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ${filedir}/ ${convert_img}
                      if [ $? != 0 ]; then
                        # タイムアウトしたときの処理
                        echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                      fi
                      i=$(($i - 1))
                      echo '残り'${i}'ファイル'
                  done
                  echo -e '\n'${filedir}'のjpg最適化完了。\n'

                else
                  echo -e '\n'${filedir}'のjpg最適化完了。\n'
                fi
            fi

            count_img=($(find ${filedir} -maxdepth 1 -type f -name \*.png | wc -l))
            if [ $count_img = 0 ] ; then
                :
            # ファイル個数がmaxfilenum以上だったら
            elif [ $count_img -gt $maxfilenum ] ; then

                # pngファイル名一覧を取得し、個別に処理
                echo -e '\n##############################################################\n'${filedir}'のpng最適化を個別処理します。（'${count_img}'ファイル）'
                filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.png | sort -n))
                i=${count_img}
                for convert_img in "${filelist[@]}";
                do
                    gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ${filedir}/ ${convert_img}
                    if [ $? != 0 ]; then
                      # タイムアウトしたときの処理
                      echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                    fi
                    i=$(($i - 1))
                    echo '残り'${i}'ファイル'
                done
                echo -e '\n'${filedir}'のpng最適化完了。\n'

            else

                # ファイル個数がmaxfilenum以下だったらpng一括処理
                echo -e '\n##############################################################\n'${filedir}'のpng最適化を一括処理します。（'${count_img}'ファイル）'
                i=$((${count_img}*1))
                gtimeout -sKILL $i squoosh-cli --oxipng '{}' -d ${filedir}/ ${filedir}/*.png
                if [ $? != 0 ]; then
                  echo -e '\n'${filedir}' のpng最適化はタイムアウトのため、個別変換に切り替えます。'

                  filelist=($(find ${filedir} -maxdepth 1 -type f -name \*.png | sort -n))
                  i=${count_img}
                  for convert_img in "${filelist[@]}";
                  do
                      gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ${filedir}/ ${convert_img}
                      if [ $? != 0 ]; then
                        # タイムアウトしたときの処理
                        echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                      fi
                      i=$(($i - 1))
                      echo '残り'${i}'ファイル'
                  done
                  echo -e '\n'${filedir}'のpng最適化完了。\n'

                else
                  echo -e '\n'${filedir}'のpng最適化完了。\n'
                fi
            fi
        done

        # カレントディレクトリのjpgファイルの個数を確認
        count_img=($(find . -maxdepth 1 -type f -name \*.jpg | wc -l))
        if [ $count_img = 0 ] ; then
            :
        # ファイル個数がmaxfilenum以上だったら
        elif [ $count_img -gt $maxfilenum ] ; then

            # jpgファイル名一覧を取得し、個別に処理
            echo -e '\n##############################################################\n./のjpg最適化・webp変換を個別処理します。（'${count_img}'ファイル）'
            filelist=($(find . -maxdepth 1 -type f -name \*.jpg | sort -n))
            i=${count_img}
            for convert_img in "${filelist[@]}";
            do
                gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ./ ${convert_img}
                if [ $? != 0 ]; then
                  # タイムアウトしたときの処理
                  echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                fi
                i=$(($i - 1))
                echo '残り'${i}'ファイル'
            done
            echo -e '\n./のjpg最適化完了。\n'

        else

            # ファイル個数がmaxfilenum以下だったらjpg一括処理
            echo -e '\n##############################################################\n'${filedir}'のjpg最適化・webp変換を一括処理します。（'${count_img}'ファイル）'
            i=$((${count_img}*1))
            gtimeout -sKILL $i squoosh-cli --mozjpeg '{}' -d ./ ./*.jpg
            if [ $? != 0 ]; then
              echo -e '/.のjpg最適化はタイムアウトのため、個別変換に切り替えます。'

              filelist=($(find . -maxdepth 1 -type f -name \*.jpg | sort -n))
              i=${count_img}
              for convert_img in "${filelist[@]}";
              do
                  gtimeout -sKILL ${single_timeo_sec} squoosh-cli --mozjpeg '{}' -d ./ ${convert_img}
                  if [ $? != 0 ]; then
                    # タイムアウトしたときの処理
                    echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                  fi
                  i=$(($i - 1))
                  echo '残り'${i}'ファイル'
              done
              echo -e '\n./のjpg最適化完了。\n'

            else
              echo -e '\n./のjpg最適化完了。\n'
            fi
        fi

        # カレントディレクトリのpngファイルの個数を確認
        count_img=($(find . -maxdepth 1 -type f -name \*.png | wc -l))
        if [ $count_img = 0 ] ; then
            :
        # ファイル個数がmaxfilenum以上だったら
        elif [ $count_img -gt $maxfilenum ] ; then

            # pngファイル名一覧を取得し、個別に処理
            echo -e '\n##############################################################\n./のjpg最適化・webp変換を個別処理します。（'${count_img}'ファイル）'
            filelist=($(find . -maxdepth 1 -type f -name \*.png | sort -n))
            i=${count_img}
            for convert_img in "${filelist[@]}";
            do
                gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ./ ${convert_img}
                if [ $? != 0 ]; then
                  # タイムアウトしたときの処理
                  echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                fi
                i=$(($i - 1))
                echo '残り'${i}'ファイル'
            done
            echo -e '\n./のpng最適化完了。\n'

        else

            # ファイル個数がmaxfilenum以下だったらpng一括処理
            echo -e '\n##############################################################\n'${filedir}'のjpg最適化・webp変換を一括処理します。（'${count_img}'ファイル）'
            i=$((${count_img}*1))
            gtimeout -sKILL $i squoosh-cli --oxipng '{}' -d ./ ./*.png
            if [ $? != 0 ]; then
              echo -e 'カレントディレクトリのpng最適化はタイムアウトのため、個別変換に切り替えます。'

              filelist=($(find . -maxdepth 1 -type f -name \*.png | sort -n))
              i=${count_img}
              for convert_img in "${filelist[@]}";
              do
                  gtimeout -sKILL ${single_timeo_sec} squoosh-cli --oxipng '{}' -d ./ ${convert_img}
                  if [ $? != 0 ]; then
                    # タイムアウトしたときの処理
                    echo -e '\n'${convert_img}' は、タイムアウトのためスキップしました。'
                  fi
                  i=$(($i - 1))
                  echo '残り'${i}'ファイル'
              done
              echo -e '\n./のpng最適化完了。\n'

            else
              echo -e '\n./のpng最適化完了。\n'
            fi
        fi

        break;;
    "キャンセル")
      echo '処理をキャンセルしました。'
      break;;
    *)
      echo '入力エラー。1〜3の数字で再度入力してください。';;
  esac
done
# killall Terminal