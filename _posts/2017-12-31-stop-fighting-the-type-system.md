---
layout: post
title: Stop Fighting the Type System
date: 2017-12-31 04:15:46.000000000 -06:00
categories:
- Opinion
tags: []
author: Matt Engledowl
permalink: "/2017/12/31/stop-fighting-the-type-system/"
---
![]({{ site.baseurl }}/assets/images/2017/12/cloudvisual-208962-1024x683.jpg)

> How can I either change the format of the errors returned or else turn them off completely?

This is the question I recently encountered from a newcomer to GraphQL - a strange question to say the least.

He started with some background. In the pre-GraphQL version of his app/API, when errors occurred, the app would dump those out into an errors field with a message for each error. This allowed the client to easily display errors to the user.

Then he went on to outline his frustration with an example. When using GraphQL, if someone tried to pass in a string as an argument for a mutation where an int was expected, the resulting error was a bit convoluted and difficult to parse.

Then came his question.

In a nutshell, what I told him was “ **stop fighting the type system!** ”

Let's expand on that a bit.

### Two Kinds of Errors

There are two different kinds of errors in GraphQL:

- **Type errors - these happen when the type system receives something that doesn’t match what it’s expecting. For example, if you have a quantity field that you specify as an int in GraphQL and then try to pass a string into it, this would trigger a type error. GraphQL would basically say “hey, I was expecting an int, and I got a string!”**
- **Validation errors** - these are a type of error that has more to do with business logic than anything else. Something like “quantity must be less than or equal to the max amount allowed” would be a validation error.

If you have ever worked with a typed-language such as java, you know all about type errors. In these languages, if your code has a type error, your IDE/text editor will often give you a red squiggly line accompanied by a message warning that your code is invalid. If you try to compile anyway, your compiler will blow up and spit out an error about how you can’t pass a string in for an int type, or whatever error you might have.

It makes sense to display errors of the second kind - validation errors - to users. They need to know if they tried to create a duplicate record or some other such thing that violates the business logic of the app. Type errors on the other hand should only ever be something that the developer(s) see. After all, do we really expect the end-user to be able to figure out a way to turn the input from the “quantity” textbox into an integer? Of course not, that’s not their job.

### Your Friend, the Type System

I’ll say one more thing about this: the type system is there to help you - it’s meant to protect the integrity of your data. If you find yourself fighting with it, then you’re probably doing it wrong. Take a step back and re-evaluate. Is there something you could be doing differently to handle the situation you’re encountering?

But for the love of all that is good, please don’t try to turn off part or all of the type system in GraphQL. That’s just asking for trouble, and betrays a misunderstanding of how it works and what it does for you.

