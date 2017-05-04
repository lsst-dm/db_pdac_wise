#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/dataset.bash

HELP="
DESCRIPTION:

  Rename all partitioned tables in the local database
  '${OUPUT_DB}' back to their original names: '${OUTPUT_OBJECT_TABLE}' (currently '${INPUT_OBJECT_TABLE}')
  and '${OUTPUT_FORCED_SOURCE_TABLE}' (curently '${INPUT_FORCED_SOURCE_TABLE}').

  This operation should be performed on MASTER or WORKER nodes of
  the Qserv cluster. Please, do not run this script directly! It's
  supposed to be launched by the corresponding 'driver' script:

    run_`basename $SCRIPT`

USAGE:

  `basename $SCRIPT` [<options>]

OPTIONS:

  -n|--dry-run
      do not make the schema change. Just report a SQL statement
      which is supposed to be executed in the corresponding context."

source $SCRIPTS/env.bash

assert_master

for node in $SSH_MASTER $SSH_WORKERS; do
    verbose $node : renaming tables of database $OUTPUT_DB
    ssh -n $node "$SCRIPTS/rename_tables.bash '$@'" >& $LOCAL_LOG_DIR/${node}_rename_tables.log &
done
