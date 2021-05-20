---
title: Strange bug ever in V8
excerpt: >-
  Recently, I’ve found out about one of the strangest bugs in virtual machine V8
  that interprets JavaScript. I tried to understand what happened and share my
  thoughts with you.
categories:
  - Thoughts
tags:
  - node.js
  - javascript
  - v8
header:
  overlay_image: assets/uploads/2016-06-23/bug.jpg
  overlay_filter: 0.5
  caption: Photo by Charlotte Descamps on Unsplash
  teaser: assets/uploads/2016-06-23/bug.jpg
---

Recently, I find out about a strange bug in V8.
Everyone is discussing it in Twitter, Facebook, Gitter and other social networks.
So, I will try to explain it.

To my knowledge, it happens in the latest stable version of Google Chrome (my version is 51.0.2704.103).

You can check it with the following snippet of code:

```javascript
function test() {
  return null === 'undefined';
}

for (var i = 0; i < 1000; i++) {
  console.log(test());
}
```

This leads to the following result:

{% include figure image_path="assets/uploads/2016-06-23/repro.png" alt="Bug Demo" caption="Demonstration of the bug" %}

## What happened

Well, I’ve found a commit that fixes this issue.
Here is the [link](https://github.com/v8/v8/commit/7dfb5beeec8821521beeb2b8eac36707a663064c), so you can look yourself into it.
According to a commit description, the issue was in canonicalizations.
What is that?

> In computer science, canonicalizations (sometimes standardization or normalization) is a process for converting data that has more than one possible representation into a “standard”, “normal”, or canonical form. This can be done to compare different representations for equivalence, to count the number of distinct data structures, to improve the efficiency of various algorithms by eliminating repeated calculations, or to make it possible to impose a meaningful sorting order.

In our case, the issue was in strings canonicalizations.

Let me give you a brief example of what canonicalizations is via boolean.
Let’s say, in JavaScript, we can write boolean as _true_, _false_, _1_, _0_, empty string, etc…
But, in canonical form it can be only _true_ or _false_.
That is a canonical form of boolean.
The only one form of representing the data, the correct one.

That’s where this bug was.
Crankshaft compiler in V8 does it a little wrong when optimizing your code.
That’s why first iterations were right in our loop until Crankshaft optimized it.

Share your thoughts, will be glad to discuss.

**UPD**: Thanks to [Vyacheslav Egorov](https://medium.com/u/c9127427a2cf), we have a nice explanation of what happened:

> Regarding the bug itself.
> There is a code in Crankshaft that looks at `typeof x == “…”` and `typeof x === “…”` and tries to figure out if they always evaluate to true or false (see [HTypeofIsAndBranch::KnownSuccessorBlock](https://github.com/v8/v8/blob/7dfb5beeec8821521beeb2b8eac36707a663064c/src/crankshaft/hydrogen-instructions.cc#L1243-L1258)).
> For example if `x` is a constant it just computes `typeof x` and compares it with right hand side in compile time.
> However Crankshaft does not actually call to the same `typeof` implementation that normal JavaScript uses.
> For unknown reasons (probably because Crankshaft optimization passes can run in a background compiler thread) it has a its own implementation of `typeof` (see [TypeOfString](https://github.com/v8/v8/blob/7dfb5beeec8821521beeb2b8eac36707a663064c/src/crankshaft/hydrogen-instructions.cc#L1203-L1238) function).
> This implementation got out of sync when V8 folks were refactoring stuff related to an obscure thing called “undetectable objects” — null got marked as undetectable object for Crankshaft in [this change](https://chromium.googlesource.com/v8/v8/+/0fc7b2c41ff1e7437b09b1e03d1c5ab7d72ec30f) but `TypeOfString` implementation was not aligned with this change.
> Note: that [TypeOfString](https://github.com/v8/v8/blob/7dfb5beeec8821521beeb2b8eac36707a663064c/src/crankshaft/hydrogen-instructions.cc#L1203-L1238) was only ever used to fold constant `HTypeOfIsAndBranch` instructions and was never used to constant fold standalone `typeof` const which did not participate in `typeof x == “…”` like pattern.
> That’s why things like `(0, typeof null) == ‘undefined’` work around this bug — because they break recognition of this pattern.
> Regarding `let` vs `var`.
> If you bump iteration limit for the `var` case to 20000 you will see it hit the bug.
> The reason for this is that for loop with let-binding gets de-sugared in a very baroque way in V8 — which causes it to be optimized earlier than for loop with var-binding.
> [(reference)](https://medium.com/@mraleph/regarding-the-bug-itself-e6f42a52cb16)
