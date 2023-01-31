#!/bin/sh

echo Set version to ${CI_COMMIT_TAG}
sed -ir "s/^version:.*/version:\ ${CI_COMMIT_TAG}/g" pubspec.yaml