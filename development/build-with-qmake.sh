#!/bin/bash
QT_DIR=${1}
BUILD_TYPE=${2}
CLEAN=${3}
TIDY_DIR=${4}

function error_exit {
    echo "***********error_exit***********"
    echo "***********" 1>&2
    echo "*********** Failed: $1" 1>&2
    echo "***********" 1>&2
    #cd ${CDIR}
    exit 1
}

if [ -z ${QT_DIR} ]; then
    echo "Missing argument(s).."
    echo "1st argument need to be the Qr root directory."
    echo "    Note: Qt root is where './bin/qmake' is.."
    echo "2nd argument is debug|release (defaults to debug)"
    echo "Example: $0 /d/dev/Qt/5.5/gcc_64 debug"
    exit 1
fi
if [ ! -f src/main.cpp ]; then
  echo "You seem to be in wrong directory. script MUST be run from the project directory."
  exit 1
fi

if [ -z "${BUILD_TYPE}" ]; then
    BUILD_TYPE=debug
fi
BUILD_DIR=qmake-build-${BUILD_TYPE}

if [ "${CLEAN}" == "clean" ]; then
  echo "Clean build: ${BUILD_DIR}"
  if [ -d "${BUILD_DIR}" ]; then
    rm -rf ${BUILD_DIR}
  fi
fi

if [ -z "${TIDY_DIR}" ]; then
   # system default
   TIDY_DIR=/usr
fi
TIDY_LIB_DIR=${TIDY_DIR}/lib
if [ ! -d "${TIDY_DIR}" ] || [ ! -d "${TIDY_LIB_DIR}" ]; then
   echo "TIDY_DIR or TIDY_DIR/lib is not a directory"
   exit 1
fi
echo "libtidy is expected in: ${TIDY_LIB_DIR}"





if [ ! -d "${BUILD_DIR}" ]; then
  mkdir ${BUILD_DIR}
fi

echo $QT_DIR >${BUILD_DIR}/qt-dir.txt
echo "${BUILD_DIR}">_build_dir_.txt

APPDIR=appdir
if [ -d "${APPDIR}" ]; then
  rm -rf ${APPDIR}
  rm *.AppImage 2>/dev/null
fi


QMAKE_BINARY=${QT_DIR}/bin/qmake

if [ ! -f "${QMAKE_BINARY}" ]; then
    echo "qmake binary (${QMAKE_BINARY}) not found!"
    exit 1
fi

if [ "${TIDY_DIR}" == "/usr" ] ; then
  # at least on ubuntu pkgconfig for "libtidy-dev" is not installed - so we provide default
  # there could be better option
  # check: env PKG_CONFIG_PATH=./development/pkgconfig pkg-config --libs --cflags tidy
  CDIR=`pwd`
  echo export PKG_CONFIG_PATH=${CDIR}/development/pkgconfig
  export PKG_CONFIG_PATH=${CDIR}/development/pkgconfig
elif [ -d ${TIDY_LIB_DIR}/pkgconfig ] ; then
  echo export PKG_CONFIG_PATH=${TIDY_LIB_DIR}/pkgconfig
  export PKG_CONFIG_PATH=${TIDY_LIB_DIR}/pkgconfig
fi


echo ${QMAKE_BINARY} CONFIG+=${BUILD_TYPE} PREFIX=appdir/usr QMAKE_RPATHDIR+=${TIDY_LIB_DIR} || error_exit "qmake"
${QMAKE_BINARY} CONFIG+=${BUILD_TYPE} PREFIX=appdir/usr QMAKE_RPATHDIR+=${TIDY_LIB_DIR} || error_exit "qmake"

make -j8 || error_exit "make"
make install || error_exit "make install"
