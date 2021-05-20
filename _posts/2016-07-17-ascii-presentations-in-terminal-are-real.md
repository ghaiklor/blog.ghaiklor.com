---
title: ASCII presentations in the terminal are real
excerpt: >-
  Have you ever wondered if it is possible to make slides in terminal? I had and
  figured out that it is not a simple task. Fortunately, I built the tool to
  write slides to show them later in the terminal.
categories:
  - Tools
tags:
  - node.js
  - javascript
  - typescript
  - ascii
  - terminal
  - figlet
  - slides
header:
  overlay_image: assets/uploads/2016-07-17/slide.jpg
  overlay_filter: 0.5
  caption: Photo by Nathan Anderson on Unsplash
  teaser: assets/uploads/2016-07-17/slide.jpg
---

Today, I want to tell you about one interesting project called [Kittik](https://github.com/ghaiklor/kittik).
The main idea behind this project is to **create** and **show presentations** that support shapes, animations, embedding code, etc. right **in your terminal**.
Can you believe this?
Ok, let’s dig.

## Why do we need this

We are all hackers, if you are a geek, if you want to impress your auditory with amazing slides in your speech or just for fun — there are many uses you can imagine.

Personally, I’m using it in some of my speeches, light-talks.
And, you know, it looks impressive.
Let me show you a simple presentation with three slides.
It’s not so beautiful as you can create it, but the main purpose of a demo below is to show you all the shapes and animations, you can use, in few slides.

_NOTE: Since it’s a gif file with low FPS, you can notice some gaps; it’s normal. In reality, it works with no gaps._

{% include figure image_path="assets/uploads/2016-07-17/demo.gif" alt="Kittik Demo" caption="Kittik with few slides" %}

It looks amazing, doesn’t?
Remember, all of it renders in terminal!

## How to create slides

Next, I will tell you about creating presentations.
Kittik is a bundle of separated modules that are combined together in a package called _kittik_.
It exposes all the API you need to use, so I can say that _kittik_ is an SDK you can use for creating a presentation.

Since _kittik_ is written with Node.js, SDK it provides is a npm module you can install.
But there is a little improvement from me so you need not install npm modules and write code.

I’ve created a CLI tool for running your presentations crafted in YAML format.
Here is how it looks like:

```yaml
shapes:
  - name: 'Hello, Kittik'
    type: FigText
    options:
      text: 'Hello, Kittik'
      x: center
      y: middle
      foreground: red
animations:
  - name: Print
    type: Print
    options:
      duration: 2000
slides:
  - order:
      - 'Hello, Kittik::Print'
```

That was a first slide from our complex example above.
It’s just a simple YAML file you can declare and then use CLI tool for running it:

```shell
kittik start my-presentation.yml
```

## Any help

For now, I’m done with a stable version of all Kittik sub-modules and its core.
You can use it with no risks of breaking your presentation in future or getting an error when speaking on some conferences.

But I have a lot of plans how we can improve it all together.
It’s hard for me to support all the 12 modules alone.
So, I’m looking for anyone who is interested in things like this and wants to help.
We can get in touch via Skype, Gitter, Twitter, and I’ll be your mentor in this project.

Short list of things I would like to improve/create here:

- GUI editor in terminal, it can be a _blessed_ package or our own implementation. At the moment, you need to declare presentations by hand, we can simplify it by creating editor which will output these declarations automatically based on your choices.
- Improve existing shapes and animations with more options, review code and improve code style (_if needed_), write regression tests.
- Implement parsers. We have a spec you need to follow when passing it in Kittik SDK, but it’s hard to write a declaration by hand. Better to write Markdown file, for instance, and parse it with some kind of Kittik parsers which will return declaration for Kittik SDK.

That’s enough for now.
I truly believe that we can create something valuable together, so let’s do it.

Share it with your friends, maybe some of them want to join a team.
Recommend it to others.
Share your thoughts and feedback in response.
Thanks!

---

*Eugene Obrezkov aka ghaiklor, Developer Advocate, Kirovohrad, Ukraine.*
