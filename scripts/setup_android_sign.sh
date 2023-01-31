#!/bin/sh

echo -n ${ANDROID_KEYSTORE} | base64 -d > android/my.jks
cat android/my.jks
echo "storePassword=${ANDROID_KEYSTORE_PASSWORD}" >> android/signing.properties
echo "keyPassword=${ANDROID_KEY_PASSWORD}" >> android/signing.properties
echo "keyAlias=${ANDROID_KEYSTORE_ALIAS}" >> android/signing.properties
echo "storeFile=android/my.jks" > android/signing.properties