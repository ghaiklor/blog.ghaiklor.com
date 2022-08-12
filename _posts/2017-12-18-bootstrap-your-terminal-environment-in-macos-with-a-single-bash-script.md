---
title: Bootstrap your terminal environment in MacOS with a single Bash script
excerpt: >-
  Many people don’t spend their time to configure terminal environment and just
  uses what OS gives out of the box. Many people really care about their
  environment and spend a lot of time to configure one. What if we could
  automate part of the process?
categories:
  - Tools
tags:
  - bootstrap
  - terminal
  - developer
  - environment
  - macos
  - bash
  - fish
  - shell
  - fisher
  - plugins
header:
  overlay_image: assets/uploads/2017-12-18/macbook.jpg
  overlay_filter: 0.5
  caption: Photo by Kyle Sung on Unsplash
  teaser: assets/uploads/2017-12-18/macbook.jpg
---

## Problem

Some error in the terminal, oh, I forgot to install X...

How did that work before? Oh, I had plugin Y, but I don’t remember its name...

Who enjoys remembering all the fishy commands? I don’t...

Burn out my own eyes with a default theme and colors? No, thanks...

Navigating through a plugin repository of your shell to find out all plugins you
had again? No, thank you...

## Solution

It might sound silly, but write all the steps, dependencies, plugins, etc. you
install somewhere in notes or gist.

It **was** my solution before. I had a gist where I wrote all the steps I needed
to do for setting up my glance terminal. You can look into it
[here](https://gist.github.com/ghaiklor/5c393e1c27cab79a9258).

And you know what? **It has a huge amount of steps I need to do every time
manually**, while setting up my terminal environment: install Git, Homebrew,
download iTerm, install color scheme and nerd font, download and configure shell
and so on, and so on...

**It’s boring, we need to fix that!**

> Automation is good, so long as you know exactly where to automate.
>
> _Eliyahu Goldratt_

## Solution v2

What if, we do the same as before, but write the steps in Bash script instead?

That’s how I came up with an idea of **creating a common Bash script** that will
do all the steps I do manually, but on its own.

GitHub repository was born, Gist updated regarding newly created repo, initial
commit with Bash script was created ->
[repository link](https://github.com/ghaiklor/iterm-fish-fisher-osx).

## Testing

Turns out, it worked perfect. Everything from my setup installed correctly.

**I got my development environment just by executing Bash script with a single
command in terminal** _(while drinking my coffee at the kitchen)_.

But I didn’t like hard-coded steps, even when I have some of required
dependencies, for instance, Command Line Tools.

Why do I need to install something that I already have?

## Solution v3

**I improved the bash script with control flow instructions.**

From now on, script could understand what you have installed and what not.

_Do you have Command Line Tools installed? Ok, skip… Do you have iTerm installed
already? Ok, skip… Do you want to have my color scheme or font? No, skip…_

I did modifications, script was published and tested out on my friends — works
with no issues!

## Do I need this script

Well, you may ask this question to yourself and I will give you the answer.

_Do you work with terminal a lot, but too lazy to set it up? — Yes. Is my setup
fine for you and you like it? — Yes. Do you have your own configuration? —
Possibly, no._

## What exactly am I setting up

- Command Line Tools (_xcode-select --install_)
- Homebrew (_ruby -e {HOMEBREW_INSTALLER}_)
- iTerm2 (_brew cask install iterm2_)
- Material design theme for iTerm2 and patched nerd fonts
- Fish Shell (_brew install fish_)
- Fisherman (_curl -o ~/.config/fish/functions/fisher.fish {FISHERMAN}_)
- 18 plugins for Fish (_curl {MY_INSTALLER.sh} && ./MY_INSTALLER.sh_)

## Thanks

Thanks for reading. Please share it with your friends who are frustrated with
setting up the environment.

Do you have any suggestions and ideas for further improvements? Please, ping me
on [Twitter](https://twitter.com/ghaiklor) or raise an
[issue in repo](https://github.com/ghaiklor/iterm-fish-fisher-osx/issues/new).

---

_Eugene Obrezkov, Senior Software Engineer at @elastic.io, Kyiv, Ukraine._
