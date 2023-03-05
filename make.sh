#!/bin/env bash

set -euo pipefail # unofficial bash strict mode

source ./compile_utils.sh

stdheader iostream

compile helloworld
compile main helloworld

link hello

