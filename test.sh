#!/bin/bash

DOCKERFILE_PATH="test/_docker/dockerfile"
IMAGE_NAME="osm-bingo-env"
CONTAINER_NAME="osm-bingo-container"
BUILD_VOLUME="osm-bingo-build-cache"
DART_TOOL_VOLUME="osm-bingo-dart-tool"

if [[ "$1" == "--clean" ]]; then
    echo 'Stopping docker container'
    docker stop "$CONTAINER_NAME"
    echo 'Removing docker container'
    docker rm -f "$CONTAINER_NAME"
    echo 'Removing docker image'
    docker rmi -f "$IMAGE_NAME"
    echo 'Removing docker ./build volume'
    docker volume rm -f "$BUILD_VOLUME"
    echo 'Removing docker ./dart_tool volume'
    docker volume rm -f "$DART_TOOL_VOLUME"
    echo 'Done'
    exit 0
fi

if ! docker images --format '{{.Repository}}' | grep -w "$IMAGE_NAME" > /dev/null; then
    echo "Building Docker image '$IMAGE_NAME' from $DOCKERFILE_PATH. This will take a few minutes but only needs to be done once."
    docker build -t "$IMAGE_NAME" -f "$DOCKERFILE_PATH" "$(dirname $DOCKERFILE_PATH)"
fi

if docker ps -a --format '{{.Names}}' | grep -w "$CONTAINER_NAME" > /dev/null; then
    echo "Starting existing container $CONTAINER_NAME"
    docker start "$CONTAINER_NAME"
else
    echo "Creating new container $CONTAINER_NAME. This will only be done once."

    docker volume create "$BUILD_VOLUME"
    docker volume create "$DART_TOOL_VOLUME"

    if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
        APP_PATH="$(pwd -W)" # Windows-style path on Windows
    else
        APP_PATH="$(pwd)"
    fi

    docker run -dit --name "$CONTAINER_NAME" \
        -v "$APP_PATH":/app \
        -v "$BUILD_VOLUME":/app/build \
        -v "$DART_TOOL_VOLUME":/app/.dart_tool \
        "$IMAGE_NAME"
fi

docker exec -it "$CONTAINER_NAME" flutter pub get
docker exec -it "$CONTAINER_NAME" flutter test "$@"
FLUTTER_TEST_EXIT_CODE=$?

echo "Stopping container $CONTAINER_NAME"
docker stop "$CONTAINER_NAME"

exit $FLUTTER_TEST_EXIT_CODE
