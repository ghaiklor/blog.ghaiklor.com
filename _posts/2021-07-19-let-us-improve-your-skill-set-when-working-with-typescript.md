---
title: Let us improve your skill set when working with TypeScript!
excerpt: >-
  TypeScript is flexible enough to allow skipping compiler errors. You even can
  write JavaScript and still compile the code with no errors. But, what if
  developers would know how to solve those?
categories:
  - Thoughts
tags:
  - node.js
  - typescript
  - skills
  - knowledge
header:
  overlay_image: assets/uploads/2021-07-19/skill.jpg
  overlay_filter: 0.5
  caption: Photo by Yohan Cho on Unsplash
  teaser: assets/uploads/2021-07-19/skill.jpg
---

Just to be clear, I’m not advocating TypeScript. I’m not trying to convince
everybody that TypeScript is top-notch language everyone should use. I know
about its weak points and design decisions.

All I’m saying is that it is the brave new world we are living in right now,
where TypeScript is one of the most used languages in our job. Since we work
with TypeScript, no matter the wish, it is great to improve your skill set in
it.

Each time someone sets `@ts-ignore` directive, sets `any` type or worse, have
them implicitly, this “someone” ignores the type system. One of the reasoning is
“I don’t like the TypeScript”, but it does not sound like an argument for me.

So that, since we already work with TypeScript, let us get ourselves familiar
with what TypeScript can do, instead of ignoring it and worsening your
colleagues’ lives who cares about it and the code they write!

## What problem do I see nowadays

I already made a TL;DR version above, but now I can add more details to what I
mean.

Most developers I work or talk with currently have a false feeling that
TypeScript is not expressive enough in the type system. They used to think that
TypeScript is all about “here is a string, there is a number and some object
with known fields” and that’s it. But I strongly disagree with them!

