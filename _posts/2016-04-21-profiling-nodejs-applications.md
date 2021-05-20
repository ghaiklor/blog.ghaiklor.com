---
title: Profiling Node.js applications
excerpt: >-
  Sometimes, your code that is running in Node.js becomes the bottleneck of your
  throughput. How to find the culprit? What are the tools we can use for
  looking?
categories:
  - How-To
tags:
  - node.js
  - javascript
  - profiler
  - performance
header:
  overlay_image: assets/uploads/2016-04-21/cctv.jpg
  overlay_filter: 0.5
  caption: Photo by Joe Gadd on Unsplash
  teaser: assets/uploads/2016-04-21/cctv.jpg
---

In previous articles, I talked about [Node.js internals]({% post_url 2015-08-23-how-does-node.js-work %}), [why Node.js is so fast]({% post_url 2015-11-14-why-nodejs-is-so-fast %}), [V8 internals]({% post_url 2016-03-25-how-v8-optimises-javascript-code %}) and its [optimization tricks]({% post_url 2016-04-05-optimizations-tricks-in-v8 %}).
That’s cool, but…
Understanding these things is not enough to write high-performance Node.js applications.
You still need to know how to profile your Node.js application, find the bottleneck and optimize it, knowing how Node.js and V8 optimizes it.

## Profiler

The main goal of a profiler is to measure all the CPU ticks spent on executing functions in your application.
There are also memory profilers, which can be used to find memory leaks, but in this article I’ll be talking about performance issues only.

For instance, Google Chrome (_or any other modern browser_) has a built-in profiler in DevTools, recording all the information about functions and how long it takes to execute them into a log file.
Afterwards, Google Chrome analyzes this log file, providing you with human-readable information about what’s happening (_Flamechart, stack, whatever_), so you can understand it and find the bottleneck.

Node.js has a built-in profiler, but with one difference.
It doesn’t analyze log files as Google Chrome does.
Instead, it just collects all the information into the log file and that’s it.
It means that you need to have some separate tool that can understand this log file and provide you with human-readable information.

Let’s skip the theory for now and start with a simple example.
I recommend you do everything I do step by step, so you can see what’s going on on your local machine as well (_my Node.js version is 5.10.1 and npm 3.8.7, I can’t guarantee this example to work for you if you have a different version of Node.js)_.

## Project with a bottleneck

Let’s imagine that the following example is some big project with performance issues.
I have chosen _crypto_ module and sync version of _pbkdf2_ specifically, because they decrease performance a lot and that’s what we want in this example.

```javascript
const crypto = require('crypto');

function hash(password) {
  const salt = crypto.randomBytes(128).toString('base64');
  const hash = crypro.pbkdf2Sync(password, salt, 10000, 512);

  return hash;
}

// Imagine that loop below is real requests to some route
for (let i = 0; i < 50; i++) {
  hash('random_password');
}
```

Running this snippet gives me:

```shell
$ time node server.js
9.24 real 9.21 user 0.02 sys
```

We definitely have an issue with performance here — **9.24 seconds**.
Let’s profile it!

## Collecting ticks information into a log file

Node.js has a flag which enables profiler — _prof_.
When you run your application with this flag, it collects the CPU ticks into the log file in the same folder where your script is.

Run Node.js with profiler and wait for it to finish:

```shell
node --prof server.js
```

Now, you have the log file with tick information.
This log file gets a name something like _isolate-*.log_.
If you try to see the content of the log file with a tool like _cat_, you will see a lot of un-readable information.
That’s why we need a tool for analyzing it.

## Analyzing log file

Until Node.js 4.x you have to use separate packages like [node-tick-processor](https://www.npmjs.com/package/node-tick-processor).
Since we have Node.js 5.10.1, we can use a built-in tool.

Run Node.js with flag _prof-process_ and provide path to log file, generated before.
Filename will be different, so replace it with yours.

```shell
node --prof-process isolate-0x101804a00-v8.log
```

After some time, you will get all information about your application, including amount of processor ticks spent for each function (_since we have a small example, we have few lines only_).

{% gist 9e23a51eb7680931912fe351a49d31eb %}

_prof-process_ analyzed ticks log file and now we have readable information about what’s happening in our script.
It has six sections: _Shared libraries_, _JavaScript_, _C++_, _Summary_, _C++ entry points_ and _Bottom up (heavy) profile_.

I’ll explain these sections another time, for now, let’s look at _Bottom (up) heavy profile_.
That’s the place where you get information about more heavy functions.

As we can see, 99.9% of CPU ticks are spent in _pbkdf2Sync_ function in _crypto.js_ module which is called from our _hash_ function.
This is our bottleneck.
Knowing that, we can optimize it, replacing synchronous function with asynchronous and provide a callback that will do some stuff after hashing.

```javascript
const crypto = require('crypto');

function hash(password, cb) {
  const salt = crypto.randomBytes(128).toString('base64');
  const hash = crypto.pbkdf2(password, salt, 10000, 512, cb);
}

// Imagine that loop below is real requests to some route
for (let i = 0; i < 50; i++) {
  hash('random_password');
}
```

Run our changed snippet via _time_:

```shell
$ time node server.js
2.64 real 9.91 user 0.07 sys
```

**9.24 seconds** versus **2.64 seconds**.
It runs 3.5 times faster.
Now, let’s profile it again and compare profiling results with the un-optimized version before:

```shell
node --prof server.js
node --prof-process isolate-0x101804a00-v8.log
```

{% gist 6232ce737310baf0d39a101f08a3b0f4 %}

We can see now, that in _Bottom up (heavy) profile_ not a lot of CPU ticks, comparing to 7431 at the previous time.
Also, there is no _hash_ function that calls _pbkdf2_.

This means that we have an optimized version of our server and there are no heavy functions.

## Summary

This was just a simple example to show you the basics of Node.js application profiling.
Knowing how to profile your applications and tools you can use to do it helps you make right decisions about what you need to optimize.

Thanks for reading!
I hope it helped you understand how to profile Node.js applications a little better.
Tweet [me](https://twitter.com/ghaiklor) on Twitter if you have questions or suggestions about my articles.

---

*Eugene Obrezkov, Developer Advocate at [Onix-Systems](https://onix-systems.com), Kirovohrad, Ukraine.*
