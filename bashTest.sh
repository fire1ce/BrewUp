#!/bin/bash
DATE=`date '+%Y%m%d.%H%M'`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
scriptPath="$( cd "$(dirname "$0")" ; pwd -P )"

# Sets Working Dir as A Script Location
cd "$(dirname ${BASH_SOURCE[0]})"


# checks if mas, terminal-notifier are installed, if not will promt to install
if [ -z $(which mas) ];
then
  brew install mas
fi

if [ -z $(which terminal-notifier) ];
then
  brew install terminal-notifier
fi

# PopUp Notification
terminal-notifier -title "Brewing..." -message "Updates & Clean Ups" -ignoreDnD

# # Brew Diagnotic
# echo "${yellow}==>${reset} Running Brew Diagnotic..."
# brew doctor 2>&1
# brew missing 2>&1
# echo -e "${green}==>${reset} Brew Diagnotic Finished." 

# # Brew packages update and cleanup
# echo "${yellow}==>${reset} Running Brew&Casks Updates..." 
# brew update 2>&1
# brew upgrade 2>&1
# brew cask outdated 2>&1
# brew cask upgrade 2>&1
# brew cleanup -s 2>&1
# echo "${green}==>${reset} Finished Brew&Casks Updates" 

# # App Store Updates
# echo "${green}==>${reset} Running AppStore Updates..."
# mas outdated 2>&1
# mas upgrade 2>&1

# cd ${scriptPath}
# Creating Dump FIle
brew bundle dump --force 2>&1

# Pushing to Repo
git add . 2>&1
git commit -m "update_${DATE}" 2>&1
git push 2>&1

echo "${yellow}==>${reset} Brew File History Can: https://github.com/fire1ce/brewup/commits/master/Brewfile"
#echo "chnages can be found here: https://git.io/fpzuF"

# PopUp Notification
terminal-notifier -title "Finished Brewing" -message "" -ignoreDnD
echo "${green}==>${reset} All Updates & Cleanups Finnished"
