#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

HELP="
DESCRIPTION:

  This is the top-level driver script meant to create (or re-create) a new
  database configured in the environment configuration file:

    `realpath $SCRIPTS/../config/env.bash`

  The database will be created on all nodes (including MASTER and WORKERS)
  of a Qserv cluster. The script must be run from the MASTER node of
  the cluster.

USAGE:

  `basename $SCRIPT` [<options>]

OPTIONS:

  -D|--delete
      force database deletion before attempting to create
      the new one.

      ATTENTION: this will destroy any data which were
                  previously loaded into the database."

source $SCRIPTS/env.bash

assert_master

for node in $SSH_MASTER $SSH_WORKERS; do
    verbose $node : creating database $OUTPUT_DB
    ssh -n $node "$SCRIPTS/create_database.bash '$@'" >& $LOCAL_LOG_DIR/${node}_create_database.log &
done
