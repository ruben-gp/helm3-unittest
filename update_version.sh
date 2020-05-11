#!/bin/bash

# script used by goreleaser - see .goreleaser.yml

version="$(git describe --tags --exact-match 2>/dev/null)"
cp plugin.tmpl plugin.yaml
echo "version: ${version:1}" >> plugin.yaml
