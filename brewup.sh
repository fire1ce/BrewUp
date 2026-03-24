#!/bin/bash
set -euo pipefail

PATH="/usr/local/bin:/usr/local/sbin:/Users/${USER}/.local/bin:/usr/bin:/usr/sbin:/bin:/sbin"

## M1 Brew PATH Fix
if [ "$(arch)" = "arm64" ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

## Suppress Homebrew auto-update and hints (updates handled by brew upgrade)
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1

## checks if mas is installed, if not will install it
if ! command -v mas >/dev/null 2>&1; then
  brew install mas
fi

DATE=$(date '+%Y%m%d.%H%M')
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)
brewFileName="Brewfile.$(hostname -s)"

## Sets Working Dir to Script Location
if ! command -v realpath >/dev/null 2>&1; then
  brew install coreutils
fi
cd "$(dirname "$(realpath "$0")")"

echo "${blue}==>${reset} Pulling latest changes from repo..."
git pull

## Brew Diagnostic
echo "${yellow}==>${reset} Running Brew Doctor diagnostics..."
brew doctor || true
echo "${green}==>${reset} Brew Doctor diagnostic finished."

## Brew packages update and cleanup
echo "${yellow}==>${reset} Checking for brew updates..."
brew upgrade
brew cleanup -s || true
echo "${green}==>${reset} Finished brew updates"

## Mac Store Updates
echo "${yellow}==>${reset} Checking macOS App Store updates..."
mas upgrade || echo "${yellow}==>${reset} Warning: Mac App Store update failed (not signed in?)"
echo "${green}==>${reset} Finished macOS App Store updates"

## Creating Dump File with hostname
brew bundle dump --force --file="./${brewFileName}"

## Pushing to Repo
echo "${blue}==>${reset} Pushing changes to repo..."
git add "./${brewFileName}"
if ! git diff --cached --quiet; then
  added=$(git diff --cached "./${brewFileName}" | grep '^+[^+]' | sed 's/^+//' | paste -sd ', ' - || true)
  removed=$(git diff --cached "./${brewFileName}" | grep '^-[^-]' | sed 's/^-//' | paste -sd ', ' - || true)
  msg="${DATE}_update"
  [ -n "${added}" ] && msg="${msg} | Added: ${added}"
  [ -n "${removed}" ] && msg="${msg} | Removed: ${removed}"
  git commit -m "${msg}"
  git push
else
  echo "${green}==>${reset} No changes to commit"
fi

echo "${green}==>${reset} Finished updating brew and mas packages"
