# Synopce

Client app for using Download and Note Station from Synology
Synology is a trademark of Synology Inc.

## Build in release mode

You need add to Gitlab CI variables:

* `ANDROID_KEYSTORE` - base64 encode key file

* `ANDROID_KEY_PASSWORD`

* `ANDROID_KEYSTORE_ALIAS`

* `ANDROID_KEYSTORE_PASSWORD`

* `APPCENTER_API_TOKEN` - api token for project in App Center

* `PLAY_STORE_KEY` - api key from Play Store Console (for more read [Fastlane setup](https://docs.fastlane.tools/getting-started/android/setup/))
