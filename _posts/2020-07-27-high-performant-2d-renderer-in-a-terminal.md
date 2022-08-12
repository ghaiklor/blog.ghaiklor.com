---
title: High performant 2D renderer in a terminal
excerpt: >-
  What if I told you, you can use TypeScript library to control the cursor in a
  terminal and render in a terminal pretty fast? It’s like ncurses, but for
  Node.js and very lightweight with no dependencies.
categories:
  - Tools
tags:
  - node.js
  - javascript
  - typescript
  - 2d
  - art
  - ascii
  - colors
  - fast
  - performant
  - renderer
  - terminal
header:
  overlay_image: assets/uploads/2020-07-27/snail.jpg
  overlay_filter: 0.5
  caption: Photo by Raimond Klavins on Unsplash
  teaser: assets/uploads/2020-07-27/snail.jpg
echo-screenshots:
  - url: assets/uploads/2020-07-27/echo-1.png
    image_path: assets/uploads/2020-07-27/echo-1.png
    alt: Changing foreground color
    title: Changing foreground color
  - url: assets/uploads/2020-07-27/echo-2.png
    image_path: assets/uploads/2020-07-27/echo-2.png
    alt: Changing format style
    title: Changing format style
  - url: assets/uploads/2020-07-27/echo-3.png
    image_path: assets/uploads/2020-07-27/echo-3.png
    alt: Changing background color
    title: Changing background color
  - url: assets/uploads/2020-07-27/echo-4.png
    image_path: assets/uploads/2020-07-27/echo-4.png
    alt: Changing color using RGB
    title: Changing color using RGB
  - url: assets/uploads/2020-07-27/echo-5.png
    image_path: assets/uploads/2020-07-27/echo-5.png
    alt: Changing position for the cursor
    title: Changing position for the cursor
---

Did you even think about the possibility to render something in a terminal with
a high throughput? Like, let us say, a video from a YouTube. Or, maybe, you
wanted to create a game with a UI in a terminal and you need something that you
can use as a low-level API to render your UI in a terminal.

Well then, you are reading the blog post that might interest you!

If you want to get straight to the interesting part, scroll to the end of the
article. Although, I recommend to not spoil the fun and read the article. {:
.notice--info }

We all know that the only way to interact with a terminal is by writing a text
to it. Which means that in order to do "rendering" in a terminal, we need to
manipulate the cursor.

## How to manipulate the cursor in the terminal

