#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

max_connections=8192

HELP="
DESCRIPTION:

  Set the number of allowed database connections to ${max_connections} on
  a node of a Qserv cluster as configured in:

    `realpath $SCRIPTS/../config/env.bash`

  The script must be run on the MASTER or WORKER node of the cluster.

USAGE:

  `basename $SCRIPT` [<options>]"

source $SCRIPTS/env_base_stack.bash

assert_master_or_worker

verbose Setting MySQL connection limit to $max_connections
${mysql_cmd} -e "SET GLOBAL max_connections=${max_connections}"
