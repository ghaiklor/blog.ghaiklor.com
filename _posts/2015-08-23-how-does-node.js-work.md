---
title: How does Node.js work?
excerpt: >-
  Were you ever wondering how Node.js works inside out? How JavaScript gets
  access to file systems, network, etc? How C++ code becomes callable from
  JavaScript? These and many other questions are answered here!
categories:
  - Explained
tags:
  - node.js
  - javascript
  - c++
  - virtual machine
  - v8
header:
  overlay_image: assets/uploads/2015-08-23/node-js.jpg
  overlay_filter: 0.5
  caption: "Photo Credit: Prince Pal"
  teaser: assets/uploads/2015-08-23/node-js.jpg
---

Hi everyone! My name is Eugene Obrezkov, and today I want to talk about one of
the “scariest” platforms — Node.js. I will answer one of the most complicated
questions about Node.js — “**How does Node.js work?**”.

I will present this article as if Node.js didn’t exist at all. This way, it
should be easier for you to understand what’s going on under the hood.

The code found in this post is taken from existing Node.js sources, so after
reading this article, you should be more comfortable with Node.js.

## What do we need this for

The first question that may come to your mind — **“What do we need this for?”**.

Here, I’d like to quote Vyacheslav Egorov:

> _The more people stop seeing JS VM as a mysterious black box that converts
> JavaScript source into some zeros-and-ones the better._

The same idea applies to Node.js: _“The more people stop seeing Node.js as a
mysterious black box that runs JavaScript with low-level API the better”_.

## Just Do It

Let’s go back to 2009, when Node.js started its way.

We’d like to run JavaScript on back-end and get access to low-level API. We also
want to run our JavaScript from CLI and REPL. We want **JavaScript to do
everything**!

How would we do this? The first thing that comes to my mind is…

## Browser

Browser can execute JavaScript. So we can take a browser, integrate it into our
application, and that’s it.

Not really! Here are the questions that need to be answered:

- Does browser expose low-level API to JavaScript? No!
- Does it allow to run JavaScript from somewhere else? Both yes and no, it’s
  complicated!
- Do we need all the DOM stuff that the browser gives us? No! It’s overhead.
- Do we need browser at all? No!

We don’t need that. **JavaScript is executed without a browser**.

If the browser is not a requirement for executing JavaScript, **what executes
JavaScript then?**

## Virtual Machine (VM)

**Virtual Machine executes JavaScript!**

VM provides a high-level abstraction — that of a high-level programming language
(compared to the low-level ISA abstraction of the system).

VM is designed to execute a single computer program by providing an abstracted
and platform-independent program execution environment.

There are lots of virtual machines that can execute JavaScript including **V8**
from Google, **Chakra** from Microsoft, **SpiderMonkey** from Mozilla,
**JavaScriptCore** from Apple and more. Choose wisely, because it may be a
decision you may regret for the rest of your life.

I suggest that we choose Google’s V8, why? Because it’s faster than other VMs. I
think you’ll agree that execution speed is important for back-end.

Let’s look at V8 and how it can help to build Node.js.

## V8 VM

**V8 can be integrated in any C++ project**. Just take V8 sources and include
them as a simple library. You can now use V8 API that allows you to compile and
run JavaScript code.

**V8 can expose C++ to JavaScript**. It’s very important as we want to make
low-level API available within JavaScript.

Those two points are enough to imagine rough implementation of our idea — “How
we can run JavaScript with access to low-level API”.

Let’s draw a line here about all this stuff above, because in the next chapter
we will start with C++ code. You can take Virtual Machine, in our case V8 ->
integrate it in our C++ project -> expose C++ to JavaScript with V8 help.

But **how can we write C++ code and make it available within JavaScript**?

## V8 Templates

**Via V8 Templates!**

A template is a blueprint for JavaScript functions and objects. You can use a
template to wrap C++ functions and data structures within JavaScript objects.

For example, Google Chrome uses templates to wrap C++ DOM nodes as JavaScript
objects and to install functions in the global scope.

You can create a set of templates and then use them. Accordingly, you can have
as many templates as you want.

And V8 has two types of templates: _Function Templates_ and _Object Templates_.

**Function Template** is the blueprint for a single function. You create a
JavaScript instance of template by calling the template’s _GetFunction_ method
from within the context in which you wish to instantiate the JavaScript
function. You can also associate a C++ callback with a function template called
when the JavaScript function instance is invoked.

**Object Template** is used to configure objects created with function template
as their constructor. You can associate two types of C++ callbacks with object
templates: _accessor callback_ and _interceptor callback_. _Accessor callback_
is invoked when a specific object property is accessed by a script. *Interceptor
callback* is invoked when any object property is accessed by a script. In a
nutshell, you can wrap C++ objects/structures within JavaScript objects.

