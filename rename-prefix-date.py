#!/usr/bin/env python3

####################################
# Rename Files with Prefix Date
#   Accept a list of filenames with the format of 'MMDD-<Name>-<SN>'
#   Rename Date According <Name> and <SN>
####################################

import os
import sys

NUM_PER_DAY = 2
begin_dates = {}

def parseFileName(fname):
    tokens = fname.split('-')

    date = int(tokens[0])
    sn = int(tokens[-1])
    title = '-'.join(tokens[1:-1])
    return (date, title, sn)

def check_date(date, title, sn):
    diff = int((sn -1) / NUM_PER_DAY)
    if diff == 0:
        begin_dates[title] = date
    else:
        date = begin_dates[title] + diff;
    return date

def getRenameList(paths):
    result = []

    for path in sorted(paths):
        #print(path)
        try:
            dirname, basename = os.path.split(path)
            filename, fileext = os.path.splitext(basename)
            date, title, sn = parseFileName(filename)

            right_date = check_date(date, title, sn)
            if right_date != date:
                new_path = os.path.join(dirname, "%d-%s-%d%s" % (right_date, title, sn, fileext))
                result.append((path, new_path))
        except Exception as ex:
            print("omit file '%s', error: %s" % (path, ex))

    return result


# collect the rename lsit
todo_renames = getRenameList(sys.argv[1:])
if len(todo_renames) == 0:
    sys.exit(0)

# dry run
for pair in todo_renames:
    print("rename '%s' => '%s'" % pair)

# check to rename
if input("To Rename?[Yn] ").lower() in {'', 'y', 'ye', 'yes'}:
    for src, dst in todo_renames:
        os.rename(src, dst)


    
