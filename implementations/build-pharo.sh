#!/bin/bash
if [ "$1" = "style" ]
then
  exit 0
fi

set -e # make script fail on first error
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_PATH/script.inc

if [ ! -d "$SCRIPT_PATH/pharo-vm" ]; then
  INFO Get Pharo VM
  pushd $SCRIPT_PATH
  get_web_getter
  $GET get.pharo.org/vm70 || $GET get.pharo.org/vm70
  bash vm70
  popd

  INFO Get Pharo Image
  pushd $SCRIPT_PATH/../benchmarks/Smalltalk
  $GET get.pharo.org/70 || $GET get.pharo.org/70
  bash 70
  popd
fi

INFO Build Benchmarking Image
cd $SCRIPT_PATH/../benchmarks/Smalltalk
$SCRIPT_PATH/pharo Pharo.image build-image.st
mv AWFY.image AWFY_Pharo.image
mv AWFY.changes AWFY_Pharo.changes
