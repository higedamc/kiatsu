#!/bin/sh

#  retrieve_dart_defines.sh
#  Runner
#
#  Created by Kohei Otani on 2022/03/07.
#  
# Dart-defineを書き込んだり、Flavorごとのxcconfigをincludeするファイル
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

# Flutter 2.2 以降で必要な、Dart-Definesのデコード処理
function decode_url() { echo "${*}" | base64 --decode; }

# 最初にファイル内容をいったん空にする
: > $OUTPUT_FILE

IFS=',' read -r -a define_items <<<"$DART_DEFINES"

for index in "${!define_items[@]}"
do
    # Flutter 2.2 以降で必要なデコードを実行する
    item=$(decode_url "${define_items[$index]}")
    # FLAVORが含まれるDart Defineの場合
    if [ $(echo $item | grep 'FLAVOR') ] ; then
        # FLAVORの値(=の右側)
        value=${item#*=}
        # FLAVORに対応したXCConfigファイルをincludeさせる
        echo "#include \"$value.xcconfig\"" >> $OUTPUT_FILE
    fi
#     define_items[$index]=$(decode_url "${define_items[$index]}");
done

# printf "%s\n" "${define_items[@]}" | grep -e '^' -e -e -e > $OUTPUT_FILE