TypeScript has
[generics](https://www.typescriptlang.org/docs/handbook/2/generics.html),
[strict mode for enforcing program correctness](https://www.typescriptlang.org/docs/handbook/2/basic-types.html#strictness),
[union and intersection types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types),
[literal types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#literal-types),
[type narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html),
[conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
and
[a lot more](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html).

Sure, there is a truth in their words when we compare TypeScript type system
with, e.g., Haskell type system. But, do not forget, we are talking about the
language which target is JavaScript! How do you even compare those?

We got off the track, let’s get back to it. So what is the problem in my humble
opinion? Personally, I think that the most issues coming from TypeScript code
goes from the fact that most TypeScript developers don’t know how to express
“something” in type system.

They try to write the safe code and then they get the compiler error which says
something terrible happened. Especially, knowing the TypeScript has the worst
error reporting and it is not user friendly, it's not helping. Not knowing what
to do, they have no choices than to leave a `@ts-ignore` or `any` and hope that
someone else would come up and fix it.

Most of the time, it’s not, no one will come. And the code like this continues
to grow until there is no difference between TypeScript and JavaScript, roughly
saying.

## How does it reflect those who write the code in strict mode

I’ve already talked about it before, but I’ll make a short thesis here once
again. The entire infrastructure around TypeScript is not in a strict mode by
default. You have no program correctness checks, no policies from the compiler
to enforce “type coverage”. You can write code, not knowing that all the code
you have is implicitly typed as `any` type.

In case you don’t know how to set up the “strict” mode I’m referring to, [I
talked about it
here]({% post_url 2021-02-26-how-to-setup-typescript-projects-in-2021 %}). {:
.notice--info }

That’s the reason most of the code I see is just a JavaScript code with type
hints and no policies. People just write JavaScript, sometimes leaving type
hints and TypeScript strips the type when compiling - that’s it - nothing
useful.

You write JavaScript, not TypeScript. The fact you use TypeScript compiler does
not mean you write TypeScript code.

Don’t get me wrong, I’m not saying that you [reader] has this setup. I’m saying
that there is a chance, that you have a default setup that enforces nothing. So
that, you write JavaScript code, actually. {: .notice--info }

The ones who work in such a setup (the one that is default and out of the box)
get used to it pretty fast. Of course, by default, TypeScript asks nothing from
you, so you continue writing JavaScript, thinking you write TypeScript.

But, I’ll tell you what. There are teams that spent some time and investigated
how TypeScript and ESLint can be tuned to enforce program correctness checks.
These teams have strict mode set up on their projects and once they get a
developer who previously worked in a non-strict mode - boom! Turns out, the
developer knows nothing about TypeScript and its type system. The whole life is
a lie!

Having a developer that got used to the non-strict mode is tough. In the
worst-case scenarios, you get a developer that does not understand why is it
everything so strict, does not see any sense in it and involves himself in a
conflict with the team. I’ll not be talking about how much conflicts cost,
that’s another topic.

Pretty soon, the developer understands that the compiler errors he sees can (and
must) be fixed somehow, but how? Well, by learning the type system!

## You can change it

The good point here is that you can change it! The TypeScript type system is not
so expressive and hard to understand comparing with Haskell type system. Or,
comparing with Rust, you don’t need to understand the ownership memory model to
write types in TypeScript.

TypeScript type system is a good balanced type system. It is flexible enough to
skip some type errors and leave it for later until you figure out how to fix it.
On the other hand, it can provide an adequate program correctness checks (it’s
not Rust, sorry, but that’s the cost of flexibility).

I would say that TypeScript is a good entry point to learn type systems. But, be
aware, each language has different type systems and you need to adapt to each
one of them.

Anyway, where from should you begin if you are interested in improving your
skill set?

### TypeScript Handbook

TypeScript team
[has its own handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
where all the required knowledge about type system stored. You can find there a
lot of information on generics, how do they work, how implicit inferring works
and so on and so forth.

Moreover, TypeScript team published its second revision recently with a lot of
info structured in a more intuitive way. So before talking about improving our
skill sets, you must read the handbook from A to Z, no excuses.

### Type Challenges

Once you get yourself familiar with what TypeScript can do, you need to test it
somewhere. Unfortunately, not everyone has projects where all this knowledge can
be applied. Some projects are too easy from technical perspective so that their
glass ceiling is using generic types and sometimes inferring. In such case, you
can refer to
[Type Challenges](https://github.com/type-challenges/type-challenges)!

Type Challenges is a project where many many challenges aggregated in one
repository. The key point in these challenges is that to solve them you need to
write the code in a type system. No runtime, no tests, just types! These types
must solve the challenge starting from picking the property from literal type to
implementing a parser for JSON on type level.

Every challenge from there is beautiful on its own. But, what to do if you tried
to solve it and couldn’t?

### Solutions for Type Challenges

When talking about challenges, there are two categories of solutions: bare
minimum or pretty explained.

Bare minimum provides a code you need to get stuff working with no explanation
at all. So, in case you couldn’t solve a challenge yourself, you can find a
quick solution and pass it. But, there is a chance that you will not understand
what is going on with the solution. Yes, you get the solution working, but you
don’t understand why.

That’s when pretty explained solutions are coming into the game. These
explanations do not just share the solution you need. They also provide a
step-by-step explanation. How did we come up with the code? Why using this
technique and not the other? Where can I read more about it? And many more
questions like these.

If you are a fan of such explanations and challenges, you can go to
[Type Challenges Solutions project](https://ghaiklor.github.io/type-challenges-solutions)
and find pretty explained solutions for Type Challenges there.

## Epilogue

What I was trying to say with all this stuff written above? Well, I built the
plan of this post around the idea that people usually do “not great” things not
because they are want to do them, but because they don’t know how to do better.

I projected this idea to the
[TypeScript and its type system](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html).
And I thought, many TypeScript developers write “not great” code not because
this is their deliberate choice, but because they don’t know how to express what
they want.

So that, I told you about
[TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html),
[Type Challenges project](https://github.com/type-challenges/type-challenges)
where you can experiment with the challenges. Also, told you about the project
that provides
[pretty explained solutions for those challenges](https://ghaiklor.github.io/type-challenges-solutions).

I really believe that having all these amazing projects we can improve our skill
sets when writing TypeScript code!

---

_Eugene Obrezkov, Software Engineer at Wix.com, Kyiv, Ukraine._
