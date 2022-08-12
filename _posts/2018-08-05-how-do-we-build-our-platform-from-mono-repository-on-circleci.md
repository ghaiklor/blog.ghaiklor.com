---
title: How do we build our platform from mono-repository on CircleCI
excerpt: >-
  When running builds on continuous integration systems for mono-repositories,
  there are some caveats. I’m telling the story of how did I configure the build
  on our CI in this post.
categories:
  - How-To
tags:
  - mono
  - repository
  - ci
  - continuous
  - integration
  - build
  - diff
header:
  overlay_image: assets/uploads/2018-08-05/construction.jpg
  overlay_filter: 0.5
  caption: Photo by 贝莉儿 DANIST on Unsplash
  teaser: assets/uploads/2018-08-05/construction.jpg
---

Recently, I have published an article where I describe a few tricks about how to
migrate your project from multi-repository to mono-repository. Some of you
really appreciated the topic:

{% include figure image_path="assets/uploads/2018-08-05/tweet-1.png" alt="Tweet" caption="twitter.com/froderik/status/1023810738660548609" %}

However, some of you wanted more details about the build process itself. So, I
have written about that in depth.

## TL;DR on migrations

For those who did not read the article above, I was talking about why we moved
from multi-repository to mono-repository:

- Some of our repositories depended on each other, so sometimes, when you made
  an update in repository A, you needed to make an update of dependency A in
  every other repository B, C, D and so on — development costs.
- We have micro-services… but these services connected with each other (_and it
  is not through an API, but database_). Sometimes, we can not update the only
  one service because it breaks another. That way, we need to share the release
  process across all services and pin them to the same revision and test the
  same revision.

In case you have similar issues, I’d recommend that you consider mono-repository
and read the article above.

_DISCLAIMER: I’m not claiming to have the best method out there and I’m sure it
has problems… But, it works for us, share your solution and I will gladly
discuss it with you._

## Our source code in Git

From now on, I will assume that you have migrated all of your source code to
mono-repository (_or you already have it, without migration_). Through the
article, I will use the following services as an example: _api_ and _frontend_.

Our source code in mono-repository divided into separate folders under the _src_
folder in the repository's root. So, source code of _api_ is under _src/api_
folder and the same for _frontend_ — _src/frontend_.

Each of these services is the separate Node.js project. _src/api_ has its own
_package.json_, _Dockerfile_, lint rules, etc… So, when you are developing
something, you are working under _src/api_ folder, doing _npm install_ there,
_docker build_, well, you know the drill.

We have 17 folders under our _src_ folder (_at the moment of writing the
article_). So, **how did I configure CircleCI to build only what changed,
without building everything on every commit?**

## CircleCI configuration

For configuration, CircleCI uses the file named _config.yml_ under
the *.circleci* folder in the root of your repository. Here is the one I’m using
to build elastic.io platform and we will go through it with explanations (_I
strip it for simplicity_):

{% gist 06dea20241b5fd36bea83a5d95add5ed %}

If you are not familiar with YAML, you won’t understand what aliases are and
what the _&_, _<<_ and _\*_ symbols mean. That is fine. I did not know about
them a few days ago. You can read about them
[here](https://learnxinyminutes.com/docs/yaml/) (_there is a section about
anchors_). You can reuse chunks of your YAML configuration.

I made anchors for all the commons parts of our configuration, like, what is our
environment, where we need to test our platform, what are the steps, etc… at
_aliases_ section.

Common steps in CircleCI configuration are simple:

- Checkout the GitHub repository to _elasticio_ folder
- Restore cache for node modules
- Call a npm _install_
- Save node modules into the cache
- Setup remote Docker engine on CircleCI, so we can use it for building images
- Run custom Bash script I wrote (_we will talk about it later_)

Afterwards, I am just iterating over each project we have at elastic.io, and
adding it into our build jobs. But I’m changing the _working_directory_ field
for each. What does that mean?

_working_directory_ configuration allows you to tell CircleCI, where to run your
steps. So, actually, the steps described above are executing not in the
repository's root, but inside the folder with your service, that is, _src/api_.

Now, imagine that you have pushed a new commit with changes inside _src/api_.
CircleCI triggers the job, gets the configuration file _circle.yml_ and spins
the environment for _front-end_ and _api_ jobs (_since we configure them in
workflows_), setting up and running Docker images. It clones the repository into
_~/elasticio_, switches the context to _~/elasticio/src/api_ via
_working_directory_ configuration and calls _common_steps_ inside of the folder.

As a result, we are getting two environments on CircleCI: _api_ and _frontend_,
where the source code is living. CircleCI called a *npm install* and configured
Docker client to build our images. Our script then —
_~/elasticio/.circleci/run.sh_.

## Our custom runner for tests and Docker images

As you may have noticed, CircleCI spins up the environment for each job,
declared in workflows. Even if you did not make a change there and wanted to
skip the job. Unfortunately, CircleCI can not (_or, I did not find it in their
documentation_) filter jobs, based on some command result.

Based on that fact, we are spinning the environment for each service, living in
our mono-repository, but I’d like to finish building as soon as possible. For
these purposes, I have created our custom _run.sh_ script, that is getting
called every time CircleCI starts the build. What does it do?

First, it compares the diff between previous commit and the latest commit. If
there are changes, it runs tests and builds an image (_the script stripped for
simplicity_):

```shell
if git diff --name-only HEAD^...HEAD | grep "^src/${PROJECT}"; then
  echo "Changes here, run the build"
  npm run test
  docker build --tag elasticio/${PROJECT}:${REVISION}
  docker push elasticio/${PROJECT}:${REVISION}
else
  echo "No changes detected"
  exit 0
fi
```

_NOTE: Remember, that we have a working_directory configuration that changes the
context, where your script is running. So, actually, the script is running under
the project sources, where you can call npm run test, etc._

## Results

We have two files: _config.yml_ and _run.sh_ under the *.circleci* folder.

CircleCI configuration sets up the basic environment, where our Bash script is
responsible for changes detection and running tests and building the Docker
image.

We have 17 services in our mono-repository and CircleCI plan with 4 parallel
containers. The duration of the commit build with changes in one service takes
around ~3 minutes (_that is for the entire mono-repository, including spinning
up basic environment_). These are trade-offs we agreed to take, getting in
exchange for easier project development.

Ask questions regarding this on [Twitter](https://twitter.com/ghaiklor),
[Facebook](https://facebook.com/ghaiklor),
[GitHub](https://github.com/ghaiklor).

---

_Eugene Obrezkov, Senior Software Engineer at elastic.io, Kyiv, Ukraine._