Turns out, the terminal [VT100](https://en.wikipedia.org/wiki/VT100) resolved
the problem years ago.

> The VT100 is a
> video [terminal](https://en.wikipedia.org/wiki/Computer_terminal), introduced
> in August 1978
> by [Digital Equipment Corporation](https://en.wikipedia.org/wiki/Digital_Equipment_Corporation) (DEC).
> It was one of the first terminals to
> support [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code) for
> cursor control and other tasks, and added a number of extended codes for
> special features like controlling the status lights on the keyboard. This led
> to rapid uptake of the ANSI standard, becoming
> the [de facto standard](https://en.wikipedia.org/wiki/De_facto_standard) for [terminal emulators](https://en.wikipedia.org/wiki/Terminal_emulator).
>
> Wikipedia

{% include figure image_path="assets/uploads/2020-07-27/vt100-terminal.jpg" alt="VT100 Terminal" caption="VT100 Terminal" %}

The terminal was so popular and successful on the market, that all modern
terminal emulators adopted the VT100 control codes and emulated them on their
own.

We are talking about ANSI escape codes here. It means all we need to do is
**write some text to standard output and terminal will interpret it as a control
code**.

Let us start with the simplest part - moving a cursor to a desired location. How
do we do that?

First, we start with a magic number that terminal knows about and if it sees it,
it will consume the text followed by like a control code. The magic number is -
**_1B_** (_HEX_).

Afterwards, we add the control code itself and write it to the standard output.
The control codes are all defined in a table that you can look up on the
Internet, like
[this one](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797).

So... moving the cursor. According to the table, we need to write
`<ESC>[<LINE>;<COLUMN>H`. `<ESC>` is a magic number we discussed before.

Imagine, we want to move the cursor to the 5th line and the 10th column. All we
need to do is write the following string to the standard output:

```shell
echo -e "\x1B[5;10H"
```

Maybe you wanted to change a color to a `rgb(128, 128, 128)`?

```shell
echo -e "\x1B[48;2;128;128;128m"
```

I do everything else in the same way. **You write a magic number followed by a
control code from a specification**. Here are some more examples of what we can
do with it:

{% include gallery id="echo-screenshots" caption="Examples for VT100 control codes" %}

That's all we need to make some kind of rendering, right? So lets try then!

## Initial Release

With a first release of the renderer, things were straightforward. We have a way
to manipulate the cursor in a terminal by using strings. All we need to do is
**wrap those strings into functions that can interpolate them and generate a
ready to write control code**.

A developer who is using the library just calls a function, let us say,
`moveTo(x, y)` and the function interpolates the correct string for moving a
cursor with a provided parameters and writes to standard output.

Implementation is so straightforward that I thought for a moment, "Here it is! I
did it!", but...

{% include video id="6_Dh0vQ0Uic" provider="youtube" %}

Can you see that? Am I imagining things or do we have a problem here?

## What went wrong with an initial release

We want to render a video in the terminal with a 25 frames per second. So in the
worst case we need to get everything done in 1000 (ms) / 25 (frames) = **40
milliseconds!**

Rendering a single pixel from a video to the specific cell in the terminal takes
two calls to the API: move the cursor and write the character - both are
separate writes to the standard output:

- First one is a control code for moving a cursor to the location where you want
  to output something
- Second one is an actual write of an ASCII character

All of it for a single pixel, but there are more of them! E.g. video with a size
128x128 means that we need to make `128 (pixels) * 128 (pixels) * 2 (per pixel)`
= **32,768 separate writes to the standard output**. In 40 milliseconds, no
more!

## Getting rid of frequent write

We could replace the immediate write to the standard output with some kind of
buffer, to postpone the write. This is what I did for a next release.

Instead of writing to the standard output, all the **renderer API calls now
write to the buffer in memory**. Developer can flush on demand then, when he/she
needs it.

The buffer itself is just a string that keeps getting new control codes by
concatenating the new one to the old. When time is come, a developer flushes a
content of the buffer by calling `flush()`.

That way, we can render the entire frame in memory, stacking up the control
codes, and then flush all the buffer at once to the standard output. No more
frequent write!

{% include video id="bawUgFmuz8w" provider="youtube" %}

Still a miss, such a disappointment...

## What went wrong again

We get rid of small, but frequent writes, that's true. But we did not eliminate
the size of the payload we need to flush. **So instead of small but frequent
writes we are now doing a single write with a huge payload**.

So I thought... Is there a way to minimize the size of the control codes we need
to flush?

I remembered about how video codecs are working and their algorithms to store
only the information that is changed. The same idea applies to our renderer now!
**We do not need to write a control code for a specific character in a specific
location if it is already there.**

To do that, I’ve added another buffer to the memory, alongside with a first one.
The new buffer collects all the control codes we flushed before _(previous frame
only)_. So I could track of what we flushed and what we will flush.

When a developer calls a flush method, renderer goes into the buffer that will
flush to the standard output and filter out from there all the control codes
present in the buffer that holds control codes from the previous flush.

When it finished the filtering - only then - it writes to the standard output.
This way **we have implemented a kind of diff algorithm between two frames.**

I know it could be hard to understand at first, but there is nothing new. Just
two strings, from the previous flush and the future one, and their slices
compared with each other on filtering.

{% include video id="DH_buHoRUL4" provider="youtube" %}

Much better! But can we go faster?

## Shower Thoughts

I couldn't see any solutions here. We did all we could, buffering, the
difference between the frames... What am I missing?

What if? We could stop stacking up the control codes in a single huge buffer.
Instead, render parts of the cells without flushing the entirety. Our buffer in
a current state is like a journal that keeps historic records for a terminal and
a terminal just "replays" everything that it sees in the journal. We don't need
that!

What if? We could get rid of flushing control codes that make no sense because
of some override effect later. E.g. moving the cursor to the same position and
writing the same character again and again will generate a lot of control codes,
though the last one makes sense only, because it will be the last one that is
applied by the terminal.

Through a lot of thinking, **the idea of "pixels" was born** with a clever trick
to implement it.

## Pixels

Before I could start implementing "pixels" I need to think about rendering them.
What must be the control code sequence that will allow us to render them
independent from each other. Without style conflicts and position conflicts.
What must be the sequence that will work at any time and in any circumstances.

Turns out, the solution was laying under my nose. All we need to do is to make a
rendering of specific pixel to follow the sequence:

- position the cell in the terminal
- set up the background color
- set up the foreground color
- set up display style (bold, dim, underlined, etc)
- write the actual character for the cell
- reset all the display style and colors to the default ones

That way, I could grab the specific pixel I want to render, generate a sequence
of control codes for rendering the pixel, and write it to the standard output.

Now, since we have a single pixel, nothing stops us from implementing a compound
entity that will hold those "pixels" - canvas.

## Canvas

Canvas pre-allocates an array of "pixels" according to the size of the terminal
and that way, creates a virtual terminal over the real one. All the calls to the
renderer API goes to the canvas and updates the state of each of those "pixels".

When a developer calls a flush method, canvas iterates over all “pixels” and
looks for those that have been modified since previous flush. When it finds a
changed “pixel” it takes its current state and generates a VT100 control code
that that renders the exact pixel with its exact state at the moment.

**That way we did a breakthrough!**

We generate VT100 control codes only for those who changed; we do not filter
them out anymore.

We flush nothing that makes no sense. Any updates to the cell will overwrite the
state before, and it will not generate the control code at all for the outdated
state.

**We created a virtual terminal over the real one!**

{% include video id="HP3Nr_X6MsA" provider="youtube" %}

## Polishing, Profiling

The result is near where I wanted it to be, but it has screen tearing issues
when there are a lot of changes between frames.

To overcome the issue, I dug into profiling tools, analyzed the byte-code,
minimized the number of operations CPU must do before rendering the frame.
Although, it is another story for another time.

**It made my code more unmaintainable, but faster in virtual machine!**

{% include video id="3nPAlhgKg4Q" provider="youtube" %}

## But, what if

We made a fast rendering in ASCII art, but what about colors?

{% include video id="egEJSlmCJ7I" provider="youtube" %}

What if we decrease the font size in the terminal, that way increasing the
density?

{% include video id="XCtnj8ZmqP8" provider="youtube" %}

Even this one?!

{% include video id="3yDdr8bFiz0" provider="youtube" %}

## Epilogue

I hope you liked the demos as much as I am; it took some time to optimize and
piece everything together. If you like to try it out for yourself, you can find
the renderer [here on GitHub](https://github.com/ghaiklor/terminal-canvas).

For questions, ideas to improve the project or just share something that you
build with this library, contact [me on Twitter](https://twitter.com/ghaiklor)!
Thanks for reading!

---

_Eugene Obrezkov, Software Engineer at Wix.com, Kyiv, Ukraine._
