---
title: Why Node.js is so fast?
excerpt: >-
  There is a lot of noise coming up lately about Node.js and its speed. But how
  come the JavaScript engine become one of the fastest engines?
categories:
  - Explained
tags:
  - node.js
  - javascript
  - v8
  - virtual machine
  - event loop
header:
  overlay_image: assets/uploads/2015-11-14/speed.jpg
  overlay_filter: 0.5
  caption: Photo by PAUL SMITH on Unsplash
  teaser: assets/uploads/2015-11-14/speed.jpg
---

Here I am again with an article about Node.js!
Today I want to speak about another Node.js advantage — execution speed.
**What do I mean by “execution speed”?**

It can be anything ranging from calculating Fibonacci sequence to querying database.

When talking about web-services, execution speed comprises everything that is needed to process requests and send the response to the client.
That’s what I mean — time spent on processing request, starting from opening connection to client receiving the response.

As soon as you understand what’s going on in Node.js server when it processes the requests, you will realise why it is so fast.

But before talking about Node.js, let’s look at how request handling is done in other languages.
PHP is the best example because it is popular and un-optimized.

## PHP drawbacks

Here is a list of drawbacks that decrease execution performance in PHP:

- PHP is synchronous. It means when you are processing a request, writing to the database, for instance, it blocks any other operations, so you will have to wait for it to finish, before you can do anything else.
- Each request to web-service creates a separate PHP interpreter process that is running your code. Thousands of connections means thousands of running processes that take your RAM. You can see how your used memory is growing up with your active connections.
- PHP doesn’t have a JIT compilation. It’s important when you have code that is executed often and you want to be sure that this code is as close to machine code as possible for better performance.

These are only the most critical problems with PHP, but there are a lot more, in my humble opinion.

Now let’s see how Node.js handles these problems.

## Node.js advantages

- Node.js is single-threaded and asynchronous. Every I/O operation doesn’t block other operations. This means you can read files, send emails, query the database, etc. and at the same time.
- Each request to web-server does NOT create a separate Node.js process. Instead, one Node.js process is running at all times and listens to connections. JavaScript code is executed in the main thread of this process and all I/O operations are executed in separate threads, meaning almost no delays.
- The virtual machine in Node.js (V8) that executes JavaScript has a JIT compilation. When the virtual machine takes source code, it can compile it to machine code at runtime. This means that “hot” functions that get called often can be compiled to machine code, improving execution speed.

Now we’ve seen advantages of asynchronous concept, let me explain how it works in Node.js.

## Know your asynchronous

Let me give you an example of an asynchronous processing concept (thanks to [Kirill Yakovenko](https://medium.com/u/31c245cac677)).

> Imagine you had 1,000 balls on the top of the mountain. You need to push them all to the bottom of the mountain. You can’t really push them all at the same time, you’ll have to push them one by one, but that doesn’t mean that you have to wait for each ball to get to the bottom of the mountain before pushing the next one.

In this example, synchronous execution would wait for a ball to roll down to the bottom before pushing another one, which is a waste of time.

Asynchronous execution would push all the balls one by one, then waiting for them all to get down (receiving a notification) and collecting results.

How does this help in web-server performance?

Let’s say that each ball is one query to the database.
You have a big project with many queries, aggregations, etc.
When you are processing all the data synchronously, it blocks the code execution.
When you are processing it asynchronously, you can execute all the queries at once and then just collect the results.

In the real world, when you have a lot of connections, it improves performance.

How is the asynchronous concept implemented in Node.js?

## Event loop

Event loop is a construction responsible for dispatching events in a program that almost always operates asynchronously with the message originator.
When you call an I/O operation, Node.js stores the callback assigned with that operation and continue processing other events.
Callback will be triggered when all needed data are collected.

Here is a more advanced definition of the event loop:

> The event loop, message dispatcher, message loop, message pump, or run loop is a programming construct that waits for and dispatches events or messages in a program. It works by making a request to some internal or external “event provider” (which generally blocks the request until an event has arrived), and then it calls the relevant event handler (“dispatches the event”). The event-loop may be used in conjunction with a reactor, if the event provider follows the file interface, which can be selected or ‘polled’ (the Unix system call, not actual polling). The event loop almost always operates asynchronously with the message originator.

Let’s look at a simple graph that explains how event loop works in Node.js.

{% include figure image_path="assets/uploads/2015-11-14/nodejs-event-loop.png" alt="Node.js Event Loop" caption="Image Source: <https://dou.ua/forums/topic/31698>" %}

When a request is received by web-server, it goes to the event loop.
Event loop registers operation in a thread pool with assigned callback.
Callback will be triggered when processing requests are done.
Your callback also can do other intensive operations like querying the database, but it does so the same way — registers operation in a thread pool with assigned callback and so on…

But what about code execution and its speed?
Next, we will talk about a virtual machine that executes JavaScript code — V8.

## How V8 optimise your code

Thanks to [Wingolog](https://wingolog.org/tags/v8), where it is described how V8 works, I can simplify that material and make a thesis.

I will talk about basic concepts of V8 and how it optimise JavaScript code, but it will still be technical, so fell free to skip this chapter if you are not familiar with how compilers work.
If you want to know more about V8, go to [V8 Resources](http://mrale.ph/v8/resources.html).

V8 has two types of compilers (_There is also a third compiler in development which is called Turbofan_): “Full” compiler and “Crankshaft” compiler.

The “full” compiler runs fast and produces generic code.
It takes AST ([Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree)) of a JavaScript function and translates it to a generic native code.
At this stage, it applies only one optimization — [Inline Caching](https://en.wikipedia.org/wiki/Inline_caching).

When function was compiled and code is running, V8 starts the profiler thread to see, which functions are hot and which are not, also collecting the type feedback, so V8 can record the type information flowing through it.

Once V8 has identified that a function is “hot” and has some type feedback information, it tries to run the augmented AST through an optimizing compiler — “Crankshaft” compiler.

The “Crankshaft” compiler doesn’t run as fast but tries to produce the optimized code.
It comprises two components: Hydrogen and Lithium.

Hydrogen compiler builds CFG ([Control Flow Graph](https://en.wikipedia.org/wiki/Control_flow_graph)) from AST (based on type feedback information).
This graph is presented in SSA ([Static Single Assignment](https://en.wikipedia.org/wiki/Static_single_assignment_form)) form.
Based on simple structure of HIR ([High-Level Intermediate Representation](https://en.wikipedia.org/wiki/Intermediate_language)) and SSA form, compiler can apply many optimizations like [constant folding](https://en.wikipedia.org/wiki/Constant_folding), [method inlining](https://en.wikipedia.org/wiki/Inline_expansion), etc…

Lithium compiler translates the optimized HIR into a LIR ([Low-Level Intermediate Representation](https://en.wikipedia.org/wiki/Intermediate_language)).
The LIR is similar to machine code, but still platform-independent.
In contrast to HIR, LIR form is closer to [a three-address code](https://en.wikipedia.org/wiki/Three-address_code).

Only then this optimized code replace the old un-optimized code and continue executing your code much faster.

## Useful links

- [Crazy Russian compiler engineer that talks](http://mrale.ph)
- [Andy Wingo’s Blog](https://wingolog.org/tags/v8)
- [V8 Resources](http://mrale.ph/v8/resources.html)

---

_Eugene Obrezkov, Technical Leader and Consultant at Onix-Systems, Kirovohrad, Ukraine._
