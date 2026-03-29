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

extract_mas_entries() {
  local file="$1"

  [ -f "$file" ] || return 0
  grep '^mas "' "$file" || true
}

restore_previous_mas_entries() {
  local previous_file="$1"
  local target_file="$2"
  local temp_file
  local previous_mas

  previous_mas=$(extract_mas_entries "$previous_file")
  [ -n "$previous_mas" ] || return 0

  temp_file=$(mktemp)

  python3 - "$target_file" "$temp_file" "$previous_file" <<'PY'
from pathlib import Path
import sys

target_path = Path(sys.argv[1])
temp_path = Path(sys.argv[2])
previous_path = Path(sys.argv[3])

target_lines = target_path.read_text().splitlines()
previous_mas_lines = [line for line in previous_path.read_text().splitlines() if line.startswith('mas "')]

result = []
inserted = False
for line in target_lines:
    if line.startswith('mas "'):
        continue
    if not inserted and (line.startswith('vscode "') or line.startswith('go "')):
        result.extend(previous_mas_lines)
        inserted = True
    result.append(line)

if not inserted:
    result.extend(previous_mas_lines)

temp_path.write_text("\n".join(result) + "\n")
PY

  mv "$temp_file" "$target_file"
}

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
previousBrewFile=$(mktemp)

cleanup() {
  rm -f "$previousBrewFile"
}

trap cleanup EXIT

## Sets Working Dir to Script Location
if ! command -v realpath >/dev/null 2>&1; then
  brew install coreutils
fi
cd "$(dirname "$(realpath "$0")")"

echo "${blue}==>${reset} Pulling latest changes from repo..."
git pull

if [ -f "./${brewFileName}" ]; then
  cp "./${brewFileName}" "$previousBrewFile"
fi

## Brew Diagnostic
echo "${yellow}==>${reset} Running Brew Doctor diagnostics..."
brew doctor || true
echo "${green}==>${reset} Brew Doctor diagnostic finished."

## Brew packages update and cleanup
echo "${yellow}==>${reset} Updating Homebrew metadata..."
brew update-if-needed
echo "${green}==>${reset} Homebrew metadata updated"

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

previousMasEntries=$(extract_mas_entries "$previousBrewFile")
currentMasEntries=$(extract_mas_entries "./${brewFileName}")

if [ -z "${BREWUP_ALLOW_MAS_REMOVALS:-}" ] && [ -n "$previousMasEntries" ]; then
  removedMasEntries=$(comm -23 <(printf '%s\n' "$previousMasEntries" | sort) <(printf '%s\n' "$currentMasEntries" | sort) || true)

  if [ -n "$removedMasEntries" ]; then
    echo "${yellow}==>${reset} Warning: Detected missing Mac App Store entries in generated ${brewFileName}."
    echo "${yellow}==>${reset} Restoring previous mas entries to avoid committing Spotlight indexing fallout."
    echo "${yellow}==>${reset} Set BREWUP_ALLOW_MAS_REMOVALS=1 to allow intentional mas removals."
    restore_previous_mas_entries "$previousBrewFile" "./${brewFileName}"
  fi
fi

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
