#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_worker

$SCRIPTS/get_chunk_numbers.bash "$@"

cd $LOCAL_TMP_DIR/chunks
for chunks in `ls -1 chunks_*`; do
    verbose "Dumping triplets of chunks: ${chunks} (async)"
    $SCRIPTS/dump_triplet_chunks.bash $chunks "$@" >& $LOCAL_LOG_DIR/dump_triplet_chunks.${chunks}.log&
done
