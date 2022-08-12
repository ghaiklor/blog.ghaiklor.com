---
title: How to setup TypeScript projects in 2021
excerpt: >-
  Nowadays, TypeScript is pretty everywhere. But there are some issues with what
  it can offer out of the box. In this article, let us dive into TypeScript
  configuration and what can we tweak to get better TypeScript.
categories:
  - Thoughts
tags:
  - node.js
  - typescript
  - eslint
  - configuration
  - config
  - strict
  - strictness
  - setup
header:
  overlay_image: assets/uploads/2021-02-26/2021.jpg
  overlay_filter: 0.5
  caption: Photo by Kelly Sikkema on Unsplash
  teaser: assets/uploads/2021-02-26/2021.jpg
---

Most of you will agree with me on the point that it is hard to configure the proper setup for TypeScript projects.
There are several reasons for that and some story, so I'm not diving into this here.
The fact is - **you need to spend a few days to properly setup an infra that catches common bugs in your code.
You get nothing useful out of the box and this is the problem.**

So that, in this article, I'd like to pay your attention to some problems and how do I solve them.
I'll be talking about developer tools and infrastructure.
More precisely, **I'll be talking about TypeScript compiler and ESLint static analysis tool, their problems and how to overcome them.**

In case you are interested, you are more than welcome to read more.

## Prelude

Before diving right into technical details and other stuff you might be not interested, I want to emphasize few things.
This article is my opinion, how I interpret the design decisions behind TypeScript and ESLint.
It is not a document you must strictly follow.
It is a personal experience I went through, problems I solved.
You may agree with it or not.
The only fact here is - you may apply these techniques or not, depending on your specific case.

## TypeScript

### TypeScript Configuration Problem

