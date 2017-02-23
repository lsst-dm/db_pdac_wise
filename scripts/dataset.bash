#!/bin/bash

# Source database (if any) is used as a model to simplify certain
# configuration steps.
#
# TODO: Get rid of this and rafactor tools to make
#       the loading & configuration process completely
#       independent of any pre-exiating databases.

# Output database and tables

OUTPUT_DB="wise_00"
OUTPUT_OBJECT_TABLE="Object"
OUTPUT_SOURCE_TABLE=
OUTPUT_FORCED_SOURCE_TABLE="ForcedSource"
OUTPUT_NONPART_TABLES=

# Data to be loaded into new database

INPUT_DATA_DIR="/datasets/gapon/production/wise_catalog_load/production_load"


