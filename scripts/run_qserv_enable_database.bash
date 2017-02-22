#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_master

for node in $SSH_WORKERS; do
    verbose $node : enabling $OUTPUT_DB in Qserv
    ssh -n $node "$SCRIPTS/qserv_enable_database.bash '$@'" >& $LOCAL_LOG_DIR/${node}_qserv_enable_database.log &
done
