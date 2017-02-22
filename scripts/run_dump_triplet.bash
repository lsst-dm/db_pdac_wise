#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_master

for node in $SSH_WORKERS; do
    verbose $node : dumping triplets from object chunks of $OUTPUT_DB
    ssh -n $node "$SCRIPTS/dump_triplet.bash '$@'" >& $LOCAL_LOG_DIR/${node}_dump_triplet.log &
done
