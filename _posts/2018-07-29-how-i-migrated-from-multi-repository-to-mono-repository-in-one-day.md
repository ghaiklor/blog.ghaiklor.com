---
title: How I migrated from multi-repository to mono-repository in one day
excerpt: >-
  When working in a multi-repository setup, it quickly becomes hard to work with
  them. Especially, when you have cross-repository dependencies and you need to
  propagate changes between them. In this post, I’m telling the story of how did
  we migrate to mono-repository setup.
categories:
  - How-To
tags:
  - multi
  - mono
  - repository
  - migration
  - story
header:
  overlay_image: assets/uploads/2018-07-29/repository.jpg
  overlay_filter: 0.5
  caption: Photo by Paolo Chiabrando on Unsplash
  teaser: assets/uploads/2018-07-29/repository.jpg
---

We had a lot of repositories for different services.
There are 20K+ commits in 15+ repositories.
Each repository has its own Dockerfile, tests, lint rules, etc.

Turns out, it’s hard to maintain, especially when you have dependent repositories across.
E.g. you have repository _api_ that is using a package from another repository, let’s say _commons_.
If you publish an update in _commons_, you need to go through all the dependent repositories and update _commons_ there.

Now, just imagine how long it takes, to make a clone of each repository, make an update there and push changes back to remote.
It’s hard to say for me, but these kinds of updates were leading to half a day work just for updating the changes in other repositories.
Therefore, **we allocated resources for changing that**.

But, before I started migration to a mono repository, I spent some time investigating the pros and cons of other alternatives.

## What to choose

### Multi-repository

**You have a lot of repositories for each service.**

{% include figure image_path="assets/uploads/2018-07-29/multi-repository.png" alt="Multi Repository Setup" caption="Each package is in its own repository" %}

Pros:

- You, as an admin of organization, can easily manage access to different parts of your platform. For instance, you do not want to allow access to an _api_ repository for frontend developers and so on
- CI/CD is easier to implement, because all you need is just some configuration file in root of your project, which will trigger build job every time you make a commit

Cons:

- In case some of your repositories depend on each other, a single change in a repository can lead to **required updates of others**

### Mono-repository

**You have only one repository, where you handle all the services.**

{% include figure image_path="assets/uploads/2018-07-29/mono-repository.png" alt="Mono Repository Setup" caption="Each package is in a single repository" %}

Pros:

- You still have micro-services, but you can locate them in the same folder, of the same repository. So, if you are working on a big feature that requires changes in several services, it’s easier to make them in one repository, but not in the bunch of them

Cons:

- Opposite of multi repository, you can not disallow/allow access to different parts of your platform. If you give access to a repository, you are giving access to all the source code;
- Another opposite to multi repository — CI/CD. Every commit in your mono repository will trigger the build of every line of the code of every service in your mono repository _(we will talk more about it later)_

### Meta-repository

**You still have a multi repository, but in addition, you have an abstract (meta) repository where you can combine all the repositories into one.**

Pros:

- ?

Cons:

- ?

Honestly, I tried several tools for meta repositories and couldn’t find neither pros nor cons.
All I can say about the concept of meta repositories is that tooling is not ready for such repositories.

As each of them has its own pros and cons, it turns out that for our case in **elastic.io mono-repository suits best**.

## Migrating repositories into mono repository

So, the question #1 you will definitely face if you will migrate repositories as well — **how do you keep the history and do not lose your sanity by doing a lot of copy-paste-merge-do-again job**?

Well, git has some tools exactly for this job — [git subtree](https://git-scm.com/book/en/v1/Git-Tools-Subtree-Merging).

Let me show you an example of merging two repositories into one.
Let’s say, you have a service called _api_.
You store it in _api_ repository.
The same applies to, let’s say, _frontend_ service repository.

You want to merge _api_ and _frontend_ repositories into new mono repository, called _my-awesome-mono-repo_.

```shell
cd my-awesome-mono-repo
git init
git subtree add -p src/api github.com:org/api.git master
git subtree add -p src/frontend github.com:org/frontend.git master
```

_git subtree add_ means, take the whole tree from the remote repository and add it to my current repository.
"-p" means, prepend all the changes in remote tree, as if it happened in my current repository in another folder.

Because of those commands, you will get the folders _src/api_ and _src/frontend_.
It will store the entire history of all changes and you will be able to do _git blame_ or whatever you want.

That way, I migrated all our services into one repository with saving the history of changes.

Now, how do we make a build process for our mono repository?

## Preparing build process for mono repository

We had a lot of repositories with their own builds, tests, etc…
Also, each commit in mono repository will trigger the build of everything, not only the changed part.
So, how did I configure the build process for mono repository then?

Turns out, it’s simple.

First, before running any build, I must ensure that the changes in the commit you have pushed to remote are related to the service I want to build.
We can easily achieve it via _git diff_ command.

```shell
git diff --name-only HEAD^ HEAD | grep "^src/your_project_name_here"
```

The command compares previous commit with the current commit and prints only the filenames of files that were changed.
Afterwards, I can use grep to check if changes were related to a certain service.

That way, I have implemented some kind of filtering on our CI servers.
When a basic environment is spinning up, it runs my Bash script to check, if the environment should expand further for running tests and build or it can just skip the whole build job, since it has none changes in it.

## Epilogue

All I can say about the migration and our experience with mono repository at elastic.io — it is good enough.
We have more problems with CI/CD, but we do not have screams from the team anymore _(especially, when they are updating 15+ repositories because of some change in a single one)_.

Follow me on [Twitter](https://twitter.com/ghaiklor/), [Facebook](https://www.facebook.com/ghaiklor), [GitHub](https://github.com/ghaiklor), ask questions.

---

*Eugene Obrezkov, Senior Software Engineer at elastic.io, Kyiv, Ukraine.*
