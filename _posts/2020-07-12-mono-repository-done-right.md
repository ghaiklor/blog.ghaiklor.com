---
title: Mono repository done right!
excerpt: >-
  I’ve been working in mono repository for some time, using different build
  tools for that. In this article, I’m sharing my thoughts about “ideal” mono
  repository build tool and setup.
categories:
  - Thoughts
tags:
  - lerna
  - rush
  - mono
  - repository
  - npm
  - pnpm
  - build
  - tool
  - vscode
header:
  overlay_image: assets/uploads/2020-07-12/containers.jpg
  overlay_filter: 0.5
  caption: Photo by Timelab Pro on Unsplash
  teaser: assets/uploads/2020-07-12/containers.jpg
layout-screenshots:
  - url: assets/uploads/2020-07-12/npm-layout.png
    image_path: assets/uploads/2020-07-12/npm-layout.png
    alt: npm layout
    title: npm layout
  - url: assets/uploads/2020-07-12/pnpm-layout.png
    image_path: assets/uploads/2020-07-12/pnpm-layout.png
    alt: pnpm layout
    title: pnpm layout
---

I worked with different repository setups: separate repositories per project,
meta repositories with git sub-modules, mono repositories where everything is a
single monolith or separate projects just in one git repository.

Every setup has its pros and cons, but eventually, industry comes up with some
setup that works so great, both on CI/CD systems and local machines, that it is
hard to fight the fact that mono repositories earned its place under the sun.

I want to share with you one of these setups I came up, when experimenting on my
pet project, and then, a setup that is used at our work and proved itself in
production.

## Package Manager

Let us start from a thing that usually no one pays attention to, but it is
important to understand. I’m talking about _node_modules_ layout - **it is a
mess!**

Its layout is, well... “ok” for a single repository with a single project, but
right from the moment when you convert your repository to mono repository,
**node_modules become such a mess, increasing entropy and non-determinism in
many times** (_especially, when you hoist dependencies_).

