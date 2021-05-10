---
title: Advent of Code 2015 — Explanation
excerpt: >-
  I bet you heard about Advent of Code. It is a series of minor challenges you
  need to solve (for fun). Here, I’m providing solutions to Advent of Code 2015
  with explanations.
categories:
  - Explained
tags:
  - node.js
  - javascript
  - advent
  - code
header:
  overlay_image: assets/uploads/2016-02-15/advent.jpg
  overlay_filter: 0.5
  caption: Photo by Elena Mozhvilo on Unsplash
  teaser: assets/uploads/2016-02-15/advent.jpg
---

Happy New Year!
I’ve finished [Advent of Code](http://adventofcode.com) and want to share my solutions with you.
Of course, some solutions can be improved; I don’t claim these to be the best solutions possible.

When I started playing this game, I decided to write one paragraph with a solution and explanation to it.
But you can see that I went a little further with that…

_TL;DR:_ This isn’t really an article, more like a collection of gists with explanations.
All of the solutions are available on my [GitHub](https://github.com/ghaiklor/advent-of-code-2015) if you just want the code.

## Day 1 — Part 1 (Not Quite Lisp)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-01/part-1)

This one’s easy.
We just split the input to separate chars, getting the array.
Afterwards, iterating over that array via _reduce_, we can calculate current floor and store it in accumulator.

The value from the accumulator will be our result.

{% gist d1b10d5a51351f735930 %}

## Day 1 — Part 2 (Not Quite Lisp)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-01/part-2)

We need to find the position of the character that causes Santa to first enter the basement.

Quick solution is a mutable variable _floor_, which determines the current floor Santa is on.
Split input to separate chars and _map_ through it, replacing the char with the current floor.
That way we get the array with floors, where Santa was.

Afterwards, looking for *-1* floor and getting its index will be our result.

{% gist 24fe52c1de96b7b6d894 %}

## Day 2 — Part 1 (I Was Told There Would Be No Math)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-02/part-1)

Simple math.
All formulas are provided in the problem definition.
We need to find out total square feet of wrapping paper.

Split the input by NL and iterate the resulting array via _reduce_.
On each iteration, we get string with sizes divided by _x_, so we split the sizes by _x_ character and get _length_, _width,_ and _height_.
Calculate result by formula and sum up with our accumulator.

The answer to this problem will be a value from that accumulator.

{% gist d3fd4578cdeedc54136c %}

## Day 2 — Part 2 (I Was Told There Would Be No Math)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-02/part-2)

The same applies here, just with different formulas.
We split the input by the NL character and started reducing the resulting array.
On each iteration, we need to split one line from input by _x_ character and sort that array because:

> The ribbon required to wrap a present is the shortest distance around its sides, or the smallest perimeter of any one face.

We have the sorted array and calculating the smallest perimeter is not a big problem.
All what we need to do is get the smallest sides, calculating the result and sum up with accumulator.

The answer to this problem is a value from the accumulator.

{% gist 5631e1b37b5d7d557450 %}

## Day 3 — Part 1 (Perfectly Spherical Houses in a Vacuum)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-03/part-1)

We need to find out the number of houses that received at least one present.
It can be easily achieved by using a unique _set_ and getting its size after calculating.

Split the input by empty char so we get the array with directions where Santa should be at the next step.
When we iterating through that array via _reduce_, accumulator is our current coordinates.
Based on direction, we calculate new coordinates, add to the _set_ and return, so on the next iteration we have current coordinates.

The size of our unique _set_ will be our houses count that receives at least one present.

{% gist 9457db7e96d985739006 %}

## Day 3 — Part 2 (Perfectly Spherical Houses in a Vacuum)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-03/part-2)

We got a robot now that helps us to send presents.
The logic of traversing the path is the same — get all visited coordinates and push them to _Set_.
With only one difference…
We need to split Santa’s directions and RoboSanta’s directions.

Take input and split it by empty char.
That’s way we get all the directions that we can filter out with even and non-even items, which are Santa’s and Robot’s directions.

_The traverse_ function does the same as the code from part 1 — it takes directions and pushes all the visited coordinates to array.

Now, all that’s left to do is get visited coordinates for Santa and Robot and concatenate them into unique _Set_.

The size of this _set_ will be our result.

{% gist 1a0b24f8c81f34939981 %}

## Day 4 — Part 1 (The Ideal Stocking Stuffer)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-04/part-1)

Increment the counter until our md5 hash starts with five zeros.

The first number that produces the required hash is saved in _counter_ and is the result.

{% gist 703d027245e678982678 %}

## Day 4 — Part 2 (The Ideal Stocking Stuffer)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-04/part-2)

Same as in the previous part, but hash must start with six zeros instead of five.

{% gist c1ce2792f76e596f6055 %}

## Day 5 — Part 1 (Doesn’t He Have Intern-Elves For This?)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-05/part-1)

We need to find out strings that correspond to defined rules in problem definition.
Our rules can be implemented as separate functions that accept string and check it against the rule.

Iterate input via _reduce_ and if string is nice, increment the accumulator.
In result, we get total count of nice strings, which is our answer.

{% gist 0ef327b1fb95383f09f9 %}

## Day 5 — Part 2 (Doesn’t He Have Intern-Elves For This?)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-05/part-2)

Pretty much the same as the last part, but let’s rewrite our rule functions to regular expressions.

Iterate input via reduce and increment accumulator if string is nice.
Accumulator value is the result.

{% gist 6a607d0bbd1df5c811b4 %}

## Day 6 — Part 1 (Probably a Fire Hazard)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-06/part-1)

We have a list of commands that say which lights we need to switch.
First step is to write regular expression that will parse that command and return object with parsed data.

Also we need to have an array of our lights where we can store current state — _Uint8Array_ which is filled by zeros.

For each instruction from Santa, we parse it via regular expression and start switching the lights in defined region by setting 1 or 0 in _LIGHTS_ array.

When all instructions are executed, iterate the _LIGHTS_ array via _reduce_ and sum up all the enabled lights to the accumulator.

Answer to this problem is the accumulator value.

{% gist 7654f877419d8b198a6a %}

## Day 6 — Part 2 (Probably a Fire Hazard)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-06/part-2)

We found out that our _LIGHTS_ array should store brightness of each light instead of the state of light (on-off).

Nothing really changes here except for writing to the _LIGHTS_ array.
We will increment/decrement values instead of writing 1.

When each of instructions are executed, we can calculate total brightness via _reduce_ and accumulator.
Answer is in accumulator.

{% gist da5e554b1e12551f526c %}

## Day 7 — Part 1 (Some Assembly Required)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-07/part-1)

Our input contains a list of wires and their values/instructions.
We need to split this problem into separate steps:

- Parse instructions from input via regular expression;
- Fill a Map with parsed wires as keys and instructions as values;
- Recursively get values from a Map and if value is an instruction — execute it and return the result;

Let’s start with defining a _Map_ which is called _WIRES_.
We will store wire name as a key and parsed instruction as a value here.

Afterwards implement functions that will be our instructions from input.
I’ve stored them in *BITWISE_METHODS* object.

Parsing is boring, nothing special.
We have few regular expressions that return values from input.
It returns object with _command_, _args_ and _destination_ fields.
_command_ is our bitwise instruction, _args_ are our arguments for instruction and _destination_ is a name of the wire which has this instruction.

We are able to fill our _WIRES_ map with parsed instructions now.
Iterate through _INPUT_, parse the instruction and store the result in our _WIRES_ map.

Afterwards, when we have representation of our wires, we can calculate value of a specific wire.
When we get value from _WIRES_ and it’s a number, we return it.
If it’s not a number but an object with instruction, we call our bitwise methods with arguments from object and store the result in _WIRES_, returning the result.

Step by step, our recursive function _calculateWire_ will return value from a specific wire.

{% gist d2d381c34124421b5b0d %}

## Day 7 — Part 2 (Some Assembly Required)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-07/part-2)

We can use the same algorithm here to calculate the value of a wire.
We just need to set up some initial value as problem definition says:

> Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire a).

I take the result from previous part (which is 956 in my case) and set it implicitly to wire _b_.

{% gist aaa12e6f34d2b86ceee6 %}

## Day 8 — Part 1 (Matchsticks)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-08/part-1)

This one’s interesting.
At first, I wanted to use regular expressions and replace characters to get length of the string.
Afterwards, I thought it can be achieved with simple _eval_ of the string.

Reducing the input by calculating the difference between these two strings, we can find the result.

{% gist 5b5c0c3cab15b979d0d9 %}

## Day 8 — Part 2 (Matchsticks)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-08/part-2)

Same as the previous part, only in different order.
We need to encode the string without evaluation.
Two simple regular expressions and sum up with accumulator will be our result.

{% gist a34c44ca93c4c5cca6e8 %}

## Day 9 — Part 1 (All in a Single Night)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-09/part-1)

Simple math again — combinatorics.
When I see problems like finding the shortest distance, I bet, it’s combinatorics (because I don’t know graph theory, my bad).
Here’s how I split this problem:

- We need to build a map of all possible points pairs and distance between them;
- Build an unique set with all the places that we need to visit;
- Permute all possible places, getting all possible routes;
- Iterate through all the permutations and calculate the total distance for each route;

Our result will be a minimal value from the array, where total distances for each of routes are stored.

{% gist d4016f47b8091aab5cc6 %}

## Day 9 — Part 2 (All in a Single Night)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-09/part-2)

Problem definition says:

> The next year, just to show off, Santa decides to take the route with the longest distance instead.

No problem, just replace the _Math.min_ with _Math.max_ to calculate the maximum value of our total distances for each of routes.

{% gist f4f423e5adcb716969b1 %}

## Day 10 — Part 1 (Elves Look, Elves Say)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-10/part-1)

We need to find repeating symbols in the string, get its length and replace these symbols with their length and symbol itself.

It’s easily achieved with regular expression with global flag.
Here, we are reducing all matches of regular expressions, counting their lengths and replacing them with length and symbol.

Our result will be a string after replacing its symbols 40 times.

{% gist 8549a92b6ca6975602aa %}

## Day 10 — Part 2 (Elves Look, Elves Say)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-10/part-2)

Same as previous part, only replace symbols 50 times instead of 40.

{% gist 107355c3df044683704a %}

## Day 11 — Part 1 (Corporate Policy)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-11/part-1)

We need to find out the new password for Santa.
Let’s split the problem into separate steps:

- Implement functions that check string against rules;
- Implement functions for incrementing one char and the whole string;

It’s simple with rules — few functions that check string against regular expression.

_incrementChar_ accepts one character and checks if it’s equal to “z”.
If so, return “a”, otherwise, get ASCII code of this symbol, increment it by one and return symbol of the new ASCII code.

_incrementString_ is a recursive function which accepts a string that needs to be incremented.
We are incrementing the last character in string and if result is “a” then we need to increment character from the left recursively.

Having all these functions we are able to write loop — while our password is not valid — increment the password.

{% gist f1c6206fc5157a1ccd72 %}

## Day 11 — Part 2 (Corporate Policy)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-11/part-2)

We need to find the next password now.
We had a valid password on previous part, so we can take it as an input for this part.

Algorithm remains the same with one difference…
We need to increment our valid password immediately before loop, because our input is already valid.

{% gist 8de652815bf5b5adcfd7 %}

## Day 12 — Part 1 (JSAbacusFramework.io)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-12/part-1)

We had been asked to find out the sum of all numbers in the document.
It can be achieved via parsing JSON, iterating its result via _reduce_ and… wait a minute.

> What is the sum of all numbers in the document?

What if we don’t need to parse the JSON?
Let’s write regular expression which finds all the numbers in the document and sum them up.

{% gist 967e768b00abb2a1680b %}

## Day 12 — Part 2 (JSAbacusFramework.io)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-12/part-2)

A bigger problem now:

> Ignore any object (and all of its children) which has any property with the value “red”. Do this only for objects ({…}), not arrays ([…]).

We definitely need to parse the JSON now.
When parsing JSON we can provide _parse_ method with additional function that accepts key and value from current iteration in parsing process.

We need to check if that value is not an array and contains “red”.
If so — return an empty object (ignoring all the children), otherwise return original value.

That way we can filter out JSON and then apply the same algorithm from the previous part to find out the sum of all numbers in the document.

{% gist 98f640e9a15720cb5c1d %}

## Day 13 — Part 1 (Knights of the Dinner Table)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-13/part-1)

Combinatorics again.
I’m starting to love it.
The problem is hard enough, so let’s break it into smaller pieces:

- Build a map of attributes for each person. This map will contain happiness units for each person in pair with neighbor;
- Build a unique _Set_ of all attendees;
- Build all possible permutations of attendees, getting the all possible seat arrangements;

After these steps, we can iterate through all possible permutations via _reduce_ and calculate total happiness based on our map that we’ve built before.

Answer to this problem will be maximum total happiness that can be achieved by different seating arrangements.

{% gist c20c0c293d30560080cd %}

## Day 13 — Part 2 (Knights of the Dinner Table)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-13/part-2)

Algorithm remains the same except we need to add yourself into attendees list:

> So, add yourself to the list, and give all happiness relationships that involve you a score of 0.

We don’t care with whom we are sitting, it simplifies solution a little bit.

When building person attributes map, add yourself as possible neighbor to that person with value of “0” and to the unique _Set_ of attendees.

You’re ready to calculate new total happiness, based on our changes.

{% gist aefaf367ec0f5830f941 %}

## Day 14 — Part 1 (Reindeer Olympics)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-14/part-1)

We need to find the maximum distance that reindeer can travel.

In this part it can be calculated via formula.
As we know, we have three reindeer attributes: speed, active time and rest time.
Traveled distance can be calculated at any point in time using these values by a simple formula.

Our result will be the maximum value of traveled distances.

{% gist f0daee9db2de8f353444 %}

## Day 14 — Part 2 (Reindeer Olympics)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-14/part-2)

This part is harder than the first one.
We need to know traveled distance by reindeer at each point in time and based on this, calculate points that reindeer achieved.

I wrote a generator that returns reindeer’s distance at each point in time which is called _getReindeerDistanceIterator_.
I’m stacking all traveled distances of each reindeer into the map and writing it into _allTraveledDistances_ map.

What’s left is to iterate through _allTraveledDistances_ and set one point to the winner at the current point in time.

Maximum value of these points will be our result.

{% gist 4d175f388a86729c6aa1 %}

## Day 15 — Part 1 (Science for Hungry People)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-15/part-1)

We know the formula to calculate the score of the cookie.
Our task is to find all scores of all cookies with different ingredients.

I’ve split the problem into separate steps:

- Get a Map with attributes of each ingredient;
- Get a unique Set with all ingredients names;
- Implement a method that accepts ingredients list, their attributes and count of teaspoons of each ingredient. This method returns score of this cookie;

Simple for loop for each of ingredients can generate all possible permutations of how many teaspoons we need to use for cookie.
Calling makeCookie method in that loop and stacking the result into an array can give us all possible scores.

Find out maximum score and it will be our result.

{% gist abea0d9fde293c902ea9 %}

## Day 15 — Part 2 (Science for Hungry People)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-15/part-2)

Calories is the important value now.
We need to do the same — calculate score of each cookie and filter out cookies that don’t equal to 500.

I’ve modified _makeCookie_ method so it returns score of the cookie and its calories in the array.

Other than that, algorithm remains the same.
We are stacking all possible cookies in the array that contains score and calories.
Filtering out that array by cookie’s calories is equal to 500 and finding maximum value is our result.

{% gist 29248b83d9a317183899 %}

## Day 16 — Part 1 (Aunt Sue)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-16/part-1)

We need to find out the number of Sue.
Your input contains the list of all Sues’ things that have been presented to you.
Finding Sue, which has things from our signature will be our result.

Let’s start with defining our signature from problem definition and regular expression that grabs things from your input.

Filtering our input by condition that Sue has exactly all the things from the list we can find the number of Sue and that is our result.

{% gist 041e2df91fad25317bcc %}

## Day 16 — Part 2 (Aunt Sue)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-16/part-2)

We don’t have strict conditions in this part.
Things’ count can be greater or lesser now.

Replace values by functions that accept these values in our signature.
These functions must return true or false, based on new conditions from problem definition.

Filtering our input we should call function from signature, providing the value from the input.

{% gist ba6e6dcd0fd0b28ec7b8 %}

## Day 17 — Part 1 (No Such Thing as Too Much)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-17/part-1)

Your current task says:

> How many different **combinations** of containers can exactly fit all 150 liters of eggnog?

Require _combinatorics_ module and start iterating all possible combinations of defined containers.
If sum of these containers is equal to 150 — increment the counter.

Result to our question is _total_.

{% gist 7f0f719d1d7eb62f529e %}

## Day 17 — Part 2 (No Such Thing as Too Much)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-17/part-2)

Sort the _CONTAINERS_ array in descending order.
Find out that you need at least 4 containers to get 150 liters.

Everything else with no changes.
Iterate through all possible combinations with minimal length of 4 and accumulate total count.

{% gist bbcf27cf1deec34de037 %}

## Day 18 — Part 1 (Like a GIF For Your Yard)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-18/part-1)

When I’d read these lines at first, I’ve thought that this is [Conway’s Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

> The state a light should have next is based on its current state (on or off) plus the number of neighbors that are on.

These conditions are:

- A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
- A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.

It’s definitely [Conway’s Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

I’m not going to explain how to implement Conway’s Game of Life.
You can find plenty of solutions on the internet.

The answer to this problem will be the count of enabled lights after 100 ticks.

{% gist 50aa8cccefc5b203d8b2 %}

## Day 18 — Part 2 (Like a GIF For Your Yard)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-18/part-2)

The same Conway’s Game of Life with fixed corners in your grid because:

> Four lights, one in each corner, are stuck on and can’t be turned off.

I didn’t think a lot and just hard-code state of each corner in _tick()_ method and _constructor()_.

Result is the same — total count of enabled lights.

{% gist 71a95bd74d3a2b39d6fb %}

## Day 19 — Part 1 (Medicine for Rudolph)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-19/part-1)

This is a really tough one.

We have a list of all possible replacements for our molecule in _REPLACEMENTS_ constant.

Our task is to replace one sub-molecule from _MOLECULE_ with another one and add resulting molecule to *ALL_MOLECULES* set so we can count unique molecules after replacement.

Answer to this problem is the size of our unique set of molecules.

{% gist 98ee17f44729e0222185 %}

## Day 19 — Part 2 (Medicine for Rudolph)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-19/part-2)

The process is the same as in previous part but in reverse.

We have a big molecule that we need to collapse to single character _e_.
It must be done via possible replacements provided in our input.

For that, I’ve created _REPLACEMENTS_ map which contains resulting molecule after replacement as a key and molecule that I can replace as a value.
It’s done that way because we need to do replacements in reverse order.

The last move is loop while our molecule is not _e_.
This loop grabs random molecule from our replacements map and replace part of our molecule with random molecule, counting the counter alongside.

Result to this problem is our counter.

{% gist 4e156a6c91594d0119d7 %}

## Day 20 — Part 1 (Infinite Elves and Infinite Houses)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-20/part-1)

We need to find out which houses get at least as many presents as in your input to this problem, in my case — 34,000,000.
A simple task to find maximum value.

As our input has a huge number, loop will be slow enough to wait for about few minutes.
I decided to optimise some points:

- Using typed _Uint32Array_ with pre-defined length against dynamic empty array;
- Each elf delivers `elf * 10` presents to a house so we can divide input by 10, decreasing iterations of our loop;

Afterwards, our loop just sums up elf’s number to a value in _houses_ array and if this value if greater that our input — we have an answer.

{% gist e6f50913115058f67bd0 %}

## Day 20 — Part 2 (Infinite Elves and Infinite Houses)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-20/part-2)

The same logic applies here but we need to calculate visits of our elves because:

> Each Elf will stop after delivering presents to 50 houses.

Try to not forget that our elves delivers 11 presents as well, multiplying the presents count by 11 and summing up in _houses_ array.

The result as in previous part — our _houseNumber_.

{% gist 52adb8cfab7191f6b2e7 %}

## Day 21 — Part 1 (RPG Simulator 20XX)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-21/part-1)

Let’s split our task into steps:

- We have a store where we can buy weapons, armor and rings — simple constants;
- We need to calculate total stats that we have from our equipment and based on our stats calculate that damage per second;
- We need to find the best equipment with the lowest price — combinatorics;
- Play the game with all possible combinations of our equipment and find the lowest price of this.

The simplest part — declaration of our store which is a _Map_.
Each of our _Map_ has a name of item as key and an object with _cost_, _damage_, _armor_ properties as value.

Having all these stuff we can write function that accepts these items and calculate total stats of your hero — _getTotalStats()_.

When you know your hero’s stats you can calculate damage per round which is a simple substraction of your damage from boss armor.
Dividing boss health points by your damage per round you can calculate how many rounds you need to play to win — _hitPerSecond()_ and _makeMove()_.

We have all what we need to calculate state of the game.
Now, we need to generate all possible equipment bundles which is simple to implement with generator — _possibleBundles()_.
The logic there is simple — iterating through all store, yield total stats of current iteration.

The best part of this day — solution.
Iterate your generator, calling the _makeMove_ function and find the minimum price.

{% gist 4a9bfe5b0da1e79d0d57 %}

## Day 21 — Part 2 (RPG Simulator 20XX)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-21/part-2)

Whoa, all remains the same, except:

> What is the most amount of gold you can spend and still lose the fight?

Just update your code to find the maximum price when you lose (_Line 66_).

{% gist ba4bfce7ef064af9adf9 %}

## Day 22 — Part 1 (Wizard Simulator 20XX)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-22/part-1)

I was trying to find the solution around 2 days and still unsuccessful.

All what I can say here — is “Thanks” to some guy from Reddit, who had posted solution there.
I don’t remember his nickname, but if you are reading this now — contact me and I’ll mention your name here.

{% gist b28d760db27d2df004e9 %}

## Day 22 — Part 2 (Wizard Simulator 20XX)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-22/part-2)

Problem remains the same with one difference:

> At the start of each player turn (before any other effects apply), you lose 1 hit point.

Just add decrementing the health points at each turn (_Line 129_).

{% gist 830bb74548376ef9031b %}

## Day 23 — Part 1 (Opening the Turing Lock)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-23/part-1)

Yeah!
Low-level stuff, kind of.
I was raised on Assembler and low-level stuff (thanks to my father).

We need to simulate a processor and macro assembler to determine what we need to do with input command.

Firstly, let’s write simple regular expressions to parse input commands.

Secondly, a processor which has two registers (for our case).

Thirdly, a macro assembler which has an instruction like _hlf_ or _inc_ and assigned function to calculate this instruction.

We have all we need to simulate interpreter for our language.
Having source code, which is your input, we can parse this source code from text and return object with _instruction_, _register_ and _offset_ properties.

The simplest part now is _while_ loop.
While our pointer points to existing instruction in our source code — we need to execute it.
Parse this instruction and apply it to our macro assembler, storing the result in processor.

Answer to our problem will be value in register _b_ from our processor.

{% gist c029e37819b96e111d2f %}

## Day 23 — Part 2 (Opening the Turing Lock)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-23/part-2)

The same task with different starting values in our processor.

> What is the value in register b after the program is finished executing if register a starts as 1 instead?

Update our processor declaration at line 8 and run the solution.

{% gist 5cc556a10631e7f09767 %}

## Day 24 — Part 1 (It Hangs in the Balance)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-24/part-1)

We have a few hints right in the problem definition:

> The packages need to be split into three groups of exactly the same weight.
> The one going in the passenger compartment — needs as few packages as possible so that Santa has some legroom left over.

and

> It doesn’t matter how many packages are in either of the other two groups, so long as all of the groups weigh the same.

Let’s start with finding the weight (we have 3 groups in this case).
Reduce the input array, finding the total sum and divide this sum by 3.

Afterwards, while we don’t have the valid packages (with equal weight) iterate all possible combinations of packages and if weight of each package for current combination is equal — push to valid packages array.

Solution to this problem is quantum entanglement which can be calculated as following:

> The quantum entanglement of a group of packages is the product of their weights, that is, the value you get when you multiply their weights together.

Map the valid packages and calculate the quantum entanglement of this packages.
Find the minimum quantum entanglement which is our result.

{% gist df7520cee740072eaee7 %}

## Day 24 — Part 2 (It Hangs in the Balance)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-24/part-2)

Solution remains the same except the weight of each group because:

> “Ho ho ho”, Santa muses to himself. “I forgot the trunk”.

Divide total sum of each package weight by 4 and find the minimum quantum entanglement for this case.

{% gist 4a05a4488c9498504656 %}

## Day 25 (Let It Snow)

_Problem definition:_ [_link_](https://github.com/ghaiklor/advent-of-code-2015/tree/master/day-25)

Finally, we are on the top of Christmas tree.
I afraid that the last problem will be mega-super hard to solve but it’s not — just simple math.

Here some quotes from problem definition which are important:

> The codes are printed on an infinite sheet of paper, starting in the top-left corner. The codes are filled in by diagonals: starting with the first row with an empty first box, the codes are filled in diagonally up and to the right.
> So, to find the second code (which ends up in row 2, column 1), start with the previous value, 20151125. Multiply it by 252533 to get 5088824049625. Then, divide that by 33554393, which leaves a remainder of 31916031. That remainder is the second code.

Here, we have a simple formula to calculate the next code — `(previous code * 252533) % 33554393`.

All need to do is to determine index of our target `[row, column]` and iterate calculating the result by formula above.

{% gist 9e05ef6320306ff7e50e %}

---

It was a new experience for me in solving these problems and I highly recommend to play this game on your own.

Thanks [Konstantin Batura](https://medium.com/u/9f08a06ac553) for helping me write this article.

*Eugene Obrezkov, Developer Advocate at [Onix-Systems](http://onix-systems.com), Kirovohrad, Ukraine.*
