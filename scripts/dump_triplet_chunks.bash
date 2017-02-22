#!/bin/bash

set -e

chunks="$1"

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_worker

for chunk in `cat ${LOCAL_TMP_DIR}/chunks/${chunks}`;
do
    verbose "Dumping triplets of chunk: ${chunk}"
    ${SCRIPTS}/dump_triplet_chunk.bash ${chunk} "$@" >& ${LOCAL_LOG_DIR}/dump_triplet.${chunk}.log
done

