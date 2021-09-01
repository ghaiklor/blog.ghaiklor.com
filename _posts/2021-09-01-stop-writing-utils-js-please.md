---
title: 'Stop writing utils.js, please!'
excerpt: >-
  The concept of having some abstract file that has any functions you need and
  don’t need, became a meme in my environment. Everyone argues if having such
  files is a good pattern or not. So that, I wrote up my opinion on the topic
  with some arguments, why it is bad.
categories:
  - Thoughts
tags:
  - Software
  - Design
  - Bad Code
header:
  overlay_image: assets/uploads/2021-09-01/trash.jpg
  overlay_filter: 0.5
  caption: Photo by Kinga Kołodziejska on Unsplash
  teaser: assets/uploads/2021-09-01/trash.jpg
---

Every time we write code, we solve some specific problem.
No matter what the problem is.
Ranging from filtering out some items by a predicate in two lines of code or trying to solve the [“Collatz conjecture”](https://en.wikipedia.org/wiki/Collatz_conjecture).

Every time we catch ourselves on the questions like:

- “does someone else need it?”
- “I’m a good guy, so I’ll just make it available to others, right?”
- “I have another place in the code where I’m using the same, I’ll move to utilities then!”
- and so on and so forth

Sometimes, the answer to these questions pretty simple - let’s make `src/utils.js`!

```javascript
// src/utils.js
```

## Filling the Void

Let’s imagine, developer David is working on the task to get some data from DB and apply a filter to it.
He’s working hard to get things done, but during the work he moved some “helpful” predicates to utilities file.
One predicate is to find only positive numbers in the data and another one is to find negative.

I’m omitting the implementation itself.
We are talking about concepts only and imaginary examples that have some similarities in one way or another.
{: .notice--info }

```javascript
// src/utils.js

export const isPositiveNumber = (number) => true
export const isNegativeNumber = (number) => true
```

So far, so good.
Pretty explanatory, no issues with that.

But, let’s imagine that later on, developer Sarah made a helper function for prefixing the log messages with the time.

```javascript
// src/utils.js

export const isPositiveNumber = (number) => true
export const isNegativeNumber = (number) => true
export const logMessageWithTime = (message) => `[TIME]: ${message}`
```

While developer Charles tired of opening a connection to the database in each service and thought “someone else need it!”.

```javascript
// src/utils.js

export const isPositiveNumber = (number) => true
export const isNegativeNumber = (number) => true
export const logMessageWithTime = (message) => `[TIME]: ${message}`
export const connectToDatabase = (credentials) => db.connect(credentials)
```

At this moment, our utilities file already knows about the logger, the database and some predicates.
All of them have nothing in common, so why they should be in the utilities file?

That is the place where I’ll point to the pretty known term.
So known that for some of you it will be a cliche.

## Low Cohesion

When we are referring to [“low cohesion”](https://en.wikipedia.org/wiki/Cohesion_(computer_science)) as a term, it means that the traits of a component badly structured.
The component does pretty much in different domains.
In our case, it is a logger, database and predicates.

Let us make a peek into Wikipedia:

> Cohesion is an ordinal type of measurement and is usually described as “high cohesion” or “low cohesion”.
> Modules with high cohesion tend to be preferable, because high cohesion is associated with several desirable traits of software including robustness, reliability, reusability, and understandability.
> In contrast, low cohesion is associated with undesirable traits such as being difficult to maintain, test, reuse, or even understand.

Having a component with low cohesion means that the outcome of the component is not easily understandable.
You can’t say what the utilities file can do or have unless you peek into it and go through the code there.

You could make two separate components for the logger and database, though.
The component for logger would have the utility function, like prefixing, there.
While the component for database would have the utility function for connection there.
In such case, cohesion becomes much better.

Why?
Because they are co-located in similar domains and it is much easier to look for “something that works with the logger” in the logger component, not the separate utility file.

You may say “OK, but we still have predicates there!” and you’ll be right.
Those predicates are, kind of, miscellaneous and can’t be assigned to a specific domain.

Although, if it becomes a tremendous problem for you, you would just create another domain for number manipulation and moved those predicates there.
{: .notice--info }

In our case, there is no sense in creating another domain just for those two functions.
So I say “move those into your domain that you are solving right now as a private function”.

## DRY

“We are repeating ourselves! Someone else would need it later!” - you may say.
“Why do we need to copy and paste these useful predicates in different domains?” - another may ask.
I totally agree with you about it.
It would be great to write code only once, but, unfortunately, that’s not how things work (if you want to keep things simpler, of course).

There is a thin border between having benefits from the DRY ([Don’t Repeat Yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)) or having more damage than benefit.
It is so contextual that only you can decide for yourself where is the damage or benefit from it.

Talking about predicates, I would prefer them [duplicated in different domains where they’ve been used](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself#AHA).
Why?
Because they are easy to implement and they don’t worsen the cohesion.

Having better cohesion for a more clear design has more benefits than having code de-duplication.
Your team can manage the threshold for the code duplication by using tools or just decide it verbally and enforcing its threshold on code reviews.

Don’t take DRY principle as a rule everybody should follow.
If you see that some utility function is easier to implement again than looking through some utilities, then just make it as part of your domain solution.
Make a code duplication.
In the long run, the overall design will be easier to grasp.

Please note that threshold between having code duplication and making a new (shareable) domain depends.
At some point, code duplication becomes a problem and you need to move it into its own generic solution.
{: .notice--info }

## Summary

If you are reading this paragraph, congratulations.
You have fewer triggers than other people.
What I wanted to say with all this?

Having generic utility files that have functions for all the components really makes cohesion bad.
Having low cohesion results into more complex design, higher coupling between components and maintenance hell.

By introducing a managed code duplication in your project, you can drastically improve cohesion and make your project more maintainable and understandable by your colleagues (new ones or old ones).

So, please, stop writing `utils.js`, `constants.js`, `helpers.js`, etc. in your projects.
Unless it is clear what is the domain for them and they are grouped by meaning.

---

*Eugene Obrezkov, Software Engineer @ Wix, Kyiv, Ukraine.*
