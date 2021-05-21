---
title: How to implement a second stage boot loader?
excerpt: >-
  Simple boot loaders are limited to 512 bytes of code. When implementing a
  bootloader that does a lot, it is a problem. So, how bootloader developers
  overcome this limitation?
categories:
  - How-To
tags:
  - assembly
  - c
  - c++
  - boot
  - loader
  - bios
header:
  overlay_image: assets/uploads/2017-11-02/stay-on-the-path.jpg
  overlay_filter: 0.5
  caption: Photo by Mark Duffel on Unsplash
  teaser: assets/uploads/2017-11-02/stay-on-the-path.jpg
---

Last time, we created a working boot sector, the BIOS can find with the help of magic numbers.
You can read more about it [here]({% post_url 2017-10-21-how-to-implement-your-own-hello-world-boot-loader %}).

The question here is “**Why do we need a second stage boot loader?**”.
We can implement all of it in the boot sector, using Assembly, so… why?

The problem is… **size limits**.
You can’t store over 512 bytes of code in the boot sector, so if you want to make a super-duper boot loader _(like GRUB or similar)_ you need to store all of it somewhere else, but not in the boot sector itself.

And that is one of reasons, we need to have a second stage boot loader.

## Refresh your memory

Based on the previous article, we got a simple boot program that prints “Hello, World!” to the output.
Let me show this again:

{% gist 89e243a3463569480d01188c9e55e077 %}

Now, we need to improve this program to resolve the second stage boot loader.
Let the journey begin!

*We will not discuss switching to 32 or 64 bit modes here for the sake of simplicity.
All we do here is just printing a message, but from second stage boot loader.*

## Preparing the environment

This time, I will implement all of it on Linux Mint.

The reason for that is that it’s too hard to compile sources from one host to another target, in my case, the host is _OSX_ and the target is _i386_.
For that, we would need to build _gcc_ on our own with a lot of custom flags.
It’ll be much simple to just work on a Linux machine.

Let’s start by making sure that our system is upgraded, has a _build-essential_ package, _qemu_ and _nasm_.

```shell
sudo apt-get upgrade
sudo apt-get install build-essential
sudo apt-get install nasm
sudo apt-get install qemu
```

As a result, we will write the first stage via assembly and compile it with a _nasm_ compiler.
The second stage will be written in C language and built with the help of all packages that _build-essentials_ comprises.
When we finish with all the parts, we will test our boot loader via _qemu_ emulator.

## The Concept

Let’s begin with a conceptual overview of how to combine primary boot loader code written in Assembly language with the code of secondary boot loader written in C language.

What comes to mind in the first place?
You can implement an Assembly program, that fits into our 512 bytes and will be able to call some external program at specified offset _(this external program can be stored anywhere you want)_.

And that is the edge where second stage boot loader begins: **everything that happens in the boot sector of the drive is the first stage. All that happens outside of it is the second stage**.

Therefore, we **must achieve the following goals**:

- Procedure that can read from disk, but in first stage. It will try to read our secondary boot loader and load it into the memory.
- Procedure that tries to call our secondary boot loader _(which is loaded into memory by step above)_ and transfers an execution to it.
- Secondary boot loader itself that prints a message, implemented in C language. This will be our minimal boot loader with one function. Let’s call it **_loader_main()_**;

I hope these steps are clear enough, and we can start with implementing those.

## Read from drive via Assembly

