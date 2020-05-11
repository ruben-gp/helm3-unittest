#!/bin/sh -e

# borrowed from https://github.com/helm/helm-2to3/blob/master/scripts/install_plugin.sh

if [ -n "${HELM_LINTER_PLUGIN_NO_INSTALL_HOOK}" ]; then
    echo "Development mode: not downloading versioned release."
    exit 0
fi

version="$(git describe --tags --exact-match 2>/dev/null)"
echo "Downloading and installing helm3-unittest ${version} ..."

url=""
if [ "$(uname)" = "Darwin" ]; then
    url="https://github.com/vbehar/helm3-unittest/releases/download/${version}/helm3-unittest_${version:1}_darwin_amd64.tar.gz"
elif [ "$(uname)" = "Linux" ] ; then
    if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then
        url="https://github.com/vbehar/helm3-unittest/releases/download/${version}/helm3-unittest_${version:1}_linux_arm64.tar.gz"
    else
        url="https://github.com/vbehar/helm3-unittest/releases/download/${version}/helm3-unittest_${version:1}_linux_amd64.tar.gz"
    fi
else
    url="https://github.com/vbehar/helm3-unittest/releases/download/${version}/helm3-unittest_${version:1}_windows_amd64.tar.gz"
fi

echo "$url"

mkdir -p "bin"
mkdir -p "releases/${version}"

# Download with curl if possible.
# shellcheck disable=SC2230
if [ -x "$(which curl 2>/dev/null)" ]; then
    curl -sSL "${url}" -o "releases/${version}.tar.gz"
else
    wget -q "${url}" -O "releases/${version}.tar.gz"
fi
tar xzf "releases/${version}.tar.gz" -C "releases/${version}"
mv "releases/${version}/helm3-unittest" "bin/unittest" || \
    mv "releases/${version}/helm3-unittest.exe" "bin/unittest"
mv "releases/${version}/plugin.yaml" .
mv "releases/${version}/README.md" .
