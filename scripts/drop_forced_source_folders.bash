#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

assert_worker

folders="$1"
if [ -z "$folders" ]; then
    echo `basename ${SCRIPT}`": usage <folders>"
    exit 1
fi

worker=`/usr/bin/hostname`

worker_data_dir="${INPUT_DATA_DIR}/${OUTPUT_FORCED_SOURCE_TABLE}/${worker}"

verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Begin dropping tables at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------"

for folder in `cat ${LOCAL_TMP_DIR}/forcedsource/${folders}`; do

    verbose "["`date`"] ** Tables of chunks from folder: ${folder} **"
    verbose "------------------------------------------------------------------------------------"

    for f in `ls ${worker_data_dir}/${folder}/ | grep .txt`; do

        chunk=$(echo ${f%.txt} | awk -F_ '{print $2}')

        for table in ${OUTPUT_DB}.${OUTPUT_FORCED_SOURCE_TABLE}_${chunk} ${OUTPUT_DB}.${OUTPUT_FORCED_SOURCE_TABLE}FullOverlap_${chunk}; do
            verbose $mysql_cmd -e "DROP TABLE IF EXISTS ${table}"
            if [ -z "$(test_flag '-n|--dry-run')" ]; then
                $mysql_cmd -e "DROP TABLE IF EXISTS ${table}"
            fi
        done
    done
done
verbose "------------------------------------------------------------------------------------"
verbose "["`date`"] ** Finished loading **"
