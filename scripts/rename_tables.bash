#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/dataset.bash

HELP="
DESCRIPTION:

  Rename all partitioned tables in the local database
  back to their original names: '${OUTPUT_OBJECT_TABLE}' (currently '${INPUT_OBJECT_TABLE}')
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

source $SCRIPTS/env_base_stack.bash

assert_master_or_worker

for table in `echo "SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_NAME LIKE '${INPUT_OBJECT_TABLE}%' AND TABLE_SCHEMA='${OUTPUT_DB}'" | $mysql_cmd`; do

    new_table="${table/$INPUT_OBJECT_TABLE/$OUTPUT_OBJECT_TABLE}"
    sql="RENAME TABLE ${OUTPUT_DB}.${table} TO ${OUTPUT_DB}.${new_table}"

    verbose $mysql_cmd -e "$sql"
    if [ -z "$(test_flag '-n|--dry-run')" ]; then
        $mysql_cmd -e "$sql"
    fi
done

for table in `echo "SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_NAME LIKE '${INPUT_FORCED_SOURCE_TABLE}%' AND TABLE_SCHEMA='${OUTPUT_DB}'" | $mysql_cmd`; do

    new_table="${table/$INPUT_FORCED_SOURCE_TABLE/$OUTPUT_FORCED_SOURCE_TABLE}"
    sql="RENAME TABLE ${OUTPUT_DB}.${table} TO ${OUTPUT_DB}.${new_table}"

    verbose $mysql_cmd -e "$sql"
    if [ -z "$(test_flag '-n|--dry-run')" ]; then
        $mysql_cmd -e "$sql"
    fi
done

