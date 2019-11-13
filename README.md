# BrewUp - macOS Auto Update Homebrew

## Description

Brewup script is a Bash script that uses [Homebrew The missing package manager for macOS](https://brew.sh/) as it's base.
Brewup uses GitHub as a "backup" of a config file which contains all installed Taps, Formulas, Casks and App Store Apps at your macOS. It also allows the use of __Github__ main function of retaining changes so you can always look up for the package that were installed sometime ago and you just forgot what is was exactly.
It's soul propose is cheek for "Homebrew" to run

## What Is Brewup Actually Do

It just runs few [Brew functionality](https://docs.brew.sh/) automatically:

* brew doctor
* brew missing
* brew upgrade
* brew cask upgrade
* brew cleanup
* App Store Updates
* Creating Updated [Brewfile](https://github.com/Homebrew/homebrew-bundle)
* Pushing changes to Git

## Requirements

* [Homebrew The missing package manager for macOS](https://brew.sh/)
* [git (with active account)](https://github.com/)
* Mas, terminal-notifier, coreutils __(will be installed if missing at the first script execution)__

## Installing

```bash
git clone git@github.com:fire1ce/brewup.git
ln -s ${PWD}/brewup/brewup.sh /usr/local/bin/brewup
source ~/.zshrc
```

## Usage

Update & Backup

```bash
brewup
```

Install from brewFile

```bash
cd to __brewFile__ location
brew bundle install --file=<brewFile name>
```