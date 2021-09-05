---
title: VSCode extensions for TypeScript projects
excerpt: >-
  The community of VSCode is enormous, and it has created a lot of extensions.
  Some of these extensions are really increasing productivity when working with
  TypeScript projects. In this post, I’m sharing my opinionated list of
  extensions that you must have installed in your VSCode.
categories:
  - Tools
tags:
  - VSCode
  - Visual Studio Code
  - TypeScript
  - Extensions
  - List
  - Collection
header:
  overlay_image: assets/uploads/2021-09-05/extensions.jpg
  overlay_filter: 0.5
  caption: Photo by Ferenc Almasi on Unsplash
  teaser: assets/uploads/2021-09-05/extensions.jpg
---

VSCode has a great API to create your own extensions, as far as I can judge.
And the people are using this rich API to create their own extensions.
Some of them are not so useful and created just for fun, but some of them are really helpful when you are writing TypeScript code.

So that, I want to share with you my opinionated list of extensions I’m using during TypeScript development.

Please note, I’ve crafted the list of extensions based on my frequency rate (how many times I’m using the extension when working with TypeScript).
So that, you can see some extensions that are not directly involved with TypeScript, but are really useful anyway.
{: .notice--info }

## TL;DR

In case you don’t want to spend your time reading the excerpts for the extensions, here is the list with the links.
You can just go there and install everything from the list and forget about the post.

- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens)
- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
- [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [Git Project Manager](https://marketplace.visualstudio.com/items?itemName=felipecaputo.git-project-manager)
- [Monorepo Workspace](https://marketplace.visualstudio.com/items?itemName=folke.vscode-monorepo-workspace)
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [IntelliJ IDEA Keybindings](https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings)

## ESLint

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)

When working with TypeScript, usually, a team also configures ESLint with such plugins like [typescript-eslint](https://github.com/typescript-eslint/typescript-eslint).
While the team gets the compiler and linter for their TypeScript code base, they don’t get the immediate feedback loop about linter errors in their editor.

The author of this extension resolved the problem by introducing the ESLint errors propagation to “Problems” view of your editor.
So that you can see all the compilation and linter errors right in your IDE.

## Error Lens

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens)

Having compiler errors and linter errors right in your IDE (in the “Problems” view) is great!
But, turns out we can get even more!
By using lenses, the extensions that are provide useful information right into your text view.

For example, if you have some issues with the code, you will get all the errors and warnings right by source code side.

{% include figure image_path="assets/uploads/2021-09-05/error-lens-demo.png" alt="Error Lens Demo" caption="Error Lens Demo" %}

This extension is really increases productivity in a sense that you don’t need to navigate to other panes.
You see all the problems right in your editor.

## Markdown All in One

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)

We work with TypeScript a lot.
But also we work a lot with documentation for our code.
I don’t know about you [reader], but we have a common practice - documenting the code.

The rule of a thumb is to use Markdown for such matters.
But VSCode does not have much features to assist you with that.

For example, you need to create a table of contents for your huge README file.
Or, you want to add numbers to your sections automatically.
“Markdown All in One” does all of it and more.

By using the extension, you can get hot keys for formatting the document.
Commands for creating the ToC, ordering the lists, math support, formatting and more.

## markdownlint

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)

Writing the documentation in Markdown with the help of “Markdown All in One” extension is really easy.
But the extension does not check for common errors or formatting issues.

That is why “markdownlint” extension is also must have to be installed.
It helps you lint the Markdown files and report any issues that your Markdown file has.
These issues can be automatically fixed if you are using code action on save (we’ll talk about it later on).

## GitLens — Git supercharged

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)

VSCode has a built-in support for version control systems.
But there are some missing features like showing the blame of the line alongside with the code.
Or separate view for branches, commits, file history and so on.
The list can go on and on.

In case you are using such views, want to have interactive rebase editor, heat maps for your code based on git activity - this extension is definitely for you.

## Git Project Manager

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=felipecaputo.git-project-manager)

