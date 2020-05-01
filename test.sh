#!/bin/bash
# check if pyenv is available
# edit: fixed redirect issue in earlier version
if which pyenv >/dev/null 2>&1; then
    # assumes default location of brew in `/usr/local/bin/brew`
    /usr/bin/env PATH="${PATH//$(pyenv root)\/shims:/}" /usr/local/bin/brew "$@"
else
    /usr/local/bin/brew "$@"
fi

which ${BREW}

DATE=$(date '+%Y%m%d.%H%M')
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)
brewFileName="Brewfile.${HOSTNAME}"

# # Brew Diagnotic
# echo "${yellow}==>${reset} Running Brew Diagnotic..."
# brew doctor 2>&1
# brew missing 2>&1
# echo -e "${green}==>${reset} Brew Diagnotic Finished."
