#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

HELP="
DESCRIPTION:

  Report database connections (MySQL operation 'SHOW PROCESSLIST') on
  the current node of the Qserv cluster:

    `realpath $SCRIPTS/../config/env.bash`

  The script must be run on MASTER or WORKER nodes of the cluster.

USAGE:

  `basename $SCRIPT` [<options>]

OPTIONS:

  -t|--total
      report the total number of connections only"


source $SCRIPTS/env_base_stack.bash

assert_master_or_worker

max_connections=`${mysql_cmd} -e "SHOW GLOBAL VARIABLES LIKE 'max_connections'" | awk '{print $2}'`

if [ -z "$(test_flag '-t|--total')" ]; then
    echo
    echo $(hostname) "[ max_connections: $max_connections ]"
    echo "---------------------------------------------------------------------------------------"
    ${mysql_cmd} -e 'SHOW PROCESSLIST'
else
    echo $(hostname): `${mysql_cmd} -e 'SHOW PROCESSLIST' | wc -l` / $max_connections
fi
