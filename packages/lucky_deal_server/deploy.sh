#!/bin/bash

set -eo pipefail

dart_frog build
cd build
sed -i '' 's/FROM scratch/FROM alpine:latest/' Dockerfile
heroku container:push web
heroku container:release web