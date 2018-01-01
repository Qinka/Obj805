#!/bin/bash

set -e
echo pre-install

######
echo fetch the system\' name
export OS_CORENAME=$(lsb_release -c | awk '{print $2}')
export OS_DISTRIBUTOR=$(lsb_release -i | awk '{print $3}')
echo using $OS_DISTRIBUTOR  $OS_CORENAME


########
echo update apt
sudo apt update

######
echo Install ghc-$GHC_VER and cabal-install-$CABAL_VER
sudo apt install ghc-$GHC_VER cabal-install-$CABAL_VER

######
if [ -n "$LLVM" ]; then
  echo install llvm
  wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
  echo deb http://apt.llvm.org/$OS_CORENAME/ llvm-toolchain-$OS_CORENAME-$LLVM main | sudo tee -a /etc/apt/sources.list.d/llvm.list
  sudo apt update
  sudo apt install -y lldb-$LLVM llvm-$LLVM llvm-$LLVM-dev llvm-$LLVM-runtime
else
  echo without llvm
fi

######
echo login docker
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

######
echo setting up ghc-$GHC_VER
export PATH=$HOME/.cabal/bin:/opt/ghc/$GHC_VER/bin:$PATH
ghc -V

######
echo install haskell-stack
mkdir -p ~/.local/bin
export PATH=$HOME/.local/bin:$PATH
travis_retry curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack'

######
echo config haskell-stack
stack config set system-ghc --global true
stack path --programs $STACKFILE

#####
if [ -n "$STACKSOLVER" ]; then
    export STACKFILE=" --stack-yaml $TRAVIS_BUILD_DIR/$STACKSOLVER"
fi
echo STACKFILE $STACKFILE
