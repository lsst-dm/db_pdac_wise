#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_master

for node in $SSH_WORKERS; do
    verbose $node : loading object table $OUTPUT_OBJECT_TABLE into $OUTPUT_DB
    ssh -n $node "$SCRIPTS/load_object.bash '$@'" >& $LOCAL_LOG_DIR/${node}_load_object.log&
done
