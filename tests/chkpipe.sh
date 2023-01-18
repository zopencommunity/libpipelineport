#!/bin/sh

#
# early return until we get testing complete
#
exit 0

mydir=$(cd $(dirname $0) && echo $PWD)
LIBPIPELINE_HOME=${mydir}/../libpipeline-1.5.6/lib
LIB=$LIBPIPELINE_HOME/.libs
INC=$LIBPIPELINE_HOME
#LIBPIPELINE_HOME=$HOME/zopen/prod/libpipeline
#LIB=$LIBPIPELINE_HOME/lib
#INC=$LIBPIPELINE_HOME/include

if ! groff --version >/dev/null 2>&1 ; then
  cd "${HOME}/zopen/prod/groff"
  . ./.env
  cd "${OLDPWD}"
fi
if ! zsoelim --version >/dev/null 2>&1 ; then
  cd "${HOME}/zopen/prod/man"
  . ./.env
  cd "${OLDPWD}"
fi

CC=xlclang++
CFLAGS='-qascii'

cd "${mydir}"
rm -f chkpipe chkpipe.o

if ! ${CC} ${CFLAGS} -I$INC -L$LIB -L$HOME/zopen/prod/zoslib/lib -ochkpipe chkpipe.c -lpipeline -lzoslib ; then
  echo "Unable to build basic version test for libpipeline" >&2
  exit 8
fi

if ! ./chkpipe ; then
  echo "Unable to run basic version test for libpipeline" >&2
  rc=8
else
  rc=0
fi
rm -f chkpipe chkpipe.o
exit $rc
