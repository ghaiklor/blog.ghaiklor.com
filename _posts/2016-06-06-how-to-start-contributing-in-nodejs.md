---
title: How to contribute in Node.js?
excerpt: >-
  You want to contribute to some open source project and chose Node.js, don’t
  you? If so, here are some guidelines on how to contribute there, set up
  development environment, etc.
categories:
  - How-To
tags:
  - node.js
  - javascript
  - github
  - git
  - repository
  - open source
  - contributing
header:
  overlay_image: assets/uploads/2016-06-06/road.jpg
  overlay_filter: 0.5
  caption: Photo by Matt Duncan on Unsplash
  teaser: assets/uploads/2016-06-06/road.jpg
---

Some of you want to or thought about contributing into Node.js core but don’t know how to do it or don’t have enough confidence.
Well, I’ll try to help you out with that.

I am an outside collaborator in Node.js and sometimes I look into issues and take some.
Also, I already have a few pull requests successfully landed into Node.js core, so I will tell you about my experience.

Let’s start with running it locally.

## Cloning the repository

The first thing you have to do is fork the repository to your account.

Afterwards, clone the source code of the Node.js repository to your host machine from the fork.

At this step, you have two remotes: **origin** is for your fork and **upstream** is for Node.js original repository.
BTW, **upstream** still need to be added by you manually.
To do this, add upstream via _git remote_ in your project folder.

```shell
git remote add upstream git@github.com:nodejs/node.git
```

You should have two remotes now, you can check it like this:

```shell
$ git remote -v
origin git@github.com:ghaiklor/node.git (fetch)
origin git@github.com:ghaiklor/node.git (push)
upstream git@github.com:nodejs/node.git (fetch)
upstream git@github.com:nodejs/node.git (push)
```

Now, let’s compile, so you can run it.

## Compiling Node.js

Thanks to Node.js contributors, we have scripts you can call and compile easily.

```shell
./configure
make
```

_./configure_ scripts configures all the needed files for compilation.
_make_ compiles all the needed sources.
As a result, you will get compiled binary in the same folder called _node_.
Basically, it’s just a symlink to _out/Release/node_.

You can test it out and check if everything goes well:

```shell
node -v
```

It should print the current version of Node.js.

That’s it with compiling, nothing else.
Now, let’s say you take some issue and want to fix it.
What to do next?

## Fixing the issue

Imagine, you take issue **#1234**.

First, create a branch for it from the **master** branch:

```shell
git checkout -b fix/1234 master
```

Naming conventions can be different, but I’m using the following format: `<TYPE>/<NUMBER>`.
For instance, _fix/1234_, _feature/5678_ and so on.
Think of it as you have folders and files in it.

Ok, you have a branch for your fix, and you have made some changes.
BTW, it’s worth noting that you **MUST** try to change as few lines as you can.
If you have changed some line just because of the wrong space indent, the most of the time it will not go through a code review.
Remember this.

After some time, you finally fixed the issue locally, great.
You have done a few commits in branch _fix/1234_.

```shell
git commit -m "repl: describe the fix here"
git commit -m "repl: one more typo fix and so on..."
```

What’s next?
Run tests to make sure everything is working.

## Running tests locally

We have a script in _Makefile_ for this as well:

```shell
make test
```

You can specify a number of cores for running the tests.
To do this, add _-j_ flag.

```shell
make -j8 test
```

It will run a series of checks, including the linter checks, tests.
If everything is passed with no errors, you are free to go with a pull request.
Otherwise, continue with fixing and figuring out why tests are broken.

## Creating a pull request

Push your branch with changes to **origin** repository:

```shell
git push origin fix/1234
```

Go to Node.js repository in Pull Requests tab and press the “New Pull Request” button.
In the _head fork_ specify your fork and in _compare_ specify the branch you’ve just pushed.
Review the changes and create the pull request.

All you can do now is wait for feedback from the team.
You can push new commits only in the same branch you’ve pushed to origin.
After some time, the team says you “LGTM”, which means “Looks Good To Me”.
That is time you need to squash commits.

## Squash the commits

You can Google many ways to squash the commits into one, but I’m doing it with the _reset_.

```shell
git reset --soft master
git add .
git commit
git push --force origin fix/1234
```

That way you’re getting one commit that you can push with the _force_ flag, so the Node.js team can easily merge it into the master branch with clean history.

## Stay up to date

From time to time, you need to get the latest changes in a **master** branch from the other team.
To do this, you can use **fetch** and **rebase** commands.

I’m doing the following series of commands (some of them I’m doing just in case, you know):

```shell
git checkout master
git fetch upstream
git pull origin master
git rebase upstream/master
git push origin master
```

That way, the **master** branch is always up to date with the original repository.

## Summary

That’s it.
You can leave your thoughts and responses here and I’ll update this article.

The main point of this article is simple — don’t be afraid to contribute into the projects you like.
That’s not as scary as you think, anyway, that’s how I felt in the beginning.

---

*Eugene Obrezkov, Developer Advocate at [Onix-Systems](https://onix-systems.com), Kirovohrad, Ukraine.*
