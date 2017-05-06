# XML parser for parsing an IRSA schema defition XNL document into
# a MySQL schema definition files.

import xml.etree.ElementTree as ET

# XML parser for parsing a document into a Pyton dictionary

wholeType2TypeMap = {
    'NUMBER(19)'    : 'BIGINT',
    'NUMBER(20)'    : 'BIGINT',
    'DECIMAL(19)'   : 'BIGINT',
    'DECIMAL(20)'   : 'BIGINT',
    'NUMBER(10)'    : 'INT',
    'NUMBER(10,0)'  : 'INT',
    'DECIMAL(10)'   : 'INT',
    'DECIMAL(10,0)' : 'INT',
    'INTEGER'       : 'INT',
    'SMALLFLOAT'    : 'FLOAT',
    'INT8'          : 'BIGINT',
    'SERIAL8'       : 'BIGINT'
}
partialType2TypeMap = {
    'CHARACTER' : 'CHAR',
    'NUMBER'    : 'DECIMAL',
    'VARCHAR2'  : 'VARCHAR'
}

if __name__ == "__main__":

    import sys

    if len(sys.argv) != 2:
        print "usage: <xml>"
        sys.exit(1)

    xmlfile = sys.argv[1]

    if xmlfile[-4:] != ".xml":
        print "error: an XML file with extension .xml was expected"
        sys.exit(1)


    # Parse the document, extract column names and data types,
    # and translate ORACLE-specific data types into the MySQL ones
    # where tis is needed. 

    tree = ET.parse(xmlfile)
    root = tree.getroot()

    colnameMaxLen = 0
    dbtypeMaxLen  = 0

    colname_dbtype = []

    for c in root.findall('column'):

        colname = c.find('colname').text
        dbtype  = c.find('dbtype').text.upper()

        if dbtype in wholeType2TypeMap:
            dbtype = wholeType2TypeMap[dbtype]
        else:
            for partialType in partialType2TypeMap.keys():
                if dbtype[:len(partialType)] == partialType:
                    dbtype = "%s%s" % (partialType2TypeMap[partialType],dbtype[len(partialType):],)

        colname = "`" + colname + "`"

        if len(colname) > colnameMaxLen: colnameMaxLen = len(colname)
        if len(dbtype)  > dbtypeMaxLen:  dbtypeMaxLen  = len(dbtype)

        colname_dbtype.append([colname,dbtype])

    # Generate table schema definition
    #

    fmtLast = "    %" + str(colnameMaxLen) + "s  %" + str(dbtypeMaxLen) + "s  DEFAULT NULL"
    fmt     = fmtLast + ","

    lineNum     = 1
    lastLineNum = len(colname_dbtype)

    table = xmlfile[:-4]

    print """CREATE TABLE `%s` (
""" % table

    for typedef in colname_dbtype:
        if lineNum == lastLineNum: print fmtLast % tuple(typedef)
        else:                      print fmt     % tuple(typedef)
        lineNum = lineNum + 1

    print """
) ENGINE=MyISAM;"""