Our first step is to have an ability to read some data from drive and load it into the memory.
BIOS has the required interruption, so we can use it for reading specified offset from the drive.
Its interruption code is [INT 13,2 — Read Disk Sectors](http://stanislavs.org/helppc/int_13-2.html).

We can implement the whole procedure in the following way:

{% gist 29cae866e24c205af2f559dc29a17434 %}

There are two procedures: `disk_read` and `disk_read_error`.
Based on documentation of INT 13,2, we need to store the address of memory, where we want to store the read result, in `bx` register.
We will specify it as an argument before calling `disk_read` procedure in our routine.
In case something went wrong, `disk_read_error` procedure is called.

We will use it for reading our second stage boot loader binaries and load them into memory by our specified `bx` register.

*It’s worth mentioning that we are reading from a specified position (cylinder=0, head=0, sector=2, sectors to read=dh register).
That means that we have to store our second stage boot loader at this location on the drive.*

## Call the loaded binaries via Assembly

The next step after reading from drive is to pass execution to a specific address in memory where our secondary loader will exist.
But how to decide, what the address should be?
Well, again, for the sake of simplicity, let’s just use a constant value `0x1000`.
This will be the address where secondary loader will be stored.

Since we already know the location of the second stage in memory, it’s easy to do, just make a call for a specific address in memory:

```assembly
call OUR_SECOND_STAGE_OFFSET
jmp $
```

At this step, we will read binaries from the drive, using `disk_read` procedure, and load them into memory by our known address and call it:

```assembly
OFFSET equ 0x1000 ; where to store boot loader binaries
mov bx, OFFSET    ; set address to bx
call disk_read    ; read our binaries and store by offset above
call OFFSET       ; give execution to our loaded binaries
jmp $
```

We have implemented the ability to load our second stage boot loader code into memory and call it, but we don’t have a secondary boot loader itself.
So let’s start with writing our **_loader_main()_** in C language.

## “Hello, World!” in C language

Since we are not working with protected mode (32-bit architecture) but with 16-bit architecture, we can’t rely on simple “Hello, World!” and `printf` here.
Also, that is because `gcc` doesn’t have `libc` stubs for 16-bit architecture.
So, for the sake of simplicity, let us print alphabet instead, using Assembly interruptions:

{% gist f976d731c50db2f39d263f3e65756500 %}

What is going on here?
`0x41` is a hex value of the letter “A” and we are iterating it through right to the last letter “Z”.
We wrote each of these letters into output by emitting a BIOS interrupt for each letter.
So, as a result, we will get a _“ABCDEFGHIJKLMNOPQSTUVWXYZ”_ string.

But that’s not enough.
We need to make an entry point in Assembly for our second stage, so linker can link all object files and make sure that everything is tied properly.

We know, that our entry point in C language is a function called `loader_main()`.
So, we are declaring it as an extern function and calling it from our entry point in Assembly:

```assembly
global _start
[bits 16]
[extern loader_main]

_start:
  call loader_main
  jmp $
```

The next step is wrapping all these things together.

## Compiling Assembly and C into binary files

Let’s compile our first stage boot sector:

```shell
nasm boot.asm -f bin -o boot.bin
```

**That’s it for our first stage**.
We have raw binary format here.
Now, for the interesting part — second stage.

We need to make an `elf` object file from our Assembly entry and our C file.
Afterwards, we need to link them:

```shell
nasm loader.asm -f elf32 -o loader_entry.o
gcc -O0 -g -ffreestanding -m32 -c loader.c -o loader.o
ld -o loader.bin -m elf_i386 -Ttext 0x1000 loader_entry.o loader.o --oformat binary
```

Using _nasm_, we are compiling our entry file to elf object.
The same with our C file.
But, when we are linking these object files together, we need to specify an offset `0x1000` by `-Ttext` option, since we are loading it in our first stage exactly by this address.

You will get a raw binary file which is called `loader.bin` in your directory.
**That is your second stage boot loader**.

Now, behold the magic of concatenating your stages into one binary image and run it on your QEMU emulator:

```shell
cat boot.bin loader.bin > image.bin
qemu-system-i386 -fda image.bin
```

You will see the result of our hard work:

{% include figure image_path="assets/uploads/2017-11-02/demo.png" alt="Boot Loader" caption="Second Stage Bootloader" %}

As you can see, we could call our second stage boot loader from the primary one.
They were totally separated and build process for the second one is different.
Using this approach, you can implement anything you want with C language, compile and link it with an entry and get binary file, that will be loaded by the first stage boot loader.

Goal achieved!

## Bonus

I made a script you can use on your Linux machine (Ubuntu-based) if you want to scaffold it in a matter of time and play around:

```shell
curl https://gist.githubusercontent.com/ghaiklor/c9b4cfa9111c87e5e12df16f337a338e/raw/3eb1b84fb7a58a47ef6f690de56ebb1b6b5e8c20/build.sh | bash
```

## Thanks

I hope this article was a great read for you.
Leave your feedback in the comments, share it with your geek-friends and clap.

If you want to investigate further, check the [sources of my simple OS](https://github.com/ghaiklor/ghaiklor-os-gcc).

---

*Eugene Obrezkov, Senior Software Engineer at [elastic.io](http://elastic.io), Kyiv, Ukraine*