Look at this simple example. All this does is expose the C++ method
*LogCallback* to the global JavaScript context.

{% gist 7f9d22dddae9b2e1f2f5 %}

At line #2, we are creating new _ObjectTemplate_. Then at line #3 we are
creating new _FunctionTemplate_ and associate C++ method _LogCallback_ with it.
Then we are setting this _FunctionTemplate_ instance to _ObjectTemplate_
instance. At line #9 we are just passing our _ObjectTemplate_ instance to new
JavaScript context, so that when you run JavaScript in this context, you’ll be
able to call method _log_ from global scope. As a result, the C++ method,
associated with our _FunctionTemplate_ instance, *LogCallback,* will be
triggered.

As you see, it’s like defining objects in JavaScript, only in C++.

**By now, we learned how to expose C++ methods/structures to JavaScript**. We
will now learn how to run JavaScript code in those changed contexts. It’s
simple. Just compile and run principle.

## V8 Compile && Run JavaScript

If you want to **run your JavaScript in created context**, you can make just two
simple API calls to V8 — *Compile* and _Run_.

Let’s look at this example, where we are creating a new _Context_ and running
JavaScript inside.

{% gist 8000ff81a90d8b96dd6e %}

At line #2, we are creating a JavaScript context (_we can change it with
templates described above_). At line #5, we are making this context active for
compiling and running JavaScript code. At line #8, we are creating a new string
from the JavaScript source. It can be hard-coded, read from the file or any
other way. At line #11 we are compiling our JavaScript source. At line #14 we
are running it and expecting results. That’s all.

Finally, **we can create simple Node.js**, combining all the techniques
described above :)

## C++ -> V8 Templates -> Run JavaScript -> X

You can create VM instance (_also known as Isolate in V8_) -> create as much
_FunctionTemplate_ instances, with assigned C++ callbacks, as you want -> create
_ObjectTemplate_ instance and assign all created _FunctionTemplate_ instances to
it -> create JavaScript context with a global object as our _ObjectTemplate_
instance -> run JavaScript in this context and Voila -> Node.js. Sweet!

But what is the "X" after “_Run JavaScript_” in chapter’s title? **There is a
little problem with implementation above**. We missed one very important thing.

Imagine, that you wrote a lot of C++ methods (_around 10k LOC_) which can work
with _fs_, _http_, _crypto_, etc… We have assigned them _[C++ callbacks]_ to
_FunctionTemplate_ instances and import them _[FunctionTemplate]_ in
_ObjectTemplate_. After getting JavaScript instance of this _ObjectTemplate_ we
have access to all the _FunctionTemplate_ instances from JavaScript via global
scope. Looks like everything works great, but…

What if we don’t need _fs_ right now? What if we don’t need _crypto_ features at
all? What about not getting modules from global scope, but requiring them on
demand? What about not writing C++ code in one big file with all the C++
callbacks in there? So question mark means…

**Modularity!**

All those C++ methods should be split in modules and in different files (_it
simplifies the development_) so that each C++ module corresponds to each _fs,_
_http_ or any other feature. The same logic is in JavaScript context. All the
JavaScript modules must not be accessible from global scope, but accessible on
demand.

Based on these best practices we need to implement our own module loader. That
module loader should handle loading C++ modules and JavaScript modules so we can
grab C++ module on demand from C++ code and the same for JavaScript
context — grab JavaScript module on demand from JavaScript code.

**Let’s start with C++ Module Loader first**.

## C++ Module Loader

Disclaimer: _There will be a lot of C++ code here, so try not to lose your
mind :)_

Let’s start with basics of all module loaders. Each module loader must have a
variable that contains all modules (_or information on how to get them_). Let’s
declare C++ structure to store information about C++ modules and name it
_node_module_.

{% gist ac2ba1b5003c99f12e56 %}

We can store information about existing modules in this structure. As a result,
we have a simple dictionary of all available C++ modules.

I will not explain all the fields from the structure above, but I want you to
pay attention to one. In _nm_filename_ we can store filename of our module, so
we know where to load it from. In _nm_register_func_ and
_nm_context_register_func_, we can store functions we need to call when the
module is required. These functions will instantiate _Template_ instance. And
_nm_modname_ can store module name (_not filename_).

Next, we need to implement helper methods that work with this structure. We can
write a simple method that can save information to our _node_module_ structure
and then use this method in our module definitions. Let’s call it
_node_module_register_.

{% gist f83961d73e1bca8515e3 %}

As you can see, all we are doing here is just saving new information about
module into our structure _node_module_.

Now we can simplify registering process using a macro. Let’s declare a macro you
can use in your C++ module. This macro is just a wrapper for
_node_module_register_ method.

