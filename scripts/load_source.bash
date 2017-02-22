#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_qserv_stack.bash

assert_worker

config_dir=`realpath ${SCRIPTS}/../config`
sql_dir=`realpath ${SCRIPTS}/../sql`

worker=`/usr/bin/hostname`

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Processing configuration templates at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for file in common.cfg; do
    verbose "${config_dir}/${file}.tmpl -> ${LOCAL_TMP_DIR}/${file}"
    translate_template ${config_dir}/${file}.tmpl ${LOCAL_TMP_DIR}/${file}
done

loader=`which qserv-data-loader.py`
if [ ! -z "$VERBOSE" ]; then
    opt_verbose="--verbose --verbose --verbose --verbose-all"
else
    opt_verbose=""
fi
opt_conn="--host=${MASTER} --port=5012 --secret=${config_dir}/wmgr.secret --no-css"
opt_config="--config=${LOCAL_TMP_DIR}/common.cfg --config=${config_dir}/${OUTPUT_SOURCE_TABLE}.cfg"
opt_db_table_schema="${OUTPUT_DB} ${OUTPUT_SOURCE_TABLE} ${sql_dir}/${OUTPUT_SOURCE_TABLE}.sql"
worker_data_dir="${INPUT_DATA_DIR}/${OUTPUT_SOURCE_TABLE}/${worker}"

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Begin loading at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for folder in `ls ${worker_data_dir}`; do

    verbose "["`date`"] ** Loading folder: ${folder} **"
    verbose "------------------------------------------------------------------------------------"

    opt_data="--skip-partition --chunks-dir=${worker_data_dir}/${folder}/"
    loadercmd="${loader} ${opt_verbose} ${opt_conn} --worker=${worker} ${opt_config} ${opt_data} ${opt_db_table_schema}"

    verbose ${loadercmd}
    if [ -z "$(test_flag '-n|--dry-run')" ]; then
        ${loadercmd}
    fi
    verbose "------------------------------------------------------------------------------------"
done
verbose "["`date`"] ** Finished loading **"
