#!/bin/bash

# This script is intended to automatic build an APK for release
# You can pass source folder or use current folder

APPSRC=$(pwd)

# If source folder is passed to the script use it as source folder
[ -z "$1" ] && APPSRC="$1"

APKPATH=$APPSRC/platforms/android/app/build/outputs/apk/release

if [[ "$(docker images -q cordova 2> /dev/null)" == "" ]]; then
    docker build -t cordova .
fi

CDV="docker run -ti --rm --privileged -v $APPSRC:/src cordova "

# Clean previous android platform
if [ -d $APPSRC/platforms/android ]; then
    $CDV cordova platform rm android
fi

# Install dependencies
$CDV npm install

$CDV cordova platform add android

# This FIX Whatsapp Intent on InAppBrowser:
$CDV sed -i 's/else if (url.startsWith("geo:") || url.startsWith(WebView.SCHEME_MAILTO) || url.startsWith("market:") || url.startsWith("intent:"))/else if (url.startsWith("geo:") || url.startsWith(WebView.SCHEME_MAILTO) || url.startsWith("market:") || url.startsWith("intent:") || url.startsWith("whatsapp:"))/g' platforms/android/app/src/main/java/org/apache/cordova/inappbrowser/InAppBrowser.java

# Build Release
$CDV cordova build --release

# Move APK to a release folder for signing
if [ -f $APKPATH/app-release-unsigned.apk ]
then
    mkdir -p $APPSRC/release
    cp $APKPATH/app-release-unsigned.apk $APPSRC/release
else
    exit 1
fi
