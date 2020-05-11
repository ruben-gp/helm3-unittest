#!/bin/bash

# script used by goreleaser - see .goreleaser.yml

version="$(git describe --tags --exact-match 2>/dev/null)"
cp plugin.yaml helm-plugin.yaml
echo "version: ${version:1}" >> helm-plugin.yaml
