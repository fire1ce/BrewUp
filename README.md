# BrewUp - macOS Auto Update Homebrew

[![https://3os.org](https://img.shields.io/badge/Follow-https%3A%2F%2F3os.org-orange)](https://3os.org)
![GitHub forks](https://img.shields.io/github/forks/fire1ce/BrewUp?label=Fork)
[![Contribution is Welcome](https://img.shields.io/badge/Contribution%20Is-Welcomed-brightgreen)](https://github.com/fire1ce/BrewUp/blob/master/brewup.sh)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://mit-license.org/)

<p align="center">
    <img src="https://user-images.githubusercontent.com/16795594/152403554-eb859e26-8232-4759-ba27-f025069c6f83.jpg" width=500>
</p>

## Description

Brewup script is a Bash script that uses [Homebrew - The Missing Package Manager for macOS](https://brew.sh/) as it's base.
Brewup uses GitHub as a "backup" of a config file which contains all installed Taps, Formulas, Casks and App Store Apps at your macOS. It also allows the use of **Github** main function of retaining changes so you can always look up for the package that were installed sometime ago and you just forgot what is was exactly.

**Visit as at [3os.org](https://3os.org) for more guides and tips for macOS**

## What Brewup Actually Does

It just runs few [Brew functionality](https://docs.brew.sh/) automatically:

- brew doctor
- brew missing
- brew upgrade
- brew cask upgrade
- brew cleanup
- App Store Updates
- Creating Updated [Brewfile](https://github.com/Homebrew/homebrew-bundle)
- Pushing changes to Git

## Requirements

- [Homebrew The missing package manager for macOS](https://brew.sh/)
- [git (with active account)](https://github.com/)
- Mas, terminal-notifier, coreutils **(will be installed if missing at the first script execution)**

## Installing

Use this repository as template, it will create a `Fork` for you and you can start using it.

```shell
git clone <paste the your repo url here>
```

```shell
sudo ln -s ${PWD}/BrewUp/brewup.sh /usr/local/bin/brewup
```

**Note: if `/usr/local/bin/` is missing create it with**

```shell
sudo mkdir /usr/local/bin/
```

## Usage

just run from terminal:

```shell
brewup
```

Install all apps from BrewFile:

cd to local location you cloned your repository and run:

```shell
brew bundle install --file=<BrewFile Name>
```

## License

### MIT License

Copyright (c) Stas Kosatuhin @2019

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
