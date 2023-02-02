#!/bin/sh

cat ${ANDROID_KEYSTORE} | base64 -d > android/my.jks
echo "storePassword=${ANDROID_KEYSTORE_PASSWORD}" > android/key.properties
echo "keyPassword=${ANDROID_KEY_PASSWORD}" >> android/key.properties
echo "keyAlias=${ANDROID_KEYSTORE_ALIAS}" >> android/key.properties
echo "storeFile=../my.jks" >> android/key.properties