#!/bin/bash
: '
This script will build the docker image, create a container if not exists
then, start the container.
'
IMAGE=rag
CONTAINER=rag
DOCKERFILE=Dockerfile

# ========  check if docker image name "mariadb" exists
if [[ "$(docker images -q $IMAGE 2>/dev/null)" == "" ]]; then
    # if not, build it, if build fail exit
    echo "Docker image $IMAGE not found, building new image..."
    docker build -t $IMAGE -f $DOCKERFILE .
    BUILD_SUCCESS=$?
else
    BUILD_SUCCESS=0
    echo "Docker image $IMAGE already exists, skipping build..."
fi
if [[ $BUILD_SUCCESS -ne 0 ]]; then
    echo "Build docker image failed with exit code $BUILD_SUCCESS"
fi

# ======== check if the given container exist, otherwise create it
# this will mount the repo to the same path as the host!
if [ -z "$(docker ps -aq -f name="^$CONTAINER$" 2>/dev/null)" ] && [ "$BUILD_SUCCESS" -eq 0 ]; then
    # if not, create it
    docker run -d \
        -p 8000:8000 \
        --name $CONTAINER $IMAGE
elif [[ "$BUILD_SUCCESS" -eq 0 ]]; then
    # check if the container is running
    if [[ "$(docker ps -aq -f status=running -f name="^$CONTAINER$" 2>/dev/null)" ]]; then
        echo "Container $CONTAINER already running, skipping start..."
    else
        echo "Container $CONTAINER exists but is not running, starting it..."
        docker start $CONTAINER
    fi
fi

# ======== test the api
sleep 0.5
curl -X 'POST' \
    'http://127.0.0.1:8000/rag/' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '[
  {
    "content": "It is with deep concern and a commitment to public safety that we bring this matter before the court. Tesla, a pioneer in the field of electric vehicles and autonomous driving technology, has marketed and sold vehicles equipped with the Autopilot feature, purportedly designed to enhance driver convenience and safety. However, our investigation and evidence will demonstrate that the Autopilot system falls short of these promises, placing drivers and passengers at an unacceptable risk of harm.",
    "metadata": {
      "author": "lawer",
      "title": "Tesla Law Suite",
      "case": "Autopilot cannot distinguish between a balloon and cloud."
    },
    "ID": 123
  }
]'
