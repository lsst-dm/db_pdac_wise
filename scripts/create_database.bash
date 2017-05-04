#!/bin/bash
#
# Create or recreate the output database on a local database server
# of a worker node.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/dataset.bash

HELP="
DESCRIPTION:

  Create (or re-create) a new database '${OUTPUT_DB}' configured in the dataset
  configuration file:

    `realpath $SCRIPTS/dataset.bash`

  This operation should be performed on MASTER or WORKER nodes of
  the Qserv cluster. Please, do not run this script directly! It's
  supposed to be launched by the corresponding 'driver' script:

    run_`basename $SCRIPT`

USAGE:

  `basename $SCRIPT` [<options>]

OPTIONS:

  -D|--delete
      force database deletion before attempting to create
      the new one.

      ATTENTION: this will destroy any data which were
                  previously loaded into the database."

source $SCRIPTS/env_base_stack.bash

assert_master_or_worker

if [ ! -z "$(test_flag '-D|--delete')" ]; then
    verbose "deleting database: ${OUTPUT_DB}"
    $mysql_cmd -e "DROP DATABASE IF EXISTS ${OUTPUT_DB};"
fi
verbose "creating database: ${OUTPUT_DB}"
$mysql_cmd -e "CREATE DATABASE IF NOT EXISTS ${OUTPUT_DB};"

verbose "configuring access privileges for database: ${OUTPUT_DB}"
$mysql_cmd -e "GRANT ALL ON ${OUTPUT_DB}.* TO 'qsmaster'@'localhost';"
$mysql_cmd -e "FLUSH PRIVILEGES;"
