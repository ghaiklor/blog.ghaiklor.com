---
title: How Node.js requires native shared objects
excerpt: >-
  I faced an issue with requiring native bindings in Node.js code. So I
  wondered, how do they work in Node.js? In this post, I’m trying to explain how
  native addons become require-able in Node.js.
categories:
  - Explained
tags:
  - node.js
  - javascript
  - c++
  - shared
  - library
  - native
  - addon
header:
  overlay_image: assets/uploads/2017-02-08/sharing.jpg
  overlay_filter: 0.5
  caption: Photo by Gary Bendig on Unsplash
  teaser: assets/uploads/2017-02-08/sharing.jpg
---

## What is .node files and why do we need them

Sometimes, we are using npm packages that have native bindings for their purposes.
Sometimes, we are building our own C++ code to extend the Node.js functionality for our own purposes.
In both cases, we need to build an external native code to an object that can be usable by Node.js.

And that’s what _.node_ files are for.
_.node_ files are dynamically shared objects that Node.js can load to its environment.
Making an analogy here, I would say that _.node_ files are very similar to _.dll_ or _.so_ files.

## Where does require method come from

Before digging into internals, let’s remember where _require()_ comes from.
All the JavaScript files are actually wrapped into functions:

```javascript
const WRAPPER = [
  '(function (exports, require, module, __filename, __dirname) { ',
  '})'
];

const JS_SOURCE = 'script here';
const WRAPPED_SCRIPT = WRAPPER[0] + JS_SOURCE + WRAPPER[1];
```

So, let us say, you have some _index.js_ file with the following content:

```javascript
const fs = require('fs');
```

When Node.js tries to load it, it will look like this:

```javascript
(function (exports, require, module, __filename, __dirname) {
  const fs = require('fs');
})
```

This means that all files and scripts are functions that Node.js will call when needed.
However, that means that _require()_ method is provided when calling this function.

That function is being called in _NativeModule.prototype.compile()_ method:

{% gist 45a906a618444604bbb3b04a570dd38e %}

As we can see, _require()_ method is pointing to _NativeModule.require()_ method.

However, there is another type of module.
_NativeModule_ loads internal modules, but _Module_ loads your modules (aka userland).

_Module.compile()_ has similar implementation as well:

{% gist 5a9d914347644cab3aa7ea416b8de8cb %}

Here, _compile_ wraps source into a function and calls it.
And, for this case, _require_ argument is _internalModule.makeRequireFunction.call(this)_.

So, for different modules Node.js uses different loaders: _NativeModule_ and _Module_.
However, we will talk about _Module_ only.

Module has the following _require()_ implementation:

{% gist 5adb6aababd8d2d06758ca4ac923a688 %}

So, our _require()_ method, we are heavily using, is actually a pointer to _Module.prototype.require()_ method.
If I drop the details, then that’s all you should know, that _require()_ -> _Module.prototype.require()_.

## Requiring .node file

Ok, so now, we know what is _require()_ in our code.
What happens if we will require a _.node_ file:

```javascript
const myBindings = require('./build/Release/my-binding.node');
```

What’s happened there?
What was happening in _require()_?

Well, first, it goes into _Module.prototype.require()_ method which calls *Module._load()* method with a provided path.
In our case, *./build/Release/my-binding.node*.
Here is the implementation:

{% gist 405ed06d4bdaec5d49f6cf8821195ac3 %}

It checks, if our module exists in cache and, if not, it creates a _Module_ instance and calls _tryModuleLoad()_ function, providing the instance and a filename of our binding.
All _tryModuleLoad()_ is trying to do is to call _load()_ method on its instance.
Here is an implementation of _load()_ method:

{% gist 9abac5a6efb24829312c755c88713519 %}

Here, it goes through a list of defined extensions in *Module._extensions*.
This list contains functions that are processing loading of different file types.
At the time of writing this article, this list contains functions for _.js_, _.json_ and _.node_ files.
Though I bet that this really will not be changed, anyway.

So, if it finds extension in that list, in our case _.node_, then it calls a function with a path to the module you want to require.
In case with _.node_ extension it calls a method that has _process.dlopen()_ method, which is a binding from Node.js C++ sources into a JavaScript context.

{% gist 365ff0b399b79782558bfe0bc022173d %}

_dlopen()_ method is actually very similar to how _.dll_ or _.so_ files are loaded on Windows and Linux.
Here is an implementation of a method that injects into JavaScript context as _process.dlopen()_ method:

{% gist 048d68dbec37168f1720f039d14b68bf %}

It tries to load a shared object via libuv API and if everything works as expected; it registers this dynamically shared object in _exports_ object, returning it into a JavaScript context.

## Summary

Basically, that’s how _require(‘binding.node’)_ works, so you can build C++ code to share an object, using _node-gyp_, and require it in your JavaScript code.

Don’t forget to follow me here if you’re interested in such things.
Get in touch with me on [Twitter](https://twitter.com/ghaiklor).
Ask questions.
Thanks for reading.

## Related articles and videos

[How does Node.js work?]({% post_url 2015-08-23-how-does-node.js-work %})
[Creating Native Addons — General Principles](https://www.youtube.com/watch?v=UtWP2iR3_DQ)
[Addons API](https://nodejs.org/api/addons.html)

---

*Eugene Obrezkov, Senior Node.js Developer at Kharkov, Ukraine.*
