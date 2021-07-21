---
title: Top 5 ESLint plugins for TypeScript development
excerpt: >-
  ESLint is a great tool and has a decent infrastructure for developing your own
  rules and plugins. In this post, I’m collecting the list of the plugins I use
  every day for TypeScript development.
categories:
  - Tools
tags:
  - node.js
  - typescript
  - eslint
  - plugin
  - top
  - collection
header:
  overlay_image: assets/uploads/2021-07-21/plugin.jpg
  overlay_filter: 0.5
  caption: Photo by Alex Gagareen on Unsplash
  teaser: assets/uploads/2021-07-21/plugin.jpg
---

We all know why [linters](https://en.wikipedia.org/wiki/Lint_(software)) exist.
We all know that it is not a specific case for JavaScript or TypeScript.
Any other language also has linters.
Ruby has [rubocop](https://github.com/rubocop/rubocop), Rust has [clippy](https://github.com/rust-lang/rust-clippy) and so on.
Any language has a compiler, linter and a formatter to it.

The responsibility of a compiler is to make sure that the program works in the expected way.
Linter enforces best practices and “canonical” forms in the code.
Formatter does, well, the formatting to some pre-defined standards.

In the TypeScript world, we all use [ESLint](https://eslint.org) or [TSLint](https://palantir.github.io/tslint/).
Unfortunately, ESLint out of the box is not designed to lint TypeScript code.
So in this post I’ll mention all the plugins I use for ESLint to improve my productivity when working with TypeScript.

TSLint is deprecated long time ago, so if you are still using it, I’d recommend switching to ESLint.
{: .notice--warning }

## TypeScript ESLint Plugin

[*@typescript-eslint*](https://github.com/typescript-eslint/typescript-eslint)

As I already mentioned, ESLint is a great tool, but it works only for JavaScript code out of the box.
The reason behind this is that ESLint parses the JavaScript code and gets the JavaScript Abstract Syntax Tree.

However, TypeScript code syntactically differs from JavaScript code.
Any JavaScript code is a valid TypeScript code but not vice versa.
So that, ESLint does not understand the TypeScript code and can not operate with its Abstract Syntax Tree.

To mitigate the issue, community created [`typescript-eslint`](https://github.com/typescript-eslint/typescript-eslint).
They provide [a custom parser for ESLint](https://github.com/typescript-eslint/typescript-eslint/tree/v4.28.4/packages/parser) that can parse TypeScript code into ESTree that is understandable by ESLint.
Also, they provide [a plugin](https://github.com/typescript-eslint/typescript-eslint/tree/v4.28.4/packages/eslint-plugin) that has a lot of useful rules that prevents any common pitfalls from happening.

The plugin even can operate on the typed AST from TypeScript and bring [more advanced rules that use type information](https://github.com/typescript-eslint/typescript-eslint/blob/v4.28.4/docs/getting-started/linting/TYPED_LINTING.md).
But it is an opt-in feature, make sure, that you read the [documentation](https://github.com/typescript-eslint/typescript-eslint/blob/v4.28.4/docs/getting-started/linting/TYPED_LINTING.md).

In case you want to get everything they have baked in there, just use the preset called `all`.
By using this preset you will get all the rules and in case of need you will be able to tune them later in `rules` property.

```javascript
module.exports = {
  extends: ["plugin:@typescript-eslint/all"],
  rules: {
    "@typescript-eslint/some-rule-you-want-to-disable": ["off"],
    "@typescript-eslint/some-rule-you-want-to-tune": [
      "error",
      { options: "here" },
    ],
  },
};
```

For any additional information, you can refer to [their documentation](https://github.com/typescript-eslint/typescript-eslint).

## ESLint Plugin for imports and exports

[*eslint-plugin-import*](https://github.com/benmosher/eslint-plugin-import)

We import and export a lot of stuff each day.
You have dozens of imports\exports in any of files.
Any of those statements can become a problem if not handled properly.

That is why community created an [ESLint plugin](https://github.com/benmosher/eslint-plugin-import) for finding common issues when working with imports and exports statements.

Just hear out what the plugin offers (*this is just an opinionated short list I picked from their documentation*):

- Ensure imports point to a file/module that can be resolved
- Ensure a default export is present, given a default import
- Forbid a module from importing a module with a dependency path back to itself
- Forbid the use of extraneous packages
- Ensure all imports appear before other statements
- And a lot more that you can find in [their documentation](https://github.com/benmosher/eslint-plugin-import)

The crucial point of the plugin is to prevent you from making errors when working with module systems, import and export statements and everything that relates to it.

You can easily enable it by extending your configuration from its presets named `errors` and `warnings`.
Also, since we work with TypeScript, we also need to extend from the preset called `typescript`.

```javascript
module.exports = {
  extends: [
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
  ],
};
```

## ESLint Plugin for Jest

[*eslint-plugin-jest*](https://github.com/jest-community/eslint-plugin-jest)

For testing the code we write, usually, we test it using the [Jest framework](https://jestjs.io).

In case you are using another test framework, like [Mocha](https://mochajs.org) or [Jasmine](https://jasmine.github.io) or whatever, I believe there is a plugin for it as well.
Try to find it on [npm registry](https://www.npmjs.com).
{: .notice--info }

What do I love about this plugin for Jest?
It gives you a lot of ways to check that your tests are consistent, assertions are there, Jest APIs you use are “canonical” and so on.

Let me tell you a minor story I had some time ago.
Just an example of what can happen if you don’t use the plugin for static analysis.

We all use focused tests when debugging them.
E.g. using `.only()` method or adding `f` before `it()`.
Sometimes, developer can forget about focused test and commit it without being noticed.

Now, imagine what can happen if you live for some time without knowing that CI runs only a single test from the entire code base.
Cruelty!

[`eslint-plugin-jest`](https://github.com/jest-community/eslint-plugin-jest) has a rule that restricts having focused tests and you can check it before the actual commit.
Also, it prevents from writing tests that have conditional assertions, those that are hidden behind the if block.
And a lot more!
This is a must-have plugin to be configured for ESLint.

As with other plugins, Jest provides a preset you can extend from.

```javascript
module.exports = {
  extends: ["plugin:jest/all"],
};
```

## ESLint Plugin for Promises

[*eslint-plugin-promise*](https://github.com/xjamundx/eslint-plugin-promise)

I remember the times when JavaScript was all about synchronous API and having callbacks was like an exception.
But, that’s not true nowadays.
We have a lot of asynchronous APIs that are wrapped as Promises or that accept callbacks or whatever.

Having all these asynchronous APIs it becomes harder and harder to notice their wrong usage.

For instance, you (as developer) can forget about catching an error from a promise.
Or, you can run the promise, but forget about awaiting it.
And many other scenarios like that.

In order to minify the risks of happening such a scenario, we have a plugin for ESLint called [eslint-plugin-promise](https://github.com/xjamundx/eslint-plugin-promise).

It is easy to enable on your project by using their recommended preset.

```javascript
module.exports = {
  extends: ["plugin:promise/recommended"],
};
```

## ESLint Plugin for Prettier

[*eslint-plugin-prettier*](https://github.com/prettier/eslint-plugin-prettier)

Formatting issues!
Gosh, we love discussing formatting issues with the team, do we?
Someone does not agree with the semicolons, someone against using argument list on separate lines and so on.

Formatting issues are the major topic for discussion when setting up guidelines.

But, you know, why arguing with your colleagues about semicolons if you can just use the formatter that is not configurable.
You heard it right, the formatter that you can’t configure.

That way, there is no sense in holy war against semicolons, because you can’t tune them.

For such matters we use [prettier](https://prettier.io).
It also provides a [plugin you can integrate with ESLint](https://github.com/prettier/eslint-plugin-prettier).
Going that way, especially if you have auto-fix enabled for ESLint, you will get formatting done automatically by `eslint --fix`.

Integration itself is also pretty easy as with other plugins.

```javascript
module.exports = {
  extends: ["plugin:prettier/recommended"],
};
```

## How to find any other ESLint Plugin out there

I made an opinionated list of five plugins for ESLint here.
So that I can’t cover all the cases you can face.
If you work with e.g. React library, you can go to the npm registry and lookup by keywords “[eslint plugin react](https://www.npmjs.com/search?q=eslint%20plugin%20react)”.

You don’t work with the React, do you?
Well, ok, lookup “[eslint plugin node](https://www.npmjs.com/search?q=eslint%20plugin%20node)” if you work with Node.js then.
You got the drill.

In case you are interested in what are the plugins out there for “everything” - the same.
Go to npm registry and just lookup “[eslint plugin](https://www.npmjs.com/search?q=eslint%20plugin)”.
The result will overwhelm you.

Just for reference, here is the whole `extends` property we have right now in one of our projects.
There are much more plugins out there than you can imagine and most of them are useful, so pay a closer attention when setting up the ESLint to its plugins.
{: .notice--info }

```javascript
module.exports = {
  extends: [
    "eslint:all",
    "plugin:@typescript-eslint/all",
    "plugin:eslint-comments/recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "plugin:jest/all",
    "plugin:node/recommended",
    "plugin:optimize-regex/all",
    "plugin:prettier/recommended",
    "plugin:promise/recommended",
    "plugin:regexp/recommended",
    "plugin:security/recommended",
    "standard-with-typescript",
    "prettier",
  ],
  plugins: [
    "@typescript-eslint",
    "eslint-comments",
    "import",
    "jest",
    "node",
    "optimize-regex",
    "prettier",
    "promise",
    "regexp",
    "security",
    "simple-import-sort",
    "tsdoc",
  ],
};
```

---

*Eugene Obrezkov, Software Engineer @ Wix.com, Kyiv, Ukraine.*
