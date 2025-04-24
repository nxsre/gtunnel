#!/bin/bash

if [[ "$(sudo docker image inspect gclient-build-image:latest 2> /dev/null)" == "[]" ]]; then
    docker build --network host -f gclient/Dockerfile -t gclient-build-image --progress plain .
fi

docker run -t --name gclient-build --entrypoint /go/src/gTunnel/gclient/gclient_build  gclient-build-image "$@"

if test $? -eq 0
then
    docker cp gclient-build:/output/. build/
else
    echo "[*] Exiting"
fi
docker rm gclient-build -f &> /dev/null || true
