#! /bin/sh
/usr/local/bin/vacuumdb -az 1> /dev/null 2> /dev/null
/usr/local/bin/reindexdb -a 1> /dev/null 2> /dev/null
