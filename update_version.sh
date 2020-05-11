#!/bin/sh

# script used by goreleaser - see .goreleaser.yml

cp plugin.tmpl plugin.yaml
echo "version: $1" >> plugin.yaml
