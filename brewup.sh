DATE=$(date '+%Y%m%d.%H%M')
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)
brewFileName="Brewfile.${HOSTNAME}"

# Sets Working Dir as Real A Script Location
if [ -z $(which realpath) ]; then
    brew install coreutils
fi
cd $(dirname "$(realpath "$0")")

git pull 2>&1

# checks if mas, terminal-notifier are installed, if not will promt to install
if [ -z $(which mas) ]; then
    brew install mas
fi

# Brew Diagnotic
echo "${yellow}==>${reset} Running Brew Diagnotic..."
brew doctor 2>&1
brew missing 2>&1
echo -e "${green}==>${reset} Brew Diagnotic Finished."

# Brew packages update and cleanup
echo "${yellow}==>${reset} Running Brew&Casks Updates..."
brew update 2>&1
brew upgrade 2>&1
brew cask outdated 2>&1
brew cask upgrade 2>&1
brew cleanup -s 2>&1
echo "${green}==>${reset} Finished Brew&Casks Updates"

# App Store Updates
echo "${green}==>${reset} Running AppStore Updates..."
mas outdated 2>&1
mas upgrade 2>&1

# Creating Dump File with hostname
brew bundle dump --force --file="./${brewFileName}"

# Pushing to Repo
git add . 2>&1
git commit -m "${DATE}_update" 2>&1
git push 2>&1

echo "${green}==>${reset} All Updates & Cleanups Finnished"
