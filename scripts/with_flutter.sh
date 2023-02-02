#!/bin/sh

export PUB_CACHE=$CI_PROJECT_DIR/.pub-cache
export PATH="$PATH":"$PUB_CACHE/bin"
flutter packages get
flutter clean