#!/bin/bash

set -e

if [ -n "$RUN_BUILD" ]; then
    ghc -V	
    O2FLAG=" --ghc-options -O3 "
    if [ -n "$LLVM" ]; then
	    export LLVMFLAG=" --ghc-options -fllvm --ghc-options -pgmlo --ghc-options opt-$LLVM --ghc-options -pgmlc --ghc-options llc-$LLVM "
    fi
    if [ -n "$THREADED" ]; then
	    export THREADFLAG=" --ghc-options -threaded "
    fi
    stack build $STACKFILE $O2FLAG $THREADFLAG $LLVMFLAG
fi