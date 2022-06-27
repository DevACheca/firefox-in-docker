#!/usr/bin/env bash

set -x

REPOSITORY="ghcr.io/eficode-academy/find"
GIT_TAG=$(git rev-parse HEAD)
TAG="release"

IMAGE="$REPOSITORY:$GIT_TAG"
RELEASE_IMAGE="$REPOSITORY:$TAG"

echo "Building image ..."

docker build -t "$IMAGE" .

echo "Tagging image ..."

docker tag "$IMGAE" "$RELEASE_IMAGE"

echo "Pushing image ..."

docker push "$IMAGE"
docker push "$RELEASE_IMAGE"
