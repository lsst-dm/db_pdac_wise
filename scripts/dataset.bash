#!/bin/bash

# Source database (if any) is used as a model to simplify certain
# configuration steps.
#
# TODO: Get rid of this and rafactor tools to make
#       the loading & configuration process completely
#       independent of any pre-exiating databases.

INPUT_OBJECT_TABLE="Object"
INPUT_FORCED_SOURCE_TABLE="ForcedSource"

# Output database and tables

OUTPUT_DB="wise_00"
OUTPUT_OBJECT_TABLE="allwise_cat"
OUTPUT_SOURCE_TABLE=
OUTPUT_FORCED_SOURCE_TABLE="allwise_i3as_mep"
OUTPUT_NONPART_TABLES="allwise_p3as"

# Data to be loaded into new database

INPUT_DATA_DIR="/datasets/gapon/production/wise_catalog_load/production_load"


