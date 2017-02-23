#! /bin/bash
#
# ATTENTION: this script is always 'sourced', and it requires that
#            the environment variable 'SCRIPTS' pointing to a location
#            of this and other scripts was set up prior to source
#            this one.

if [ -z "${SCRIPTS}" ]; then
    echo "env.bash: environment variable SCRIPTS is not set"
    exit 1
fi

# Dataset specifications are found in a separate file

source $SCRIPTS/dataset.bash

# Custom versions of the LSST Stack and the latest version of the Qserv
# management scripts.

BASE_STACK="/datasets/gapon/stack"
QSERV_PKG="/datasets/gapon/development/qserv"

# Qserv deployment parameters (adjust accordingly)

MYSQL_PASSWORD="CHANGEME"

MASTER="lsst-qserv-master01"
SSH_MASTER="qserv-master01"

WORKERS=`seq --format 'lsst-qserv-db%02.0f' 1 30`
SSH_WORKERS=`seq --format 'qserv-db%02.0f' 1 30`

QSERV_MYSQL_DIR="/qserv/data/mysql"
QSERV_DUMPS_DIR="/qserv/data/dumps/$OUTPUT_DB"

# The default location for the log files created on Qserv node

LOCAL_TMP_DIR="/tmp/$OUTPUT_DB"
LOCAL_LOG_DIR="$LOCAL_TMP_DIR/log"

# Shortcuts

mysql_cmd="mysql -B -N -A -S ${QSERV_MYSQL_DIR}/mysql.sock -h localhost -P13306 -uroot -p${MYSQL_PASSWORD}"
mysqldump_cmd="mysqldump  -S ${QSERV_MYSQL_DIR}/mysql.sock -h localhost -P13306 -uroot -p${MYSQL_PASSWORD}"

# Host verification functions

function assert_master {
    if [ $MASTER != "$(hostname)" ]; then
        echo `basename $0` : this script must be run on node $MASTER
        exit 1
    fi
}
function assert_worker {
    if [[ "$WORKERS" != *"$(hostname)"* ]]; then
        echo `basename $0` : this script must be run on nodes $WORKERS
        exit 1
    fi
}
function assert_master_or_worker {
    if [[ "$MASTER $WORKERS" != *"$(hostname)"* ]]; then
        echo `basename $0` : this script must be run on nodes $MASTER $WORKERS
        exit 1
    fi
}

# Extract common command line parameters (if any) and set the corresponding
# environment variables.

function parse_options {
    if [ $# -gt 0 ]; then
        for opt in $@; do
            case $opt in
                -v|--verbose)
                    VERBOSE=1
                    ;;
                -d|--debug)
                    DEBUG=1
                    ;;
            esac
        done
    fi
}

# Translate the specified template file and print the result
# into the specified file.
#
# Usage: [<file_tmpl> [<file_out>]]
#
# Parameters:
#   <file_tmpl> - the input file to be translated. The input will be read from
#                 the standard input if no input file provided.
#
#   <file_out>  - the output file. The output will be written into
#                 the standard output stream if no output file provided.
#
# It's also acceptable to use symbol '-' as any file name to indicate
# the standard input (and output if needed).

function translate_template {
    this_path="$0"
    if [ $this_path == "bash" ]; then
        echo "env.bash: function translate_template() can't be called from an interactive shell"
        exit 1
    fi
    this_dir=`dirname $this_path`
    sql_dir=`realpath $this_dir/../sql`

    file_tmpl="-"
    if [ "$#" -gt 0 ]; then
        file_tmpl="$1"
    fi
    file_out="-"
    if [ "$#" -gt 1 ]; then
        file_out="$2"
    fi
    if [ "$file_out" == "-" ]; then
        cat $file_tmpl \
            | sed 's/\$OUTPUT_DB/'${OUTPUT_DB}'/' \
            | sed 's/\$OUTPUT_OBJECT_TABLE/'${OUTPUT_OBJECT_TABLE}'/' \
            | sed 's/\$SQL_DIR/'$(echo $sql_dir | sed 's/\//\\\//g')'/'
    else
        cat $file_tmpl \
            | sed 's/\$OUTPUT_DB/'${OUTPUT_DB}'/' \
            | sed 's/\$OUTPUT_OBJECT_TABLE/'${OUTPUT_OBJECT_TABLE}'/' \
            | sed 's/\$SQL_DIR/'$(echo $sql_dir | sed 's/\//\\\//g')'/' \
            > $file_out
    fi
}

