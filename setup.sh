#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/indygreg/python-build-standalone/releases/download/20220802/cpython-3.9.13+20220802-x86_64-unknown-linux-gnu-install_only.tar.gz -O $RALPM_TMP_DIR/cpython-3.9.13.tar.gz
  tar xf $RALPM_TMP_DIR/cpython-3.9.13.tar.gz -C $RALPM_PKG_INSTALL_DIR
  rm $RALPM_TMP_DIR/cpython-3.9.13.tar.gz

  $RALPM_PKG_INSTALL_DIR/python/bin/pip3.9 install dwarf-debugger==1.1.3

  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/dwarf $RALPM_PKG_BIN_DIR/
  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/dwarf-creator $RALPM_PKG_BIN_DIR/
  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/dwarf-injector $RALPM_PKG_BIN_DIR/
  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/dwarf-trace $RALPM_PKG_BIN_DIR/
  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/dwarf-strace $RALPM_PKG_BIN_DIR/

  echo "This package adds the commands:"
  echo " - dwarf"
  echo " - dwarf-creator"
  echo " - dwarf-injector"
  echo " - dwarf-trace"
  echo " - dwarf-strace"
}

uninstall() {
  rm -rf $RALPM_PKG_BIN_DIR/python
  rm $RALPM_PKG_BIN_DIR/dwarf
  rm $RALPM_PKG_BIN_DIR/dwarf-creator
  rm $RALPM_PKG_BIN_DIR/dwarf-injector
  rm $RALPM_PKG_BIN_DIR/dwarf-trace
  rm $RALPM_PKG_BIN_DIR/dwarf-strace
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1