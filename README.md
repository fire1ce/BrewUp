# Brewup

Brew - Update &amp; Backup

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