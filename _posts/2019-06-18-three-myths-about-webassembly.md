---
title: Three myths about WebAssembly
excerpt: >-
  WebAssembly is becoming more popular and more people hear about it. But, a lot
  of these people are not actually understand what WebAssembly is and have a
  wrong understanding of it.
categories:
  - Explained
tags:
  - node.js
  - javascript
  - webassembly
  - wasm
  - myths
  - misunderstood
header:
  overlay_image: assets/uploads/2019-06-18/misunderstood.jpg
  overlay_filter: 0.5
  caption: Photo by Misunderstood Whiskey on Unsplash
  teaser: assets/uploads/2019-06-18/misunderstood.jpg
---

*WebAssembly is a replacement for JavaScript!*
*C++/Rust developers can now code front-end applications!*
*WebAssembly is faster than JavaScript!*
*WebAssembly! WebAssembly!*

How many times do you hear these statements?
Me, a lot.
So I collect the most popular myths about WebAssembly and tell you the truth behind them.

## WebAssembly is a general purpose programming language

### No! WebAssembly is a binary format

Can you code your general purpose software in binary format?
Well, yes, you can, but can you imagine the process?
You need to remember all the hexadecimal values that have meaning to "do something".

Do you want to implement a function that returns "Hello, World" in WebAssembly?
Ok, let us write it in "real” WebAssembly.
Here is the result:

{% include figure image_path="assets/uploads/2019-06-18/wasm-code.png" alt="WASM Code" caption="Hello, World in WebAssembly" %}

Can you do that on your own?
Are you sure about that?
In case you are wondering what these hexadecimal values mean, you can look into [WebAssembly specification](https://webassembly.github.io/spec/core/index.html).

So, why have I showed you this?
Because **it is a WebAssembly, real WebAssembly you heard a lot before**.
It is not a language you can code; It is a binary format to compile to.

### WebAssembly has a text format I can code

Yes, it has.
Though it is a toolchain, that allows you to write some Lisp-like code and emit the binary, you saw above.
It is not designed to be used as a general purpose programming language.

Here, it is the code that emits the binary above, function with a "Hello, World" and adder:

```lisp
(module
  (type $t0 (func))
  (type $t1 (func (param i32 i32) (result i32)))
  (import "main" "sayHello" (func $main.sayHello (type $t0)))
  (func $add (export "add") (type $t1) (param $p0 i32) (param $p1 i32) (result i32)
    get\_local $p0
    get\_local $p1
    i32.add)
  (func $f2 (type $t0)
    call $main.sayHello)
  (func $f3 (type $t0)
    nop)
  (memory $memory (export "memory") 0)
  (start 2))
```

Much better, right?
At least, you can see familiar keywords now.
This format is called WAT (WebAssembly Text).

But even so…
Can you use it as a general purpose programming language?
I don't think so.

### Why all this

I wanted to show you that WebAssembly is not a language at all.
It is our first myth to demystify here.
**WebAssembly is a binary format, not the language you can code!**

**It is not a replacement for JavaScript!**
**It is not a replacement for C++!**
**It is not a replacement for X!**

It serves different goals:

- Have a binary format that don't tied to concrete processors and their architecture. So that, have a binary format that is portable.
- Allow other developers to compile their code to WebAssembly so that JavaScript developers could integrate with it.

## WebAssembly is a replacement for JavaScript

We already went through it before, but I wanted to pay more attention to it.

I’d say that WebAssembly is the "best friend" of JavaScript.
They come all along in parallel and help each other, because JavaScript can do things WebAssembly can't and otherwise.
And, since browser can run them both, on your website, there are a lot of possibilities opened.

Let us go through a basic scenario of "how could it be."

There is a studio called Adobe Premiere Pro.
It is a software program you can use for adding FX effects to your video and is written in C++ language.
What if we want to move it to the browser and make it online?
Well, you can now.

- Compilers like GCC/clang already can compile C++ code to the binary format WebAssembly. As a result, you get a `*.wasm` module that exports all needed for working with video, effects, etc.
- Virtual machines in browsers that execute JavaScript can already understand WASM binary format. You just load compiled `*.wasm` module to it and all those exported methods become accessible to your JavaScript code.
- You write UI in JavaScript, operate with the DOM, etc. but all the operations like "_add FX to this frame_" are going through exported methods from `*.wasm` module.

It is just a banal example and I hope it shows you the main idea - **WebAssembly lives together with JavaScript; it does not replace it**.

## WebAssembly is faster than JavaScript

We had an example above, where we were working with videos and FX for them.
I think you are wondering, this is a high-load operations.
How it’s possible to do such heavy operations like render the frame, etc.

Tough question.
I can't say here "Yes!" or "No!" because sometimes both answers are true.

It all depends on a compiler that is compiling your code to WebAssembly and what optimization does it apply.
If you are working with a frame, like in our example, it is just a series of numbers you need to process somehow.
Since WASM has a support for SIMD operations and has access to shared memory in RAM, it will be faster to process these operations than with JavaScript _(in case, compiler will use these techniques)_.

However, if you want to make some changes in DOM, render some React component for example, it will not be faster than JavaScript.
Because it is the place where inter-ops coming in play and you need to switch contexts while executing WebAssembly.
This costs a lot of CPU time.

So, regard to this myth **it depends!**
However, do not forget that WebAssembly is not a replacement for JavaScript.
So, what is the point in comparing their performance to each other?

## Epilogue

I hope the article cleared some things for you regard to WebAssembly.
There are many people who got the idea wrong, so it will be nice from you if you will share the article with your friends and help them understand the idea better.

Ask more questions in the comments section below.
I wrote the article in a few hours; it was like mine mindflow.
Therefore, any updates to the article are possible if something is unclear here.
Thanks for reading!

Follow me on [Twitter](https://twitter.com/ghaiklor), [GitHub](https://github.com/ghaiklor)

---

*Eugene Obrezkov, Senior Software Engineer, Kyiv, Ukraine.*
