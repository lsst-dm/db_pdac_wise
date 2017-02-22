#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_qserv_stack.bash

assert_worker

config_dir=`realpath $SCRIPTS/../config`
sql_dir=`realpath $SCRIPTS/../sql`

worker=`/usr/bin/hostname`

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Processing configuration templates at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for file in common-non-part.cfg; do
    verbose "${config_dir}/${file}.tmpl -> $LOCAL_TMP_DIR/${file}"
    translate_template ${config_dir}/${file}.tmpl $LOCAL_TMP_DIR/${file}
done

loader=`which qserv-data-loader.py`
if [ ! -z "$VERBOSE" ]; then
    opt_verbose="--verbose --verbose --verbose --verbose-all"
else
    opt_verbose=""
fi
opt_conn="--host=${MASTER} --port=5012 --secret=${config_dir}/wmgr.secret --no-css"
opt_config="--config=${LOCAL_TMP_DIR}/common-non-part.cfg"

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Begin loading at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for table in ${OUTPUT_NONPART_TABLES}; do

    verbose "["`date`"] ** Loading table: ${table} **"
    verbose "------------------------------------------------------------------------------------"

    opt_schema="${sql_dir}/${table}.sql"
    opt_data="${INPUT_DATA_DIR}/non-part/${table}.txt"
    loadercmd="${loader} ${opt_verbose} ${opt_conn} --worker=${worker} ${opt_config} ${OUTPUT_DB} ${table} ${opt_schema} ${opt_data}"

    verbose ${loadercmd}
    if [ -z "$(test_flag '-n|--dry-run')" ]; then
        ${loadercmd}
    fi
    verbose "------------------------------------------------------------------------------------"
done
verbose "["`date`"] ** Finished loading **"

