# brewFileName="brewFile.${HOSTNAME}"
# echo ${brewFileName}
cd $(dirname "$(realpath "$0")")
brew bundle dump --force --file="./BrewFile.${HOSTNAME}"
