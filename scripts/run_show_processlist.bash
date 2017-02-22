#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

HELP="
DESCRIPTION:

  This is the top-level driver script which will reporti onto the
  the standard output database connections (MySQL operation 'SHOW PROCESSLIST')
  on all nodes (including MASTER and WORKERS) of a Qserv cluster as configured
  in:

    `realpath $SCRIPTS/../config/env.bash`

  The script must be run from the MASTER node of the cluster.

USAGE:

  `basename $SCRIPT` [<options>]

OPTIONS:

  -t|--total
      report the total number of connections only"

source $SCRIPTS/env.bash

assert_master

for node in $SSH_MASTER $SSH_WORKERS; do
    ssh -n $node "$SCRIPTS/show_processlist.bash '$@'"
done
