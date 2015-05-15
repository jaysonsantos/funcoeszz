#!/bin/bash
set -e
set -x

export PATH="/tmp:$PATH"

cd "$(dirname "$0")/testador"
bash -x ./run
cat run.tmp