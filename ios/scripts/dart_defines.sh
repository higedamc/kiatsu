#!/bin/sh

#  dart_defines.sh
#  Runner
#
#  Created by Kohei Otani on 2022/03/07.
ITEMS=($(echo $DART_DEFINES | tr "," "\n"))

for ITEM in ${ITEMS[@]}; do
  DECODED_ITEM=$(echo $ITEM | base64 --decode)
  echo $DECODED_ITEM | grep "FLAVOR"
  if [ $? = 0 ]; then
    FLAVOR=${DECODED_ITEM#*=}
    break
  fi
done

if [ $FLAVOR = "dev" ]; then
  DISPLAY_NAME="kiatsu-dev"
  BUNDLE_IDENTIFIER="com.kiatsu.app-dev"
  ADMOB_IDENTIFIER="ca-app-pub-3940256099942544~1458002511"
  ADMOB_UNIT_ID="ca-app-pub-3940256099942544/2934735716"
  DART_DEFINE_MODE="Development"
  
else
  DISPLAY_NAME="kiatsu-dev"
  BUNDLE_IDENTIFIER="com.kiatsu.app-dev"
fi

INFO_PLIST_PATH="${TEMP_DIR}/Preprocessed-Info.plist"
PLIST_BUDDY="/usr/libexec/PlistBuddy"

$PLIST_BUDDY -c "Set :CFBundleDisplayName $DISPLAY_NAME" $INFO_PLIST_PATH
$PLIST_BUDDY -c "Set :CFBundleIdentifier $BUNDLE_IDENTIFIER" $INFO_PLIST_PATH
$PLIST_BUDDY -c "Set :ADMOB_IDENTIFIER $ADMOB_IDENTIFIER" $INFO_PLIST_PATH
$PLIST_BUDDY -c "Set :ADMOB_UNIT_ID $ADMOB_UNIT_ID" $INFO_PLIST_PATH
$PLIST_BUDDY -c "Set :DART_DEFINE_MODE $DART_DEFINE_MODE" $INFO_PLIST_PATH