{% gist baf48d481128413d6dd8 %}

First macro is a wrapper for _node_module_register_ method. The other one is
just a wrapper for previous macro with some pre-defined arguments. As a result
we have a macro that accepts two arguments: _modname_ and _regfunc_. When it’s
called, we are saving new module information in our _node_module_ structure.
What do _modname_ and _regfunc_ mean? Well… _modname_ is just our module name,
like _fs_, for instance. _regfunc_ is a module method we talked about earlier.
This method should be responsible for _V8 Template_ initialization and assigning
it to _ObjectTemplate_.

As you can see, we can declare each C++ module within a macro that accepts
module name (_modname_) and initialization function (_regfunc_) that will be
called when the module is required. All we need to do is just create C++ methods
that can read that information from _node_module_ structure and call _regfunc_
method.

Let’s write a simple method that will search for a module in the _node_module_
structure by its name. We’ll call it _get_builtin_module_.

{% gist aade1f6bfd3b598bc051 %}

This will return declared module if name matches the _nm_modname_ from
_node_module_ structure.

Based on information from _node_module_ structure, we can write a simple method
that will load the C++ module and assign _V8 Template_ instance to our
_ObjectTemplate_. As a result, this *ObjectTemplate* will be sent as a
JavaScript instance to JavaScript context.

{% gist ddd6c57e9f8cbae06d81 %}

A few notes regarding the code above. _Binding_ takes module name as an
argument. This argument is a module name you gave that via macro. We are looking
for information about this module via _get_builtin_module_ method. If we find
it, we call initialization function from this module, sending some useful
arguments like _exports_. _exports_ is an _ObjectTemplate_ instance, so we can
use _V8 Template_ API on it. After all these operations, we get the _exports_
object as a result from _Binding_ method. As you remember, _ObjectTemplate_
instance can return JavaScript instance and that’s what _Binding_ does.

The last thing we should do is make this method available from JavaScript
context. We do this at the last line by wrapping _Binding_ method in
_FunctionTemplate_ and assigning it to the global variable _process_.

At this stage, you can call _process.binding(‘fs’)_ for instance, and get native
bindings for it.

Here is an example of a built-in module with omitted logic for simplicity.

{% gist ac22b0ce38f23847e00b %}

The code above will create a binding with a name “_v8”_ that exports JavaScript
object, so that calling _process.binding(‘v8’)_ from JavaScript context gets
this object.

Hopefully, you are still following along.

Now **we should make JavaScript Module Loader** that will help us do all the
neat stuff like _require(‘fs’)_.

## JavaScript Module Loader

Great, thanks to our latest improvements, we can call _process.binding()_ and
get access to C++ bindings from JavaScript context. But this still does not
resolve the issue with JavaScript modules. How can we write JavaScript modules
and require them on demand?

First, we need to understand that there are two different types of modules. One
of them is JavaScript modules we write alongside with C++ callbacks. In a
nutshell, these are Node.js built-in modules, like _fs_, _http_, etc… Let’s call
these modules **_NativeModule_**. The other type are modules in your working
directory. Let’s call them just **_Module_**.

We need to require both types. That means we need to know how to grab
_NativeModule_ from Node.js and _Module_ from your working directory.

**Let’s start with _NativeModule_ first.**

All JavaScript native modules are located within our C++ project in another
folder. That means that all the JavaScript sources are accessible at
compile-time. This allows us to wrap JavaScript sources into a C++ header file,
that we can use.

There’s a Python tool called _js2c.py_ for this (_located under tools/js2c.py_).
It generates _node_natives.h_ header file with wrapped JavaScript code.
_node_natives.h_ can be included in any C++ code to get JavaScript sources
within C++.

Now we can use JavaScript sources in C++ context — let’s try it out. We can
implement a simple method _DefineJavaScript_ that gets JavaScript sources from
_node_natives.h_ and assigns them to _ObjectTemplate_ instance.

{% gist 259372c5049dbc52b947 %}

In the code above, we are iterating through each native JavaScript module and
setting them into _ObjectTemplate_ instance with module name as a key and module
itself as a value. The last thing we need to do is call _DefineJavaScript_ with
_ObjectTemplate_ instance as _target_.

_Binding_ method comes in handy here. If you look at our _Binding_ C++
implementation (_C++ Module Loader_ section), you’ll see we hard-coded two
bindings: _constants_ and _natives_. Thus, if binding’s name is _natives,_ then
_DefineJavaScript_ method is called with _environment_ and _exports_ objects. As
a result, JavaScript native modules will be returned when calling
_process.binding(‘natives’)_.

