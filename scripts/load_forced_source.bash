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

worker_data_dir="${INPUT_DATA_DIR}/${OUTPUT_FORCED_SOURCE_TABLE}/${worker}"

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Starting loaders at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for folder in `ls ${worker_data_dir}`; do
    verbose "Launching loader for folder: ${folder}"
    nohup $SCRIPTS/load_forced_source_folder.bash "$folder" "$@" >& ${LOCAL_LOG_DIR}/load_forced_source_${folder}.log &
done
