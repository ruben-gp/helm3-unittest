#!/bin/bash -e

# borrowed from https://github.com/helm/helm-2to3/blob/master/scripts/install_plugin.sh

PROJECT_NAME="helm3-unittest"
PROJECT_GH="ruben-gp/${PROJECT_NAME}"
HELM_PLUGIN_PATH="${HELM_PLUGIN_DIR}"

# Convert the HELM_PLUGIN_PATH to unix if cygpath is
# available. This is the case when using MSYS2 or Cygwin
# on Windows where helm returns a Windows path but we
# need a Unix path
if type cygpath >/dev/null 2>&1; then
  echo Use Sygpath
  HELM_PLUGIN_PATH=$(cygpath -u "${HELM_PLUGIN_PATH}")
fi

if [ -n "${HELM_LINTER_PLUGIN_NO_INSTALL_HOOK}" ]; then
    echo "Development mode: not downloading versioned release."
    exit 0
fi

version="$(git describe --tags --exact-match 2>/dev/null)"
echo "Downloading and installing ${PROJECT_NAME} fork ${version} ..."

url="https://github.com/${PROJECT_GH}/"
url+="releases/download/${version}/${PROJECT_NAME}_${version#v}_linux_amd64.tar.gz"

echo "$url"

mkdir -p "releases/${version}"

# Download with curl if possible.
# shellcheck disable=SC2230
if [ -x "$(which curl 2>/dev/null)" ]; then
    curl -sSL "${url}" -o "releases/${version}.tar.gz"
else
    wget -q "${url}" -O "releases/${version}.tar.gz"
fi

echo "Preparing to install into ${HELM_PLUGIN_PATH}"
tar xzf "releases/${version}.tar.gz" -C "${HELM_PLUGIN_PATH}"
rm -rf "releases"
echo "${PROJECT_NAME} installed into ${HELM_PLUGIN_PATH}"
