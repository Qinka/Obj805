#!/bin/bash

set -e

if [ x"$TRAVIS_PULL_REQUEST" == "xtrue" ]; then
    echo skip building for pull request
    exit 0
fi

############
if [ -z "$IS_DOCKER" ]; then
    echo skip building docker images
    exit 0
fi

echo Build binarys for Docker image

echo make direcotry
cd $TRAVIS_BUILD_DIR
mkdir -p docker.tmp/root

echo install tools
cabal install  alex happy

cd yu-launch
echo Configuration
cabal configure --prefix='/' \
    --datasubdir='obj805' \
    --package-db=clear \
    --package-db=`stack path --local-pkg-db` \
    --package-db=`stack path --global-pkg-db` \
    --package-db=`stack path --snapshot-pkg-db` \
    --enable-optimization=2 $THREADFLAG $LLVMFLAG

echo Build
cabal build

echo copy
cabal copy --destdir=$TRAVIS_BUILD_DIR/docker.tmp/root

cd $TRAVIS_BUILD_DIR

echo Build docker image

export SERIAL_TAG=$(uname)-$OS_DISTRIBUTOR-$OS_CORENAME-GHC_$GHC_VER-$(uname -m)

if [ -n "$LLVM" ]; then
export SERIAL_TAG=$SERIAL_TAG-llvm-$LLVM
fi

if [ -n "$THREADED" ]; then
export SERIAL_TAG=$SERIAL_TAG-threaded
fi

if [ -n "$DEBUG" ]; then
export SERIAL_TAG=$SERIAL_TAG-debug
fi

if [ -n "$TRAVIS_TAG" ]; then
    export IMAGE_TAG=$TRAVIS_TAG-$SERIAL_TAG
else
    export IMAGE_TAG=$TRAVIS_BRANCH-$SERIAL_TAG-${TRAVIS_COMMIT:0:7}
    export IMAGE_LATEST=$TRAVIS_BRANCH-$SERIAL_TAG-latest
fi

export IMAGE_TAG=`echo $IMAGE_TAG | sed 's/\//-/g'`
export IMAGE_LATEST=`echo $IMAGE_LATEST | sed 's/\//-/g'`


cp -r $TRAVIS_BUILD_DIR/integration/dockerfiles/*.dockerfile     docker.tmp

mkdir -p docker.tmp/static
cp -r $TRAVIS_BUILD_DIR/front-end/* docker.tmp/static

echo build docker
cd docker.tmp

docker build -f back-end.dockerfile -t qinka/obj805:be-$IMAGE_TAG .

docker build -f front-end.dockerfile -t qinka/obj805:fe-$IMAGE_TAG .

docker tag      qinka/obj805:be-$IMAGE_TAG qinka/obj805:be-$IMAGE_LATEST

docker tag      qinka/obj805:fe-$IMAGE_TAG qinka/obj805:fe-$IMAGE_LATEST

docker push  qinka/obj805