# These functions are similar to 'echo' except they will print
# an input message (all parameters)only when the corresponding
# environment variable VERBOSE or DEBUG are present

function verbose {
    if [ ! -z ${VERBOSE} ]; then
        echo "$@"
    fi
}

function debug {
    if [ ! -z ${DEBUG} ]; then
        echo "$@"
    fi
}

# Check if the specified flag is presentamong command line
# parameters.
#
# NOTE: The implementation of the function depends on the content
#       of variable _OPTIONS which is

_OPTIONS="$@"

function test_flag {
    if [ -z "$1" ]; then
        echo "env.bash: usage: test_flag <flag>"
        exit 1
    fi
    result=''
    for opt in $_OPTIONS; do
        if [[ "$1" == *"$opt"* ]]; then
            result=1
        fi
    done
    echo $result
}

# Extract common command line parameters (if any) and process
# them accordingly.

if [ ! -z "$(test_flag '-v|--verbose')" ]; then
    VERBOSE=1
fi
if [ ! -z "$(test_flag '-d|--debug')" ]; then
     DEBUG=1
fi
if [ ! -z "$(test_flag '-h|--help')" ]; then
     if [ ! -z "$HELP" ]; then
         echo "$HELP"
         echo "
COMMON OPTIONS:

  -h|--help
      print this help

  -v|--verbose
      turn on verbose mode for message logger

  -d|--debug
      turn on debug mode for message logger
"
     fi
     exit 0
fi


# Verify if all folders exists for the current node on which
# the script is being run. Try creating the missing folders.

if [[ "$MASTER $WORKERS" == *"$(hostname)"* ]]; then

    # Make sure the script is being run under user 'qserv'

    if [ "$(whoami)" != "qserv" ]; then
        echo "error: this script must be run by user 'qserv'"
        exit 1
    fi
    debug "debug: user 'qserv'"

    # Read-only access to these folders should be good enough

    for folder in "$INPUT_DATA_DIR" "$QSERV_MYSQL_DIR"; do

        if [ ! -d "$folder" ]; then
            echo "error: directory '${folder}' doesn't exist or is not accessible"
            exit 1
        fi
        if [ ! -r "$folder" ]; then
            echo "error: directory '${folder}' is not readable"
            exit 1
        fi
        debug "debug: access verified for '${folder}'"
    done

    # Check if a folder where MySQL file dumps and load would go
    # exists, and if it's not then create the one with wide open
    # permissions.

    if [ ! -d "$QSERV_DUMPS_DIR" ]; then

        mkdir -p      ${QSERV_DUMPS_DIR}
        chmod -R 0777 ${QSERV_DUMPS_DIR}

        debug "debug: created directory '${QSERV_DUMPS_DIR}'"
    fi
    if [ ! -w "$QSERV_DUMPS_DIR" ]; then
        echo "error: directory '${QSERV_DUMPS_DIR}' is not writeable"
        exit 1
    fi
    debug "debug: access verified for '${QSERV_DUMPS_DIR}'"

    # Verify and create (if needed) if the temporary and log folders
    # exists and can be accessed for writing purposes by the current user.

    for folder in "$LOCAL_TMP_DIR" "$LOCAL_LOG_DIR"; do
        if [ ! -d "$folder" ]; then
            mkdir -p      "$folder"
            chmod -R 0777 "$folder"
            debug "debug: created directory '${folder}'"
        fi
        if [ ! -w "$folder" ]; then
            echo "error: directory '${folder}' is not writeable"
            exit 1
        fi
        debug "debug: access verified for '${folder}'"
    done
fi

