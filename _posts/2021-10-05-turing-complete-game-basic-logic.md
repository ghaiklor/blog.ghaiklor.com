---
title: 'Turing Complete Game: Basic Logic'
excerpt: >-
  How to pass the levels from Turing Complete Game: Basic Logic? If you are
  looking for it, this is the place where you can find ones!
categories:
  - Explained
tags:
  - Turing
  - Complete
  - Game
  - Walkthrough
  - Basic
  - Logic
header:
  overlay_image: assets/uploads/2021-10-05/wiring.jpg
  overlay_filter: 0.5
  caption: Photo by Adi Goldstein on Unsplash
  teaser: assets/uploads/2021-10-05/wiring.jpg
---

I’ve discovered an interesting game recently, called [Turing Complete](https://store.steampowered.com/app/1444480/Turing_Complete/).
The goal of the game is to create a working computer from the ground up, starting from the NAND gate.
Going further and further, we end up with our own assembler for our own CPU we made during the game.

I think it is a great way to learn the basics of how computers actually work.
It is not just about knowing the wiring, but also actually seeing how all these wires end up and work.
That’s why I thought, why not to write up the play through for this game?
Decided!

Actually, it has more in common with another course than I had a year ago or so.
You can read more about it in [this blog post]({% post_url 2019-10-31-from-nand-gate-to-pong-game %}).
{: .notice--info }

## Crude Awakening

The game starts with the intro, where an alien is telling us we were abducted!
And the only way to be a survivor is to create a computer.
Right after that, the level just tells us a little about `IN` and `OUT` and that we can manipulate it by using buttons on the left sidebar.
Nothing more in particular and after that, we can navigate to the next level.

{% include figure image_path="assets/uploads/2021-10-05/crude-awakening.png" alt="Crude Awakening" caption="Crude Awakening" %}

## NAND Gate

At this level, we need to get familiar with the [NAND Gate](https://en.wikipedia.org/wiki/NAND_gate) and how it works.
Make a long story short, NAND gate is a negation of AND operator.

AND operator is an operator from [boolean algebra](https://en.wikipedia.org/wiki/Boolean_algebra) that returns TRUE only when both operands are TRUE.
In all other cases, it will be FALSE.

- 0 AND 0 = 0
- 0 AND 1 = 0
- 1 AND 0 = 0
- 1 AND 1 = 1

Knowing about AND operator, we can easily conclude how the NAND gate works.
It just negates the result of the AND operator (NOT AND).
So we need to answer with a truth table above, but inverted.

{% include figure image_path="assets/uploads/2021-10-05/nand-gate.png" alt="NAND Gate" caption="NAND Gate" %}

## NOT Gate

The operator NOT from the boolean algebra negates the operand.
So the TRUE becomes FALSE and otherwise.
How do we build the NOT gate if we have only the NAND gate at this point?

Let think about it this way.
In case you are having both operands for NAND gate TRUE, then it will be FALSE.
1 AND 1 gives us 1 but afterwards it negates.
The same is happening with the operand FALSE.

So what we need to do is to pass the input to both inputs of NAND gate.
Easy!

{% include figure image_path="assets/uploads/2021-10-05/not-gate.png" alt="NOT Gate" caption="NOT Gate" %}

## AND Gate

Implementing this gate is really easy when you have a negator and the NAND gate.
Think about it as if we need to revert to what we have done with the NAND gate before.

So we apply the NAND gate, getting the AND operator but with the negated result.
Afterwards, we negate it once more time to get the result of AND operator, discarding the NOT from NAND gate.

{% include figure image_path="assets/uploads/2021-10-05/and-gate.png" alt="AND Gate" caption="AND Gate" %}

## OR Gate

The operator OR from the boolean algebra returns TRUE if some operands are TRUE.
The only case when the result is FALSE is only when both operands are FALSE.
Let us look at the truth table:

- 0 OR 0 = 0
- 0 OR 1 = 1
- 1 OR 0 = 1
- 1 OR 1 = 1

The only gates we have at this point are NAND gate and negator.
Not even a clue about having some OR gate, NOR gate or something.
Looks like a problem, but no.

If you inspect the truth table of NAND gate, you will see a similarity.
The only case when NAND gate is FALSE is when both operands to it are TRUE.
While, with the OR gate, the only case when it is FALSE is when both operands are FALSE.

Meaning, that we can use the NAND gate to implement the OR gate.
All we need to do is to negate the inputs.

{% include figure image_path="assets/uploads/2021-10-05/or-gate.png" alt="OR Gate" caption="OR Gate" %}

## NOR Gate

We already know how to implement the OR gate by using the NAND gate and a few negators.
Let us do all the same to implement the OR gate.

The only difference is that we need to negate the result of the OR gate to implement NOR, easy!

{% include figure image_path="assets/uploads/2021-10-05/nor-gate.png" alt="NOR Gate" caption="NOR Gate" %}

## Always On

It is a really useful gate, but it looks like it is useless at this point.
You will see the benefit of it later in the game.

This gate always emits the signal no matter the input.
In case we have a signal, we need to return TRUE, in case we don’t - still return TRUE.

Let us start with having a single negator when the input is FALSE.
In such a case we will get the TRUE and the truth table is satisfied.

But if the input is already TRUE, we can just pass it directly to the output, right?
Not really.
In such a scenario, we will get a circular dependency, which is no good.
But we can overcome it by passing the signal not directly to output but through our gates.

For this purpose, let us make a double negator to get the original input as it is.

It is not really an optimized solution, but this is the game.
Who cares, right?
Leave in the comments the solution that is much better, please.
{: .notice--info }

{% include figure image_path="assets/uploads/2021-10-05/always-on.png" alt="Always ON" caption="Always ON" %}

## Second Tick

Honestly, I don’t know what is the purpose of this gate.
Maybe this level is created to get ourselves familiar with something (although, I don’t know what exactly).

Anyway, we need to satisfy the truth table where the TRUE will be only when the first input is TRUE and the second one is FALSE.
All other cases are FALSE.

Meaning, the negated second operator and the AND operator can be used to satisfy the table.
It will return TRUE only and only when the first operator is TRUE and the second one is FALSE.

{% include figure image_path="assets/uploads/2021-10-05/second-tick.png" alt="Second Tick" caption="Second Tick" %}

## XOR Gate

This one can be cumbersome sometimes and hard to follow.
The XOR gate makes the eXclusive OR.
When both operands are FALSE, the result is FALSE.
But when both operands are TRUE, the result is still FALSE.
It makes the TRUE only when some operands are TRUE.

- 0 XOR 0 = 0
- 0 XOR 1 = 1
- 1 XOR 0 = 1
- 1 XOR 1 = 0

Honestly, I didn’t come up with the solution myself.
I don’t remember the logical story behind creating the XOR gate, so I gave up at some point.
In the end, I’ve used [the implementation from the Wikipedia](https://en.wikipedia.org/wiki/XOR_gate) and created the XOR gate by using 4 NAND gates.

If you know how to create the gate (I mean the logical process), please leave it in the comments and I’ll update the solution with your reference.
{: .notice--info }

{% include figure image_path="assets/uploads/2021-10-05/xor-gate.png" alt="XOR Gate" caption="XOR Gate" %}

## Bigger AND Gate

You already know how to create the AND gate from the NAND gate.
But here, you need to create the gate that works with the 3-bit input.

Luckily, we can use the AND gate we made before!
Take the two inputs and pass them to the AND gate, getting the result for two bits.
Afterwards, take its result and pass it as the first operand to the next AND operator in the chain, along with the third input.

Building such a chain will become a common thing in short, so take yourself familiar with its concept.
You can build arrays of gates, passing the result from the previous ones to the next ones.

{% include figure image_path="assets/uploads/2021-10-05/bigger-and-gate.png" alt="Bigger AND Gate" caption="Bigger AND Gate" %}

## Bigger OR Gate

Pretty much the same as with “Bigger AND Gate”.
But instead of using the AND operator, we build up the chain of OR operators.

{% include figure image_path="assets/uploads/2021-10-05/bigger-or-gate.png" alt="Bigger OR Gate" caption="Bigger OR Gate" %}

## Summary

That’s all we need to pass the levels in the game from “Basic Logic” category.
Further in the game we will use these gates a lot, but for now I’ll call it a day!
