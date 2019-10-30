#!/bin/sh

VERSION=2.0

function usage() { # {{{
  echo "Usage:"
  echo -e "\t-h"
  echo -e "\t\tThis help"
  echo -e "\t-s"
  echo -e "\t\tStart new build for the base S2I image."
  echo -e "\t\tDefault: Start build."
  echo -e "\t-S"
  echo -e "\t\tRecreate S2I build objects. Not implemented."
  echo -e "\t\tDefault: Don't recreate."
  echo -e "\t-a <app-dir>"
  echo -e "\t\tUse S2I image to build application in <app-dir>."
  echo -e "\t\tDefault: Don't build application. app-dir=\"test-app\"."
} # }}}

function s2iimage() {
  cd ./s2i-rshiny/ && \
    oc start-build s2i-rshiny --from-dir=./ -F \
    && cd $BASEPWD
}

# Defaults {{{
DO_S2I_IMAGE=false
DO_S2I_BASE=false
DO_APP_BUILD=false
APP_DIR=test-app
APP_REBUILD_BASE=false
BASEPWD=$(pwd)
#}}}

echo "Build helper for debugging shiny S2I images. Version $VERSION"

while getopts "hsSa:A" opt; do # {{{
  case $opt in
    h)
      usage
      exit 0
      ;;
    s)
      DO_S2I_IMAGE=true
      ;;
    S)
      DO_S2I_BASE=true
      ;;
    a)
      if [ ! -z ${OPTARG} ]; then 
        APP_DIR=${OPTARG}
      fi
      DO_APP_BUILD=true
      ;;
    A)
      APP_REBUILD_BASE=true
  esac
done # }}}

if [ $DO_S2I_IMAGE == "true" ]; then
  s2iimage
fi

if [ $DO_S2I_BASE == "true" ]; then
  echo "DO_S2I_BASE Not implemented!"
fi

if [ $DO_APP_BUILD == "true" ]; then
  if [ $APP_REBUILD_BASE == "true" ]; then
  cd $APP_DIR && \
    oc delete bc,is s2i-shiny-os && \
    oc new-build s2i-rshiny~./ --strategy=source --name=s2i-shiny-os && \
    cd $BASEPWD
  fi
  cd $APP_DIR && \
    oc start-build s2i-shiny-os --from-dir=./ -F && \
    cd $BASEPWD
fi
