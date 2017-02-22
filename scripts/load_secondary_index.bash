#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

assert_master

# Pull the triplets from all workers into a local folder
# unless instructed not to do so

cd $QSERV_DUMPS_DIR

if [ ! -z "$(test_flag '-r|--get-remote-triplets')" ]; then

    verbose "Pulling triplets from the worker nodes:"

    rm -f idx_object_*.tsv

    for worker in $SSH_WORKERS; do
        verbose "  ${worker}"
        scp ${worker}:${LOCAL_TMP_DIR}/chunks.txt ${worker}_chunks.txt >& /dev/null
        for chunk in `cat ${worker}_chunks.txt`; do
            scp ${worker}:${QSERV_DUMPS_DIR}/idx_object_${chunk}.tsv . >& /dev/null
        done
        rm ${worker}_chunks.txt
    done
fi
verbose "total of `ls -1 | grep .tsv | wc -l` index file will be loaded"

# Create the secondary index table similarily to the one which should
# already exist in the cluster.

input_index="qservMeta.${INPUT_DB}__${OUTPUT_OBJECT_TABLE}"
output_index="qservMeta.${OUTPUT_DB}__${OUTPUT_OBJECT_TABLE}"

verbose "creating secondary index table '${output_index}"
$mysql_cmd -e "CREATE TABLE IF NOT EXISTS ${output_index} LIKE ${input_index}"

# Load TSV files harvested from the worker nodes into the table

for f in `ls -1 | grep .tsv`; do
  verbose "loading triplest from file: ${f}"
  $mysql_cmd -e "LOAD DATA INFILE '$QSERV_DUMPS_DIR/$f' INTO TABLE ${output_index}" >& $LOCAL_LOG_DIR/load_${f}.log
done
