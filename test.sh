#!/bin/bash
# BREW=/Users/${USER}/.brewWrapper.sh

# which $BREW

# $BREW doctor

if which pyenv >/dev/null 2>&1; then
    # assumes default location of brew in `/usr/local/bin/brew`
    var=$(/usr/bin/env PATH="${PATH//$(pyenv root)\/shims:/}" /usr/local/bin/brew "$@")
else
    var=$(/usr/local/bin/brew "$@")
fi
