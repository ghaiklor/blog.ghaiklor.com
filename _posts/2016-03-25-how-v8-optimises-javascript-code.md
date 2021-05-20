---
title: How V8 optimise JavaScript code?
excerpt: >-
  Node.js known to use V8 engine to interpret JavaScript. Somehow, it interprets
  it a little slower than compiled C++ code. How is this even possible? Does it
  interpret the code or not? Let’s figure out.
categories:
  - Explained
tags:
  - node.js
  - javascript
  - v8
  - virtual machine
  - optimization
header:
  overlay_image: assets/uploads/2016-03-25/v8.jpg
  overlay_filter: 0.5
  caption: Photo by Łukasz Nieścioruk on Unsplash
  teaser: assets/uploads/2016-03-25/v8.jpg
---

In my [previous article]({% post_url 2015-11-14-why-nodejs-is-so-fast %}), I was talking about Node.js and why it’s fast.
Today, I want to talk about V8.

I suppose some of you heard that JavaScript executes as fast as C++.
Some of you don’t understand how it’s even possible.
JavaScript is a dynamically typed language with Just in Time (JIT) compilation, when C++ is static-typed language with Ahead of Time (AoT) compilation.
And somehow, optimized JavaScript code executes a little slower than C++ or even with the same speed.

To understand why that is, you need to know some basics of V8 implementation.
It’s a huge topic, so I will only explain key features of V8 in this post.
If you want more details, such as hidden classes, SSA, IC, etc. they will be in my next article.

## AST

Everything starts from your JavaScript code and its [Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) (AST).

> In computer science, an abstract syntax tree (AST), or just a syntax tree, is a tree representation of the abstract syntactic structure of source code written in a programming language. Each node of the tree denotes a construct occurring in the source code. The syntax is “abstract” in not representing every detail appearing in the real syntax.

What can we do with AST?
Before doing any optimizations on your code, it first needs to be transformed into a lower level representation.
That’s essentially what AST is.
AST contains all the required information about your code for V8 to analyse.

In the beginning, all of your code is transformed into AST and going through a full-codegen compiler.

## Full-Codegen Compiler

The main purpose of this compiler is to compile your JavaScript code to native code as quick as possible, without optimizations.
It handles all the various cases and includes some type-feedback code that collects information about data types seen at various points of your JavaScript function.

It takes AST, walks over the nodes and emits calls to a macro-assembler directly.
The result of this operation is a generic native code.

That’s it.
Nothing special.
No optimizations are performed here, complicated cases of your code are handled by emitting calls to runtime procedures, all local variables are stored on the heap, etc.

The most interesting part is when V8 sees that your function is hot and it’s time to optimise it.
That’s when a Crankshaft compiler comes into play.

## Crankshaft Compiler

As I mentioned before, the full-codegen compiler generates a generic native code with the code that collects type-feedback information about your functions.
When function becomes hot (_hot function is a function that is called often_), Crankshaft can use AST with that information to compile optimized code for your function.
Afterwards, optimized function will replace un-optimized using [on-stack replacement](https://wingolog.org/archives/2011/06/20/on-stack-replacement-in-v8) (OSR).

However, the optimized function doesn’t cover all the cases.
If something went wrong with types, for instance, function returns float number instead of integers, optimized function will be de-optimized and replaced with old un-optimized code.
We don’t want that, do we?

For example, you have a function that adds two numbers:

```javascript
const add = (a, b) => a + b;

// Let's say we have a lot of calls like this
add(5, 2);
// ...
add(10, 20);
```

When you call this function many times with integers only, type-feedback information comprises information that our _a_ and _b_ arguments are integers.
Using that information and AST of this function, Crankshaft can optimise this function.
But everything would break if you made a call like this:

```javascript
add(2.5, 1);
```

Based on the previous type-feedback information, Crankshaft assumes that only integers are going through this function, but we’re passing it a float number.
There is no optimized code to handle that case, so it just de-optimise.

You might ask, how does all this magic work in Crankshaft?
Well, there are a few parts that work in the Crankshaft compiler together:

- Type feedback (_already discussed above_)
- Hydrogen compiler
- Lithium compiler

## Hydrogen Compiler

Hydrogen takes AST with type-feedback information as its input.
Based on that information, it generates high-level intermediate representation (HIR) which comprises a control-flow graph (CFG) in [static-single assignment form](https://wingolog.org/archives/2011/07/12/static-single-assignment-for-functional-programmers) (SSA).

During the generation of HIR, several optimizations are applied, such as constant folding, method inlining, etc (_I will talk about V8 optimization tricks in the next article_).

The result is an optimized control-flow graph (CFG) that is used as input to the next compiler — Lithium compiler, which generates the actual code.

## Lithium Compiler

The lithium compiler takes optimized HIR and translates it to a machine-specific low-level intermediate representation (LIR).
The LIR is conceptually similar to machine code, but still mostly platform-independent.

During LIR generation Crankshaft still can apply some low-level optimizations to it.
After LIR was generated, Crankshaft generates a sequence of native instructions for each lithium instruction.

Afterwards, the resulting native instructions are executed.

## Summary

This is the magic that happens in V8 internals to optimise your JavaScript to make it execute as fast as C++.
Still, you need to understand that badly written JavaScript will not be optimized and you don’t get the benefits of optimizations.

I will talk about V8 optimization tricks, ways to profile bottlenecks in your code and how to look for de-optimizations, investigating the control-flow graph (CFG) in the following articles.

---

*Eugene Obrezkov aka ghaiklor, Developer Advocate at [Onix-Systems](https://onix-systems.com), Kirovohrad, Ukraine.*
