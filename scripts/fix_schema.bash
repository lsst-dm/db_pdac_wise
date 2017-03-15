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

source $SCRIPTS/env_base_stack.bash

assert_master_or_worker

for class in Object ForcedSource; do

    for table in `echo "SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_NAME LIKE '${class}%' AND TABLE_SCHEMA='${OUTPUT_DB}'" | $mysql_cmd`; do

        sql="ALTER TABLE ${OUTPUT_DB}.${table} CHANGE \`dec\` \`decl\` DECIMAL(9,7) DEFAULT NULL"
        verbose $mysql_cmd -e "$sql"
        if [ -z "$(test_flag '-n|--dry-run')" ]; then
            $mysql_cmd -e "$sql"
        fi
    done
done
