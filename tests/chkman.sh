#!/bin/sh

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
rm -f chkman chkman.o

if ! ${CC} ${CFLAGS} -I$INC -L$LIB -L$HOME/zopen/prod/zoslib/lib -ochkman chkman.c -lpipeline -lzoslib ; then
  echo "Unable to build basic version test for libpipeline" >&2
  exit 8
fi

cmd="man"
manfile=$(find $HOME/zopen/prod/ -name "${cmd}.1" | head -1)
if [ "${manfile}x" = "x" ]; then
  echo "Unable to find man page for ${cmd}" >&2
  exit 4
fi

if ! ./chkman 80 "${manfile}" ; then
  echo "Unable to run basic version test for libpipeline" >&2
  rc=8
else
  rc=0
fi
rm -f chkman chkman.o
exit $rc
