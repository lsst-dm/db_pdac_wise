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

# Create the secondary index table

output_index="qservMeta.${OUTPUT_DB}__${OUTPUT_OBJECT_TABLE}"

verbose "creating secondary index table: ${output_index}"

sql_dir=`realpath ${SCRIPTS}/../sql`

translate_template ${sql_dir}/create_secondary_index.sql.tmpl ${LOCAL_TMP_DIR}/create_secondary_index.sql

cat ${LOCAL_TMP_DIR}/create_secondary_index.sql | $mysql_cmd

# Load TSV files harvested from the worker nodes into the table

for f in `ls -1 | grep .tsv`; do
  verbose "loading triplest from file: ${f}"
  $mysql_cmd -e "LOAD DATA INFILE '$QSERV_DUMPS_DIR/$f' INTO TABLE ${output_index}" >& $LOCAL_LOG_DIR/load_${f}.log
done