So, that’s cool. But another improvement can be made here by defining GYP task
in _node.gyp_ file and calling _js2c.py_ tool from it. This will make it so that
when Node.js is compiling, JavaScript sources will also be wrapped into
_node_natives.h_ header file.

By now, we have JavaScript sources of our native modules available as the
_process.binding(‘natives’)_. Let’s write simple JavaScript wrapper for
_NativeModule_ now.

{% gist f11c8424310afb4b9018 %}

Now, to load a module, you call _NativeModule.require()_ method with module name
you want to load. This will first check if module already exists in cache, if
so — gets it from cache, otherwise the module is compiled, cached and returned
as _exports_ object.

Let’s inspect _cache_ and _compile_ methods now.

All _cache_ does is just setting _NativeModule_ instance to a static object
_\_cache_ in _NativeModule_.

More interesting is the _compile_ method. First, we are getting sources of
required module from _\_source_ (_we set this static property with
process.binding(‘natives’)_). We are then wrapping them in a function with
_wrap_ method. As you can see, resulting function accepts _exports_, _require_,
_module_, _\_\_filename_ and _\_\_dirname_ arguments. Afterwards, we call this
function with required arguments. As a result, our JavaScript module is wrapped
in scope that has _exports_ as pointer to _NativeModule.exports_, _require_ as
pointer to _NativeModule.require_, _module_ as pointer to _NativeModule_
instance itself and _\_\_filename_ as a string with current file name. Now you
know where all the stuff like _module_ and _require_ is coming from in your
JavaScript code. They are just pointers to _NativeModule_ instance :)

**Another thing is _Module_ loader implementation.**

_Module_ loader implementation is the same as with _NativeModule_, the
difference is that sources are not taken from _node_natives.h_ header file, but
from files we can read with _fs_ native module. So we are doing all the same
stuff as _wrap_, _cache_ and _compile_, only with sources read from the file.

Great, now we know how to require native modules or modules from your working
directory.

Finally, we can write a simple JavaScript module that will run each time we run
Node.js and prepare the Node.js environment using all the stuff above.

## Node.js Runtime Library

What is a runtime library? It’s a library that prepares the environment, setting
global variables _process_, _console_, _Buffer_, etc, and runs the main script
you send to Node.js CLI as an argument. We can achieve it with a simple
JavaScript file that will execute at Node.js runtime before all other JavaScript
code.

We can start with proxying all our native modules to global scope and setting up
other global variables. It’s just a lot of code that does something like
_global.Buffer = NativeModule.require(‘buffer’)_ or _global.process = process_.

Second step is running the main script which you send in Node.js CLI as an
argument. Logic is simple here. It just parses _process.argv[1]_ and creates
_Module_ instance with its value as a constructor value. So, _Module_ can read
sources from file -> cache and compile it as _NativeModule_ does with
pre-compiled JavaScript sources.

There’s not much I can add here, it’s simple, if you want more details though,
you can look at _src/node.js_ file in node repository. This file is executing at
Node.js runtime and uses all the techniques, described in this article.

**This is how Node.js can run your JavaScript code with access to low-level
API**. Cool, isn’t it?

But all the above can’t do any asynchronous stuff yet. All the operations like
_fs.readFile()_ are synchronous at this point.

What do we need for asynchronous operations? An **event loop…**

## Event Loop

Event loop is message dispatcher that waits for and dispatches events or
messages in a program. It works by making a request to some internal or external
event provider (which blocks the request until an event has arrived), and then
it calls the relevant event handler (dispatches the event). The event loop may
be used with a reactor if the event provider follows the file interface which
can be selected or polled. The event loop almost always operates asynchronously
with the message originator.

V8 can accept event loop as an argument when you are creating V8 Environment.
But before setting up an event loop to V8 we need to implement it first…

Luckily, we already have that implementation which is called _libuv_. It’s
responsible for all the asynchronous operations like read the file and others.
Without _libuv_ Node.js is just a synchronous JavaScript/C++ execution.

So, we can include _libuv_ sources into Node.js and create V8 Environment with
_libuv_ default event loop in there. Here is an implementation.

{% gist 08863a0db452379ae90d %}

_CreateEnvironment_ method accepts _libuv_ event loop as a _loop_ argument. We
can call _Environment::New_ from V8 namespace and send there _libuv_ event loop
and then configure it in V8 Environment. That’s how Node.js became asynchronous.

I’d like to talk about _libuv_ more and tell you how it works, but that’s
another story for another time :)

## Thanks

Thanks to everyone who has read this post to the end. I hope you enjoyed it and
learned something new. If you found any issues or something, comment and I’ll
reply as soon as possible.

---

_Eugene Obrezkov, Technical Leader at Onix-Systems, Kirovohrad, Ukraine._
