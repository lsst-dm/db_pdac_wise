#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_qserv_stack.bash

assert_master

config_dir=`realpath $SCRIPTS/../config`

# Populate CSS for the new database if the database
# is not registered in CSS.

for db in `qserv-admin.py "SHOW DATABASES;"`; do
    if [ "$db" == "$OUTPUT_DB" ]; then
        exit 0
    fi
done

qserv-admin.py "CREATE DATABASE ${OUTPUT_DB} ${config_dir}/css.params;"

# Populate CSS only for those tables which are registered
# for this dataset.
 
for table in $OUTPUT_OBJECT_TABLE $OUTPUT_FORCED_SOURCE_TABLE; do

    # Translate configuration template

    translate_template ${config_dir}/css_${table}.params.tmpl $LOCAL_TMP_DIR/css_${table}.params

    qserv-admin.py "CREATE TABLE ${OUTPUT_DB}.${table} ${LOCAL_TMP_DIR}/css_${table}.params;"
done

