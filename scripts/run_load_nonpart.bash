#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_master

for node in $SSH_WORKERS; do
    verbose $node : loading non-partitionable tables $OUTPUT_NONPART_TABLES into $OUTPUT_DB
    ssh -n $node "$SCRIPTS/load_nonpart.bash '$@'" >& $LOCAL_LOG_DIR/${node}_load_nonpart.log&
done
