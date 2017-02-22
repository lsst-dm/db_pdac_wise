#!/bin/bash
#
# Extract chunk numbers associated with the current  worker node
# from the input database, sort them (DESC) numerically and print
# them to the standard output.
#
# NOTE: This script is meant to be run on a worker node

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

assert_worker

cd $LOCAL_TMP_DIR

verbose "fetching chunk numbers from database ${OUTPUT_DB}"

echo "\
SELECT SUBSTR(TABLE_NAME,LENGTH('${OUTPUT_OBJECT_TABLE}')+2) \
  FROM information_schema.tables \
  WHERE TABLE_SCHEMA='${OUTPUT_DB}' \
  AND TABLE_NAME LIKE '${OUTPUT_OBJECT_TABLE}\_%' AND TABLE_ROWS > 0;" | $mysql_cmd | sort -n > chunks.txt

verbose "total of `wc -l  chunks.txt` chunks found"
verbose "splitting chunk number series into multiple subsequences"

rm -rf chunks
mkdir  chunks
cd     chunks
cat ../chunks.txt | split -l 36 -d - chunks_

verbose "total of `ls -1 chunks_* | wc -l` subsequences have been made"
