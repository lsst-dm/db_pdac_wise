# The schema parser for parsing an IRSA schema defition documents
# obtained through the IRSA bulk-download site: https://irsa.ipac.caltech.edu/data/download/
# into MySQL schema definition files.

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
        print "usage: <txt>"
        sys.exit(1)

    txtfile = sys.argv[1]

    if txtfile[-4:] != ".txt":
        print "error: an TXT file with extension .txt was expected"
        sys.exit(1)


    # Parse the document, extract column names and data types,
    # and translate ORACLE-specific data types into the MySQL ones
    # where tis is needed. 

    colnameMaxLen = 0
    dbtypeMaxLen  = 0

    colname_dbtype = []

    with open(txtfile, "r") as f:
        for line in f:

            words = line[:-1].split()
            if len(words) != 2:
                print "error: input file has an unexpected format"
                sys.exist(1)

            colname = words[0]
            dbtype  = words[1].upper()

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

    table = txtfile[:-4]

    print """CREATE TABLE `%s` (
""" % table

    for typedef in colname_dbtype:
        if lineNum == lastLineNum: print fmtLast % tuple(typedef)
        else:                      print fmt     % tuple(typedef)
        lineNum = lineNum + 1

    print """
) ENGINE=MyISAM;"""

