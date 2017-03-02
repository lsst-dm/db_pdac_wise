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

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Groupping folders for parallel processing **"
verbose "------------------------------------------------------------------------------------"

rm   -rf $LOCAL_TMP_DIR/forcedsource
mkdir -p $LOCAL_TMP_DIR/forcedsource

worker_data_dir="${INPUT_DATA_DIR}/${OUTPUT_FORCED_SOURCE_TABLE}/${worker}"

ls -1 $worker_data_dir > $LOCAL_TMP_DIR/forcedsource.txt

cd $LOCAL_TMP_DIR/forcedsource
split -n 8 -d $LOCAL_TMP_DIR/forcedsource.txt ''

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Starting loaders at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for folders in `ls $LOCAL_TMP_DIR/forcedsource`; do
    verbose "Launching loader for folders: ${folders}"
    nohup $SCRIPTS/load_forced_source_folders.bash "$folders" "$@" >& ${LOCAL_LOG_DIR}/load_forced_source_folders_${folders}.log &
done