When you just set up the newest version of TypeScript and started immediately writing some code, you get only type hints (if I may say so).
**A lot of stuff that helps to check the program correctness is disabled by default** and it is their design decision.
You may read about it in their [document describing the goals](https://github.com/Microsoft/TypeScript/wiki/TypeScript-Design-Goals).

What exactly am I talking about?
Well, here is a short list of type checker features that are disabled by default:

- Sometimes when there is no type annotations, TypeScript will fall back to a type of `any` for a variable when it cannot infer the type. The problem here is that it will fall back silently and you never know that there is a variable that is not type checked.
- TypeScript does not check that the built-in methods of functions `call`, `bind`, and `apply` are invoked with a correct argument for the underlying function. Instead, these functions accept `any` arguments and will return `any`.
- Methods and functions are always bi-variant in their argument, unless told otherwise.
- The language effectively ignores `null` and `undefined`.
- A lot more minor issues.

There is a lot of room for improvement, as you can see.
The good news is that we can tune it, the bad news is that you need to tune it manually in your configuration.

### TypeScript Tuning

All the tuning is happening in TypeScript configuration file.
To ease your pain, you can create a common configuration file where you will set everything as you need once and just reuse the configuration later.
You can read more about [configuration bases here](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html#tsconfig-bases).

When writing your own TypeScript configuration base, you need to reference the [reference for it](https://www.typescriptlang.org/tsconfig) (sorry for tautology).
In case you are too lazy to do so, I'll highlight important configuration values that solve some problems:

- When debugging the TypeScript code base, it is great to have these flags set to true - _[declaration](https://www.typescriptlang.org/tsconfig#declaration)_, _[declarationMap](https://www.typescriptlang.org/tsconfig#declarationMap)_ and [_sourceMap_](https://www.typescriptlang.org/tsconfig#sourceMap).
- You can enable the entire family of strict checks by using the single toggle - [_strict_](https://www.typescriptlang.org/tsconfig#strict). Or, if you want to selectively enable only what you are interested in, refer to [TypeScript strict options](https://www.typescriptlang.org/tsconfig).
- Additional checks like [_noImplicitAny_](https://www.typescriptlang.org/tsconfig#noImplicitAny), [_noImplicitThis_](https://www.typescriptlang.org/tsconfig#noImplicitThis) and [others](https://www.typescriptlang.org/tsconfig) help to prevent a lot of implicit behavior and I highly recommend enabling them all.

When you are done crafting your own configuration base, following the reference, enabling all the strict checks, turning off implicit behaviors and so on, you can prepare it as a separate package.

### Sharing the TypeScript Configuration

As you have already noticed, all the configuration lies inside a single JSON file.
You can easily make a npm package from it, where you publish only the configuration file itself with all the tuned properties.

When consuming such configuration in another project, you just use `extends` property to specify the path to your shared configuration base, e.g. `@my-company/typescript-shared-config/tsconfig.json`.

That way, all the projects, where you refer to your tuned TypeScript configuration file, will reuse all the goodness you have enabled: strict program correctness check, less implicit behaviors, better debugging, etc.

For reference, here is mine [TypeScript Configuration](https://gist.github.com/ghaiklor/1dff8fa5e4c03adb54804fe42918e5d5) that I use in my own projects.
Please note that in future releases TypeScript can add more useful flags so be sure to check the base against TypeScript reference.
{: .notice--info }

## ESLint

### ESLint Configuration Problem

There is a DX problem with ESLint configuration.
For many developers, it is not obvious that [**ESLint does not enable any rules by default**](https://eslint.org/docs/user-guide/getting-started#configuration).
You need to enable them manually by specifying so called presets or enumerating all the rules you want to enable.
**Out of the box, there is nothing useful from ESLint at all - nothing!**

To do so, usually, developers use `extends` property.
It allows to specify the bunch of rules to enable and mostly those rules are recommended.
But what if **we want to craft the more strict rule set than it is in recommended preset**?
What if we want to get all the rules enabled and have a possibility to disable them when needed?

What did I do in my projects?
**Switched from the idea "enable the rule in whitelist" to "disable the rule in blacklist"!**

### ESLint Tuning

The first thing you need to do to achieve this ideology for ESLint configuration - **enable all the rules of all the plugins and core**.
By that, I mean, use `extends` property in ESLint configuration to enable all the rules from eslint, e.g. `eslint:all`.
The same applies to all the plugins you use.

When you got them enabled, most likely you will get a lot of errors and warnings.
Some of them are conflicting with each other, some of them do what you didn't want it to do and stuff like that.
It is ok; you have enabled all the rules, after all.
To solve the issue, start disabling the rules you don't agree with.

And that is where the key point of the whole ESLint topic in this article.
**Start using `rules` property not for whitelisting the rules you are interested in.
Start using the `rules` property for blacklisting the rules you don't agree with or configure it in another way that suits you.**

That way, you will get all the rules of any update in future "for free".
Unless a new rule appears you don't agree with.
In such case, you just go to the `rules` property and configure it in your own way or just disable it.

### ESLint Plugins

The second thing - plugins.
**ESLint itself analyzes only JavaScript code, but we are setting up the TypeScript project!
You could have Node.js runtime, tests written for Jest and a lot more, that ESLint does not check.**

If you want to have more strict checks on the things related to Node.js, Jest, async programming, TypeScript code and everything that we usually do in 2021, you need to install a lot of plugins.

I'll give you a summary of plugins I'm using for my Node.js based projects:

- Plugin to analyze TypeScript code and provide more strictness - [typescript-eslint](https://github.com/typescript-eslint/typescript-eslint).
- Plugin to protect your code from ESLint directives that can accidentally disable the static analysis for the entire file or stuff like that - [eslint-comments](https://github.com/mysticatea/eslint-plugin-eslint-comments).
- Plugin to analyze how you use modules in your code base and prevent any issues with wrong imports or exports - [eslint-plugin-import](https://github.com/benmosher/eslint-plugin-import).
- Plugin to prevent common mistakes when writing tests in Jest and to enforce common guidelines, e.g. it prevents the situation when you forget about focusing tests and commit them - [eslint-plugin-jest](https://github.com/jest-community/eslint-plugin-jest).
- Plugin to add additional checks specific for Node.js runtime - [eslint-plugin-node](https://github.com/mysticatea/eslint-plugin-node).
- Plugin to prevent common mistakes when working with asynchronous code, e.g. situation when a race condition possible - [eslint-plugin-promise](https://github.com/xjamundx/eslint-plugin-promise).
- Plugin to sort imports and exports in your project, it does so automatically - [eslint-plugin-simple-import-sort](https://github.com/lydell/eslint-plugin-simple-import-sort).

When you have all the plugins installed and configured each of them in `extends` property to use all the rules, you can start disabling the rules you don't want to have in `rules` property.
**Property `extends` is for enabling, property `rules` is for disabling or overriding - simple.**

When you are done with configuring all the properties for `extends` and `rules`, you can make it as a configuration base distributed via npm package.

### Sharing the ESLint Configuration

You can have a single `.eslintrc.js` file where you configure the overrides.
Creating a npm package that holds that file will help you reuse this configuration in your other projects.

To do so, in your another project create a `.eslintrc.js` file and specify `extends` property pointed to your npm package, e.g `require.resolve('@my-company/eslint-shared-config')`.

That way, you will get all the static analysis benefits shared across your projects with all the strictness it can give you.
Unless you have disabled everything in the `rules` property.

For reference, here is mine [ESLint Configuration](https://gist.github.com/ghaiklor/45c6e5b46767ed20ec3a97befc276860) on some open source projects.
Remember, ESLint setup is really depends on the case and what stack you are using.
That is for you to decide which plugins to bring and what rules to disable.
{: .notice--info }

BTW, if you are working in mono repository, you can read my [blog post on how to improve your developer experience when working in such a setup]({% post_url 2020-07-12-mono-repository-done-right %}).
{: .notice--info }

## Epilogue

Today, I showed you my pain points that I'm facing every day and how I overcome them.
Sure, there is work to do, but the good side here is that you need to do it only once in a base configuration file.
Afterwards, you get the most strict infrastructure around compilers and static analysis tools that you can get in 2021 (I mean, in TypeScript land, of course).

For questions you have about TypeScript infrastructure, [contact me on Twitter](https://twitter.com/ghaiklor).
I'm actively using the social network, so follow me up there, ask questions, and I'll gladly answer them.
Thanks for your time!

---

_Eugene Obrezkov, Software Engineer at Wix.com, Kyiv, Ukraine._
