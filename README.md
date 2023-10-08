# Personalized Development Environment

This is my personalized config and plugins for [Neovim](https://neovim.io).

## Install Neovim

Install Neovim from a package manager of your choice e.g. brew, apt, pacman
etc.. For this config we need to have Neovim version 0.8 or higher.

On a Mac:

```sh
brew install neovim # For latest stable Neovim
brew install --HEAD neovim # For Neovim nightly version
```

If you would like to make sure Neovim only updates when you want it to
than I recommend installing from source:

```sh
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

## Install the config

Make sure to remove or move your current `nvim` directory

```sh
git clone https://github.com/rgruyters/nvim.git ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed

**NOTE** (You will notice treesitter pulling in a bunch of parsers the
next time you open Neovim)

**NOTE** Checkout this file for some predefined keymaps:
[keymaps](https://github.com/rgruyters/nvim/blob/main/lua/grtrs/keymaps.lua)

## Get healthy

Open `nvim` and enter the following:

```neovim
:checkhealth
```
