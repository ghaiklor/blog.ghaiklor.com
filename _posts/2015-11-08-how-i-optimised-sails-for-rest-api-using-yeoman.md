---
categories:
- Tools
tags:
- node.js
- sails
- javascript
- rest
- api
- yeoman
- scaffold
header:
  overlay_filter: 0.5
  overlay_image: assets/uploads/2015-11-08/sails.jpg
  caption: Photo by Jeremy Bishop on Unsplash
  teaser: assets/uploads/2015-11-08/sails.jpg
title: How I optimised Sails for REST API using Yeoman
excerpt: We often face the problem of duplicating code at our work. I’ve faced the
  same when working with Sails and REST API. What if we could automate some workflows?
---

_TL;DR_ If you are not interested in reading the post and want to see the results, check out my repository — [generator-sails-rest-api](https://github.com/ghaiklor/generator-sails-rest-api).

Otherwise, let’s dive into terminology before reading.
I want to be sure you understand terms and what I’m talking about.

## What is REST API?

Let’s look at Wikipedia:

> In computing, Representational State Transfer (REST) is the software architectural style of the World Wide Web. REST gives a coordinated set of constraints to the design of components in a distributed hypermedia system that can lead to a higher-performing and more maintainable architecture.

Building RESTful web services, like other programming skills is part art, part science.
As the Internet industry progresses, creating a REST API becomes more concrete, with emerging best practices.
As RESTful Web services don’t follow a prescribed standard except for HTTP, it’s important to build your RESTful API under industry best practices to ease development and simplify client adoption.

As Wikipedia said above, _“REST is the software architectural style”_.
It’s not a library you can install and work with.
It’s just a bundle of rules you need to follow when writing your web service.

## What do we used to develop a web service?

It shouldn’t come as a surprise if I said that it’s hard to build a web service without frameworks or libraries that implement an abstract layer on top of HTTP protocol.
If you don’t want to use libraries, handle all the low-level stuff yourself, which is boring…

That’s why many people are using [Express](http://expressjs.com), [Koa](http://koajs.com) or [Hapi](http://hapijs.com) to develop web services, but don’t consider using frameworks.
You could say: “What the hell? Express is a framework!”

**I’m brave enough to say that Express, Koa and Hapi are not frameworks!**

They are just extensible libraries, but the framework is a much wider term.

## What is the framework?

If you googled the definition of framework, you could find:

> Frameworks may include support programs, compilers, code libraries, tool sets, and application programming interfaces (APIs) that bring together all the different components to enable development of a project or solution.

It doesn’t seem that Express is using different components or has a tool set.

What about database component, for instance?
Database component may not be required in your project, but in reality, it’s used almost everywhere.
Express, Koa and Hapi don’t have this component.
You have to include another module that implements it.

If you’re still not convinced about this definition or think it’s too broad, lets clarify it with few more quotes.

According to Wolfgang Pree and his paper “[Meta Patterns: A Means for Capturing the Essentials of Reusable Object-Oriented Design](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.92.1202&rep=rep1&type=pdf)”:

> Frameworks comprise frozen spots and hot spots. Frozen spots define the overall architecture of a software system, that is to say its basic components and the relationships between them. These remain unchanged (frozen) in any instantiation of the application framework. Hot spots represent those parts where the programmers using the framework add their own code to add the functionality specific to their own project.

In a nutshell, frameworks **MUST** contain frozen spots in the architecture.
The spots, where architecture remains the same in any instantiation of the application.
But also **MUST** comprise hot spots where the developer can put his own code.

Frameworks also rely on the [Hollywood principle](https://en.wikipedia.org/wiki/Hollywood_principle) which is defined as:

> The Hollywood principle is a software design methodology that takes its name from the cliché response given to amateurs auditioning in Hollywood: “Don’t call us, we’ll call you”. It is a useful paradigm that assists in the development of code with high cohesion and low coupling that is easier to debug, maintain and test.

If framework follows the Hollywood principle, then you need not call API yourself.
You just write the code, the framework will call that itself.

For instance, this principle is used in React.
When you created a new component, you are declaring methods like _render_ or _componentDidMount_.
They will be called by React at the right time.

Relying on the information above, you can see my point that **Express, Koa or Hapi are not frameworks**.

If these “_frameworks_” are not in fact frameworks, then what are the real frameworks?

## Popular web frameworks

I prefer using frameworks over libraries.
Frameworks simplify our life a lot, do they not?

There are a lot of frameworks for Node.js.
You can find most of them [here](http://nodeframework.com) and chose one you like the most.
But, for now, I want to focus your attention on these:

- [Sails](http://sailsjs.org)
- [Strapi](http://strapi.io)
- [Loopback](http://loopback.io)
- [actionHero](http://www.actionherojs.com)

Each of them simplifies web service development based on REST principles.

When I first researched frameworks to use for work, I first considered using _Loopback_ as my base framework, but it’s daunting to learn for beginners.
_Strapi_ is announced only a few weeks ago and it still in development.
_actionHero_ seemed promising, but I wanted to choose something more comfortable, something that looks like Rails.

That’s why I had chose _Sails_ which is built on _Express_.
_Sails_ provides Rails-like architecture, it’s easier to work with it if you worked with Rails before.

## Why Sails?

Let’s dive deeper into Sails and answer a simple question “Why Sails?”

Official landing page says the next:

> It is designed to emulate the familiar MVC pattern of frameworks like Ruby on Rails, but with support for the requirements of modern apps: data-driven APIs with a scalable, service-oriented architecture. It’s good for building chat, realtime dashboards, or multiplayer games; but you can use it for any web application project — top to bottom.

Sails looks like Ruby on Rails and you can build any application from usual web-sites to REST API services.

Let’s look at my list of pros and cons of using Sails:

Pros:

- Waterline — Sails bundles with Waterline ORM that provides data access layer, that supports many popular databases. It also supports relation model, so you can declare relations between your models.
- Blueprints (_shadow routes_). They are responsible for auto-generating REST routes to your models writing no code.
- Express — Sails built on Express. It means, that you can use a lot of written middleware for Express in your Sails application.
- Rails-like. Of course, Rails-like. You have separate folders for all of your _controllers_, _models_, _services_, etc…

Cons:

- Old JavaScript syntax. It’s 2015 and ES6 is popular as ever. You will have to integrate ES6 support yourself, but it’s worth it if you know how.
- Grunt. Sails is bundled with Grunt. First, Grunt is old and slow. Second, if you want to develop only REST API then you’ll face the issues with removing it from your project. Some could say, you can just use _no-frontend_ option, I tried that; it doesn’t work at all.
- Views. Same can be said about views. If you want to disable them, you must do it yourself and it costs time.
- Web-socket support is great, but… We don’t need that if we’re building stateless RESTful web service.
- Policies. They can reject access to routes and it’s a useful thing. But, when you face the issue with field-based ACL or configuring flexible list of rules — you’re trapped.
- Blueprints (_shadow routes_) — both great and not. Sails’ default blueprints are written with web-socket support and not optimized for REST.

As you can see, there are a lot of cons against pros.
Great news — we can fix them.

You can disable unused hooks, remove unused files, override blueprints and so on…

## Making Sails better

I remember when I got another project at work that should have been built on Node.js and implement REST API, this is the first time I used Sails and faced all the problems described above.

I realized that this will not be my last REST API project, so I thought on how to mitigate all these issues in future projects without wasting my time again.

That’s how I found [Yeoman](http://yeoman.io).

> Yeoman helps you to kickstart new projects, prescribing best practices and tools to help you stay productive. To do so, we provide a generator ecosystem. A generator is a plugin that can be run with the `yo` command to scaffold complete projects or useful parts.

Yeoman’s ideology was inspired from Rails’ scaffolder.
Yeoman is what I’ve been looking for.
I can write the generator that contains all the fixed parts of Sails project and scaffolds changed project again and again.

Combining Sails and Yeoman allows to me to create a lot of sub-generators responsible for scaffolding different parts of the project and create a generator that composes all the sub-generators in one, allowing to start the Sails project with all fixed issues in one command.

## Let me create the generator

I’ve fixed simple issues like overriding blueprints and responses.
Step by step, I made a bunch of fixes in Sails project:

- Created a lot of simple generators that can be called separately and generate models, controllers, etc…
- Disabled Sails hooks that aren’t used in RESTful web services, like _views_ or _grunt_.
- Integrated ES6 (Babel) support in the project.
- Overridden blueprints that fit into REST rules and add new features like _fields_ support in requests or _populate_.
- I changed project configuration to fit into REST rules.
- Overridden responses to have a more consistent structure.
- And a lot more… you can read [here](https://github.com/ghaiklor/generator-sails-rest-api#features).

I was happy to see how this generator works, but in business reality I faced one more issue.
For every new project I had to integrate third-party services like Apple Push Notification or configuring SMTP server.
I felt like I was copying a lot of code from previous projects.

I made it more convenient and move to separate services with consistent API.
Then these services were published on npm and here is what I got:

- [CipherService](https://github.com/ghaiklor/sails-service-cipher) wraps different ciphers under consistent API like JWT.
- [HashService](https://github.com/ghaiklor/sails-service-hash) wraps hashes, it only supports _bcrypt_ for now.
- [ImageService](https://github.com/ghaiklor/sails-service-image) wraps common operations with images like getting parsed IPTC block or cropping an image.
- [LocationService](https://github.com/ghaiklor/sails-service-location) wraps geocoding and reverse geocoding functionality.
- [MailerService](https://github.com/ghaiklor/sails-service-mailer) wraps different mail providers, providing you with a consistent API for using in your business logic.
- [PaymentService](https://github.com/ghaiklor/sails-service-payment) wraps common operations like checkout from debit/credit card.
- [PusherService](https://github.com/ghaiklor/sails-service-pusher) allows you to send push notifications to different platforms (iOS, Android) using consistent API.
- [SmsService](https://github.com/ghaiklor/sails-service-sms) sends SMS to phone numbers. It’s helpful when you are using verification codes.
- [SocialService](https://github.com/ghaiklor/sails-service-social) wraps API calls to different social networks to parse profile or get posts.
- [StorageService](https://github.com/ghaiklor/sails-service-storage) allows to you use different storage provider (Amazon S3, for instance) with consistent API.

These services simplify RESTful web service development considerably.
I can remember API each of the services and use them with any provider that implemented in these services.

I thought it would be great to include these services in the generator.
I can then choose storage and pusher features and get installed services in my project out of the box.
Afterwards, all that’s left to do is just configure each of them with API keys and write business logic without having to think about integration at all.

## Happy Birthday

That’s how _generator-sails-rest-api_ has come to our world.
After 1,256 commits and 46 releases it’s stable enough to use in production.

## Let’s cook

With all this history out of the way, we can cook our REST API.

All you need to do is just install two dependencies: _yo_ and _generator-sails-rest-api_.

```shell
npm install -g yo generator-sails-rest-api
```

Afterwards, you can call the generator in your project’s folder with one command and enter the interactive mode.

```shell
mkdir my-awesome-project
cd my-awesome-project
yo sails-rest-api
```

Answer the questions you’ll be prompted, and you got Sails project you can start with _npm start_ as any other project.

```shell
npm start
```

Now we can add some models with REST interfaces.
It’s simple as ever.

```shell
yo sails-rest-api:model Ticket
```

Create as many models as you need and start the application via _npm start_.

## That’s it :)

Congratulations, you just have set up Sails project optimized for REST rules.

If you want to read more about sub-generators and what they can generate, follow the [link](https://github.com/ghaiklor/generator-sails-rest-api/wiki/Sub-Generators) to our wiki.
I’m really excited to share our knowledge and experience in Sails with you in [generator-sails-rest-api](https://github.com/ghaiklor/generator-sails-rest-api).

* * *

_Eugene Obrezkov, Technical Leader and Consultant at Onix-Systems, Kirovohrad, Ukraine._
