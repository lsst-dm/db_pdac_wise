#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

assert_master_or_worker

config_dir=`realpath $SCRIPTS/../config`
sql_dir=`realpath $SCRIPTS/../sql`

verbose ""
verbose "Template substitutions:"
verbose ""
verbose "  OUTPUT_DB : $OUTPUT_DB"
verbose "  SQL_DIR   : $sql_dir"
verbose ""

files="common.cfg common-non-part.cfg css_${OUTPUT_OBJECT_TABLE}.params css_${OUTPUT_SOURCE_TABLE}.params"

verbose "Translating templates:"
verbose ""
for f in $files; do
    f_tmpl=${config_dir}/${f}.tmpl
    verbose "  $f_tmpl"
    translate_template $f_tmpl $LOCAL_TMP_DIR/$f
done

verbose ""
verbose "Output:"
verbose ""
for f in $files; do
    f_out=$LOCAL_TMP_DIR/$f
    verbose "  $f_out"
done
verbose ""
