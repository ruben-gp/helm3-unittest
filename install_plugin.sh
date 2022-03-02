#!/bin/bash -e

# borrowed from https://github.com/helm/helm-2to3/blob/master/scripts/install_plugin.sh

if [ -n "${HELM_LINTER_PLUGIN_NO_INSTALL_HOOK}" ]; then
    echo "Development mode: not downloading versioned release."
    exit 0
fi

version="$(git describe --tags --exact-match 2>/dev/null)"
echo "Downloading and installing helm3-unittest ${version} ..."

url="https://github.com/ruben-gp/helm3-unittest/"
url+="releases/download/${version}/helm3-unittest_${version:1}_linux_amd64.tar.gz"

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
mv "releases/${version}/helm3-unittest" "bin/unittest"
mv "releases/${version}/helm-plugin.yaml" plugin.yaml
mv "releases/${version}/README.md" .
