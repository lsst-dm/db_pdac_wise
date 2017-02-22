#! /bin/bash
#
# Set up the LSST Stack environment for using a required version
# of the Qserv administrative tools from a location configured
# for this pipeline.
#
# ATTENTION: this script is always 'sourced', and it requires that
#            the environment variable 'SCRIPTS' pointing to a location
#            of this and other scripts was set up prior to source
#            this one.

if [ -z "${SCRIPTS}" ]; then
    echo "env_base_stack.bash: environment variable SCRIPTS is not set"
    exit 1
fi
source $SCRIPTS/env.bash

source $BASE_STACK/loadLSST.bash
setup -t qserv-dev qserv_distrib
setup -j -r $QSERV_PKG
