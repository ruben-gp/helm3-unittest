#!/bin/sh
set -eu

cd "${GITHUB_WORKSPACE}"

if [ -n "${INPUT_DRY_RUN}" ]; then
    echo "Running in dry-run mode"
    DRY_RUN="-n"
else
    DRY_RUN=""
fi

version=$(/autotag --branch=${INPUT_BRANCH} --repo=${INPUT_REPO} --pre-release-name=${INPUT_PRE_RELEASE_NAME} --pre-release-timestamp=${INPUT_PRE_RELEASE_TIMESTAMP} ${DRY_RUN})

echo "version $version"

echo "::set-output name=version::$version"
