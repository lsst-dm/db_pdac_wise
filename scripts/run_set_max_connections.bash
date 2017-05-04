#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

HELP="
DESCRIPTION:

  This is the top-level driver script which will increase the number of
  allowed database server connections on all nodes (including MASTER and WORKERS)
  of a Qserv cluster as configured in the dataset specificaton file:

    `realpath $SCRIPTS/dataset.bash`

  The script must be run from the MASTER node of the cluster.

USAGE:

  `basename $SCRIPT` [<options>]"

source $SCRIPTS/env.bash

assert_master

for node in $SSH_MASTER $SSH_WORKERS; do
    verbose "Configuring connections on: $node"
    ssh -n $node "$SCRIPTS/set_max_connections.bash '$@'" >& $LOCAL_LOG_DIR/${node}_set_max_connections.log&
done