Did you hear about such a thing as
[transitive dependency](https://en.wikipedia.org/wiki/Transitive_dependency)?
Node.js ecosystem usually refers to it as a "phantom dependency".

> A transitive dependency is any dependency that is induced by the components
> that the program references directly.
>
> Wikipedia

These are the dependencies that are used by your direct dependencies in the
_package.json_ file.

E.g. you have a dependency _jest_, _jest_ has its dependencies, like
_jest-circus_ and others. You do not require _jest-circus_ directly, but it is
still downloaded and bundled into your _node_modules_ folder because it is a
dependency that _jest_ is using, not you.

You may ask, so what? **The problem is that you can easily require those
transitive dependencies without saying you need them in _package.json_**. Hence,
you do not control what packages are installed, what version, **you are using
the dependency that is controlled by third-party, not you**.

Believe it or not, but many issues arise from this. This behavior is so
non-deterministic that you can’t even be sure that setup on your local machine
is the same as your colleagues, installed from a single revision. How many times
we debug issues in production that, as turned out, was caused by the transitive
dependency... I can’t count them.

You may say “_lock files are for the rescue!”_, yes, you are right, they help.
Although, they do not resolve the issue with transient dependencies; they just
pin them.

There is a solution - another package manager! **The problem with npm and yarn
is that they conform "classic" node_modules layout where everything is
flattened**, hence, any transitive dependency is accessible in your code - EVIL!

[pnpm](https://pnpm.js.org) is a solution for this case. Instead of flattening
everything in _node_modules_, pnpm flattens dependencies in his own virtual
store that is not accessible to Node.js. But, to make your direct dependencies
accessible, pnpm makes soft links from its virtual store (_usually at
node_modules/.pnpm folder_) to _node_modules_ folder.

Here, a comparison of how _node_modules_ looks like with npm (_on the left_) and
pnpm (_on the right_).

{% include gallery id="layout-screenshots" caption="npm vs. pnpm layouts" %}

Did you find a difference? I bet you do! Why do I need _acorn_ in my
dependencies? _ansi-regex_? _array-unique_? What? These are dependencies that I
can require in my code, although I did not specify them as my direct
dependencies.

On the other side there is a pnpm layout, where only those dependencies I
specified are accessible. Try to require some dependency that you did not
specify - error on the build! It is better that non-deterministic and implicit
behavior on the production, right? I hope so, and I hope you understand that.

NOTE: if you are interested where are those dependencies stored and how do they
still accessible for your dependencies, you can read more about on
[pnpm blog](https://pnpm.js.org/blog/2020/05/27/flat-node-modules-is-not-the-only-way).
{: .notice--info }

Ok, enough with the package manager and some layouts. I'm here to share my setup
after all and the reasoning behind my choice, not to change yours.

My package manager of choice - [pnpm](https://pnpm.js.org) and only pnpm!

## Build Tool

pnpm helped us to get rid of evil _node_modules_ layout, but we are still in
need to manage our projects inside the repository, run tasks there, etc. For
most cases, pnpm is still a choice, it has so called
“[workspaces](https://pnpm.js.org/en/workspaces)” concept and you can specify
each of your projects as a pnpm workspace.

But... there are cases when **you need a tool, that can help you scale your mono
repository from a few projects to hundreds and thousands** and still be easy to
use.

We need a tool that will make installation process faster. A tool that does not
lose its head when running inside a repository with a hundred of projects. A
tool that provides a way to manage across separate teams. You got the idea; we
are talking about vast repositories here.

**The tool that is called - [Rush](https://rushjs.io)!**

When you are installing dependencies through the Rush, it does not install them
in each project. Instead, it collects every dependency from all the projects in
one place and installs everything in this place. Afterwards, it hard links them
between all the projects as if install was called in each of them.

It creates a lock file that locks the dependencies state across the whole
repository, not individual projects. Meaning, every time when **you call install
command, it will install everything and links everything together the way it
always was - deterministic**!

Once you build all the projects, **Rush will not rebuild again on each
consecutive call**. Instead, it will check for changes and build only those
projects that were changed - **incremental compilation**. There are no blockers
to implement distributed multi-machine builds, although it is not implemented
yet.

{% include figure image_path="assets/uploads/2020-07-12/rush-compilation.gif" alt="Rush Build" caption="rush rebuild vs. rush build" %}

**You can customize its CLI and add your own commands**. E.g. you want to add a
"test" command that will run npm script "test" in each of the projects. But! You
want to say that it should ignore topology and run in parallel. Or, you want to
add a command, let us say, "changelog", that generate a change log for your
repository. The fact that it is possible makes **Rush CLI an entry point to your
mono repo management**, where custom scenarios are implemented as Rush CLI
commands you can use from anywhere in the repository.

{% include figure image_path="assets/uploads/2020-07-12/rush-parallel-tasks.gif" alt="Rush Parallel Tasks" caption="test and lint on all core threads" %}

A lot more… We are not talking about simple “_just run the npm script in each
folder_”. **We are talking about vast organizations, cross-team interaction,
different bump strategies depending on the case, fast builds with incremental
compilation - everything in one repository and a single build tool**.

So, if you ask me what to choose, just a package manager, Lerna, Rush or
something else? I’d say…

How many projects do you have? Are they just npm packages? pnpm or yarn
workspaces is enough.

Do you want to parallelize things, but you still have a small repository and you
can’t foresee its growth? Well… lerna is your choice, but I’m not sure anymore.
If any, migration from Lerna is easy.

Do you have a large team, different delivery strategies, containerized services
and a farm with 64 cores on CI? Rush!

## Editor Integration

The last piece on the cake is - editor integration. We want to have an
exceptional developer experience when working in mono repo, right?

In case you worked in mono repository before, with hoisted dependencies to
improve installation time, **I believe you could face issues with types
conflict, or some other stuff that editor could not analyze**, hence worsening
developer experience.

For instance, you have a project X that uses Mocha for tests and project Y that
uses Jest. You installed both types for Mocha and Jest. But, if you hoisted
dependencies up, **those types will be in conflict with each other**.

{% include figure image_path="assets/uploads/2020-07-12/types-conflict.png" alt="Type Error" caption="@types/jest can not be resolved" %}

Why? Because editor, in my case VSCode, **treats opened mono repository as a
single project, while we treat its content as a lot of smaller projects**.

To handle that one issue, you need to open projects from the mono repository
separately, treat projects as if they are separate repositories, like we did it
a few years ago. Forget about the fact that it is a mono repo that shares its
dependencies, links projects between and stuff.

**VSCode has a concept of custom workspaces and folders in it. Use it!**
Moreover, I recommend installing the extension that can synchronize your Rush
projects to VSCode workspace by calling a single command from its pallet -
[vscode-monorepo-workspace](https://github.com/folke/vscode-monorepo-workspace).

{% include figure image_path="assets/uploads/2020-07-12/vscode-monorepo-ext.gif" alt="VSCode Monorepo Workspace" caption="VSCode Monorepo Workspace Extension" %}

That way, VSCode knows more and doesn’t make assumptions about what to resolve
and what not. Imagine what is going on under the hood in VSCode when it tries to
resolve dependencies, evaluate types and so on and so forth for the entire
repository, thinking it is all a single project. Help him and split your sub
projects in separate folders in the workspace.

## Was it worth it

I mean… I used Lerna and npm before and have no issues, but not because there
were no issues, but because I did not know about them. **Was it worth it to
migrate to Rush and pnpm? Totally, yes!**

Using pnpm increases an installation time by factor compared to npm and yarn and
it does not have a “classic” _node_modules_ layout that can break things you
even don’t know about.

Rush is a tool to manage your mono repository. Customizable in mind, allows to
configure your own CLI commands, acts like an entry point to anything in the
repository. Has incremental and parallel builds, deterministic installs, built
with pnpm as a first-class citizen.

So my answer to the question and the last word - YES!

## References

- [pnpm website](https://pnpm.js.org)
- [pnpm node_modules structure](https://pnpm.js.org/en/symlinked-node-modules-structure)
- [pnpm workspaces](https://pnpm.js.org/en/workspaces)
- [Rush website](https://rushjs.io)
- [Why one big repository?](https://rushjs.io/pages/intro/why_mono/)
- [The problem with transient dependencies](https://rushjs.io/pages/advanced/phantom_deps/)
- [VSCode extension for mono repositories](https://github.com/folke/vscode-monorepo-workspace)
- [My pet project built on Rush + pnpm](https://github.com/ghaiklor/kittik)

---

_Eugene Obrezkov, Software Engineer at Wix.com, Kyiv, Ukraine._
