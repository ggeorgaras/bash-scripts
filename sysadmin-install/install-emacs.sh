#!/bin/bash

function install_emacs_requirements {
    sudo apt install -y build-essential autoconf gcc git-core texinfo libncurses5-dev hunspell hunspell-en-gb hunspell-en-us hunspell-es hunspell-pt-pt hunspell-pt-br hunspell-de-de hunspell-it hunspell-fr
}

function install_emacs_download {
    [[ ! -d "${WORKSPACE}" ]] && mkdir -p "${WORKSPACE}"
    pushd "${WORKSPACE}"

    if [ ! -d emacs ] ;then
        git clone git://git.savannah.gnu.org/emacs.git
    else
        cd emacs
    fi
    git pull
    git checkout emacs-27.1

    popd
}

function install_emacs_make {
  if [ -d "${WORKSPACE}"/emacs ] ;then
      cd "${WORKSPACE}"/emacs && \
        ./autogen.sh && sudo apt build-dep emacs25 -y && \
          ./configure --prefix=/opt/emacs && \
            make && \
              sudo make install
  else
      return 1
  fi
}

function install_emacs {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
