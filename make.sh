#!/bin/env bash

set -euo pipefail # unofficial bash strict mode

source ./compile_utils.sh

stdheader fstream
stdheader iostream
stdheader optional

compile file_writer
compile helloworld file_writer
compile main helloworld

link hello

