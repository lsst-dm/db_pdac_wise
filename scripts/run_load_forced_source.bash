#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_master

for node in $SSH_WORKERS; do
    verbose $node : loading source table $OUTPUT_FORCED_SOURCE_TABLE into $OUTPUT_DB
    ssh -n $node "$SCRIPTS/load_forced_source.bash '$@'" >& $LOCAL_LOG_DIR/${node}_load_forced_source.log&
done
