---
title: Optimizations tricks in V8
excerpt: >-
  V8 compiles JavaScript with Just-In-Time compiler to get a fast native code.
  But, it is unclear what are the tricks that V8 uses to optimize objects
  manipulation or dynamic dispatch. Let us dive into these tricks and figure out
  how do they work.
categories:
  - Explained
tags:
  - node.js
  - javascript
  - v8
  - virtual machine
  - optimization
header:
  overlay_image: assets/uploads/2016-04-05/tricks.jpg
  overlay_filter: 0.5
  caption: Photo by Amol Tyagi on Unsplash
  teaser: assets/uploads/2016-04-05/tricks.jpg
---

Last time, I talked about V8 and [how it optimizes your JavaScript code]({% post_url 2016-03-25-how-v8-optimises-javascript-code %}).
However, I didn’t talk about optimization tricks that are applied during compilation.

Today, I will describe some big optimizations and try to explain them.
There are many compiler optimization techniques, so I will talk about the big ones only.

## Hidden Classes

The bigger issue here is that JavaScript is a dynamic language.
Properties of your objects can be added or deleted on the fly.
It requires dynamic lookups to resolve the property’s location in the memory.
This is a high-cost operation.

So what does V8 do to reduce the time required to access JavaScript properties?
V8 dynamically creates the hidden class behind the scene.
Let me explain what is hidden class by example.

Imagine, we have a function _Point_.

```javascript
function Point(x, y) {
  this.x = x;
  this.y = y;
}
```

When _Point_ is executed, a new object is created, called _Point_.
V8 creates an initial hidden class for this object, called _C0_, for example.
At this step, the object doesn’t have properties, so the hidden class is empty.

{% include figure image_path="assets/uploads/2016-04-05/hidden-class-1.png" alt="Hidden Class C0" caption="Image Source: V8 Blog" %}

The first statement creates new property in our object — _x_.
It changes the _Point_ object, so V8 creates new hidden class _C1_ based on _C0_.
Also, updates _C0_ hidden class with transition to _C1_.
At this step, our hidden class for _Point_ object look like this:

{% include figure image_path="assets/uploads/2016-04-05/hidden-class-2.png" alt="Hidden Class C1" caption="Image Source: V8 Blog" %}

The second statement creates another property — _y_.
The same steps as before.
V8 creates new hidden class _C2_, based on _C1_ and updates _C1_ with the transition to _C2_.
At this step, here is our hidden class:

{% include figure image_path="assets/uploads/2016-04-05/hidden-class-3.png" alt="Hidden Class C2" caption="Image Source: V8 Blog" %}

Because of the class transitions, we can reuse the hidden classes for new objects.
The next time, when a new _Point_ object is created, no new hidden classes are created.
Instead, the new _Point_ object shares the hidden class with the first _Point_ object.

What happens when we are creating another _Point_ object?

- Initially, _Point_ has no properties, so our object refers to _C0_
- Adding _x_ property, V8 follows the hidden class transition from _C0_ to _C1_ and writes the value of _x_ at the offset specified by _C1_
- Adding _y_ property, V8 follows the hidden class transition from _C1_ to _C2_ and writes the value of _y_ at the offset specified by _C2_

The concept of hidden classes allows a compiler to bypass a dictionary lookup when property is accessed.
It already knows the offset of a requested property.
Also, it enables V8 to use classic class-based optimization and inline caching.

Still, you need to understand that changing the order of properties in your constructor can lead to creating new hidden classes.
For instance, let’s say you swapped _x_ and _y_.

- Initially, _Point_ has no properties, so our object refers to _C0_
- Afterwards, adding _y_ property (_we swap the order_), V8 follows the hidden class transition from _C0_ to _C1_, but… there is no transition for _y_ property. We have the transition from _x_ property only
- The same for _x_ property

This leads to creating new hidden classes which leads to bad optimization (_fix me if I’m wrong_).

## Inline Caching (IC)

> Inline caching is an optimization technique used by some language runtimes, and first developed for Smalltalk. The goal of inline caching is to speed up runtime method binding by remembering the results of a previous method lookup directly at the call site. Inline caching is especially useful for dynamically typed languages where most if not all method binding happens at runtime and where virtual method tables often cannot be used.

The whole optimization trick is based on the caching result of the method lookup directly on the call site.
Once it’s done, V8 will not process method lookup and can get the callee from the cache, invoking it without performing any more lookups.

But… this leads V8 to inject some “guard” code.
Everything works great until you change the object, V8 doesn’t expect that.
That’s when the “guard” code should execute.
It performs a full dynamic lookup again.

Let’s try to dig in with example.
We have a simple function that accepts two arguments and calls some method on one of them:

```javascript
function render(shape, cursor) {
  // Some logic here...
  shape.render(cursor);
  // Some here...
}
```

We don’t know what the _shape_ is, so we need to lookup for method _render_ there.
After lookup is done, we can rewrite the call as a direct call to the target method.

This works fine until you pass another instance of _shape_, so direct call leads us to the wrong object.
“Guard” code checks these cases and if something is wrong, it returns to dynamic lookup, which returns the correct result.

Luckily, V8 can optimize these cases via Monomorphic Inline Caching (MIC) and Polymorphic Inline Caching (PIC).
If you have a small amount of different shapes, that’s fine.
V8 can handle this.
Otherwise, it became megamorphic call site and there is no sense to optimize it.

That’s it about IC.
Just another one optimization which tries to decrease amount of dynamic lookups (_like hidden classes do_).

## On-Stack Replacement (OSR)

On-Stack Replacement is a technique for switching between different implementations of the same function.

When V8 optimizes your functions, it needs to replace the actual code with the optimized one somehow.
That’s when OSR comes into play.
It just takes un-optimized code of your function and replaces it with optimized one on call site.

Also, when things go wrong and optimized code can’t handle some edge case, OSR can switch back to un-optimized code and you don’t need to re-run your application.

## Last steps

Those were the major optimizations that impact your program execution significantly.

Let’s finish this article with a short list of minor optimizations applied to your code (_they are applied by a Hydrogen compiler, when CFG is building_):

- **Inlining** — is a compiler optimization that replaces a function call site with the body of the called function. This method eliminates call overhead.
- **Canonicalization** — eliminates unnecessary operations and tries to simplify others.
- **Dead Code Elimination** (DCE) — removes the code that does not affect the program results.
- **Dynamic Type Feedback** (DTF) — as you remember, V8 collects type feedback information in your functions. This optimization extracts information from inline caches in your code and optimizes the code to handle only that one type of object.
- … and a lot more of minor optimizations.

## Useful links

- [V8 Design Elements](https://developers.google.com/v8/design)
- [A tour of V8: Crankshaft, the optimizing compiler](https://jayconrod.com/posts/54/a-tour-of-v8-crankshaft-the-optimizing-compiler)
- [A closer look at Crankshaft V8 optimizing compiler](https://wingolog.org/archives/2011/08/02/a-closer-look-at-crankshaft-v8s-optimizing-compiler)
- [Optimization killers](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers)
- [V8 bailout reasons](https://github.com/vhf/v8-bailout-reasons)

---

*Eugene Obrezkov aka ghaiklor, Developer Advocate at [Onix-Systems](https://onix-systems.com), Kirovohrad, Ukraine.*
