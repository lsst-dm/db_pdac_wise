Processing templates
====================

  The template files need do be preprocessed to replace placeholders
  for database names (etc.) as per the current configuration before using
  them by the corresponding tools. Here follow examples:

    OUTPUT_DB='wise_00'
    SQL_DIR='some/dir'

    cat common.cfg.tmpl \
      | sed 's/\$OUTPUT_DB/'${OUTPUT_DB}'/' \
      > common.cfg
      
    cat css_allwise_p3as_psd.params.tmpl \
      | sed 's/\$OUTPUT_DB/'${OUTPUT_DB}'/' \
      | sed 's/\$SQL_DIR/'$(echo $SQL_DIR | sed 's/\//\\\//g')'/' /
      > css_allwise_p3as_psd.params
      
    cat css_allwise_p3as_mep.params.tmpl \
      |  sed 's/\$OUTPUT_DB/'${OUTPUT_DB}'/' \
      |  sed 's/\$SQL_DIR/'$(echo $SQL_DIR | sed 's/\//\\\//g')'/' \
      > css_allwise_p3as_mep.params
