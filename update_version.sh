#!/bin/bash

# script used by goreleaser - see .goreleaser.yml

version="$(git describe --tags --exact-match 2>/dev/null)"
echo "version: ${version:1}" >> plugin.yaml
