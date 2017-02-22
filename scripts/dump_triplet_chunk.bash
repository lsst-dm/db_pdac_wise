#!/bin/bash

set -e

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk>"
    exit 1
fi

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

assert_worker

worker="$(hostname)"

triplet_file="${QSERV_DUMPS_DIR}/idx_object_${chunk}.tsv"

verbose "------------------------------------------------------------------------------------------------"
verbose "["`date`"] ** Begin dumping triplets of chunk ${chunk} at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------------------"
verbose "output file:    ${triplet_file}"

rm -f ${triplet_file}

${mysql_cmd} -e "SELECT id,chunkId,subChunkId FROM ${OUTPUT_DB}.${OUTPUT_OBJECT_TABLE}_${chunk} INTO OUTFILE '${triplet_file}'"

verbose "total triplets: "`wc -l ${triplet_file} | awk '{print $1}'`
verbose "------------------------------------------------------------------------------------------------"
verbose "["`date`"] ** Finished dumping triplets of chunk ${chunk} at worker: ${worker} **"
verbose "------------------------------------------------------------------------------------------------"