Any of us is working with over one Git repository on a local machine.
When talking about VSCode without this extension, you (usually) open the folder through a command palette or toolbar at the top.

We can simplify the flow by using this extension.
When installed and configured with the list of the folders where you keep your Git repositories, it becomes much easier.
Now, you can just call a command “Open Git Project” and you will get a list of all Git repositories you have and open the project from the list.
Really handy!

{% include figure image_path="assets/uploads/2021-09-05/git-project-manager-demo.gif" alt="GPM Demo" caption="GPM Demo" %}

## Monorepo Workspace

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=folke.vscode-monorepo-workspace)

Some of us working with mono repositories setup.
By that I mean the repositories, where more than one package or application exists.
But, in a single Git repository.

If you are using Lerna, Rush or just plain package manager workspaces - you are in mono repository setup!
What is the problem with such a setup when talking about the VSCode without this extension?

The problem is that VSCode tries indexing the whole repository, while it should index only the specific package from it.
This extension provides a way to open the “slices” of your mono repository.
It provides you with the command, where you can open just a specific package of the mono repository like it was not part of it at all.
That is why I’m calling it a “slice”.

A really handy extension you must have if you are working with mono repositories setup.

{% include figure image_path="assets/uploads/2021-09-05/monorepo-demo.gif" alt="Monorepo Workspace" caption="Monorepo Workspace" %}

## Code Spell Checker

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

I’ve included this extension in the list, because I’m sick of code that has spelling errors.
Turns out, this is a much bigger problem than I thought.

Starting from the spelling errors in your variable naming to spelling errors in your Markdown documentation or comments - it is a disaster!
Please, don’t make such errors in your code.

And this extension will aid you in exactly this.
It will report any error you have in your words, no matter the context (variable name, comment, etc.).
Also, it has other extensions you can look up on marketplace to extend the support for other languages (Russian and Ukrainian, in my case, but [it has a lot other languages](https://github.com/streetsidesoftware/vscode-spell-checker#add-on-language-dictionaries)).

## IntelliJ IDEA Keybindings

[Link to Extension](https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings)

This one is really an opinionated, but I wanted to show you it is possible.
There were times when I was working in PHPStorm and WebStorm when VSCode didn’t exist.
I was working in these IDEs for such long that I’ve accommodated to their hot keys.

But, when I’ve switched to VSCode, turns out, it’s not so easy to learn new hot keys.
So that, I’ve found an extension that maps hot keys from IntelliJ to commands in VSCode.
Thanks to this extension, my migration from IntelliJ was much easier.

## Code Action on Save

It is not an extension, but I couldn’t mention it.

When working with linters, compilers, having all the errors and warnings in your editor, it’s hard to fix all the problems.
Luckily, the tools we are using are able to automatically fix almost all the problems.
The problem is that we need to call them manually by executing a command.

Enabling code action on save to fix all the problems allows to you get all the fixes for “free”.
All you need to do is just save the file!

Doing so is really simple.
Open the command pallette and call the command "Preferences: Open Settings (JSON)" and tweak the field called `editor.codeActionsOnSave`.
There, you must enable a `source.fixAll` flag.

```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

## Epilogue

Visual Studio Code is a great IDE when working with such languages like TypeScript, Rust, Ruby and others.
Almost all the languages it supports are implemented through [Language Server](https://microsoft.github.io/language-server-protocol/), while the IDE acts as a client to it.
So that, extending the language support is a matter of implementing the server and following the Language Server API.

By installing the extensions, you make language support smarter in your IDE.
In this post, we went through an opinionated list of such extensions that make work with TypeScript more productive.

Also, do not forget that Visual Studio Code has a great [Marketplace](https://marketplace.visualstudio.com) where it is easy to discover other extensions.
All you need to do is just specify a keyword in the search and install the extension in a click.
So feel free to investigate the [Marketplace](https://marketplace.visualstudio.com) and find the extensions that suit you.

---

*Eugene Obrezkov, Software Engineer @ Wix, Kyiv, Ukraine.*
