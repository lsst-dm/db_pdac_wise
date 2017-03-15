#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

HELP="
DESCRIPTION:

  Fix schemas of all partitioned tables in the local database
  by renaming column 'dec' into 'decl'.

    `realpath $SCRIPTS/../config/env.bash`

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
    verbose $node : fixing table schemas of database $OUTPUT_DB
    ssh -n $node "$SCRIPTS/fix_schema.bash '$@'" >& $LOCAL_LOG_DIR/${node}_fix_schema.log &
done
