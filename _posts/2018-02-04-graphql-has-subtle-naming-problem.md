---
layout: post
title: GraphQL Has A Subtle Naming Problem
date: 2018-02-04 00:16:48.000000000 -06:00
categories:
- Opinion
tags: []
author: Matt Engledowl
permalink: "/2018/02/04/graphql-has-subtle-naming-problem/"
---
![]({{ site.baseurl }}/assets/images/2018/02/philippe-awouters-425204-724x1024.jpg)

> There are only two hard things in Computer Science: cache invalidation and naming things.
>
> -- Phil Karlton

Most programmers have heard this quote from Phil Karlton, and with good reason - it tends to resonate. If you've ever dealt with caching then you know that it's not caching an item that's hard - it's making sure that what you have cached stays up-to-date correctly. When adding a caching layer, it's easy to cause lots of strange bugs that you might never have anticipated.

Many of us never have to worry about that though, or at least have only had small encounters with the beast that is cache invalidation. Naming things on the other hand is a problem that a new programmer can encounter as early as day 1, and will continue to face for the rest of their career.

Why do I bring this up, exactly?

**Because I think GraphQL has a naming problem of sorts.**

## What's In A Name?

So, why is naming so hard anyway? Well, there are a lot of reasons. Have you ever looked at code from someone who is taking their first programming class? They tend to give variables names like:

- x
- thing
- obj
- num
- tmp
- idk

The problem with naming things this way is that the names hold no meaning. Without closely examining the code that uses these variables, there is no way to know what they represent.

Another problem in naming things comes from trying to name things in such a way that you can maintain a safe and clear distinction between two very similar but different things. This is the kind of naming problem I see cropping up in GraphQL. And what exactly is the culprit here?

## Relay

If you've spent much time working with GraphQL, you've at least heard of it. In case you haven't, it's a GraphQL client that you can use to help with retrieving data from GraphQL (there's more to it, but for our purposes, this should suffice). It was built by Facebook and has a lot of ideas and opinions baked into it. Some of those include:

- How to do pagination
- Global IDs
- Mutation structure

The way that relay handles these things are based on sound principles and ideas. For example, pagination is done via “cursor-based” pagination - commonly referred to as “[connections](/2017/09/24/graphql-connections-rails/)”. The GraphQL community has rallied around many of these concepts and adopted them as best practices for how you should do things in GraphQL. The problem is that when referring to these concepts, particularly within different language implementations, they are named after relay rather than after the underlying core concept.

So for example, a connection isn't just called “Connection” or “CursorPagination” or something like that. Instead, the code tends to reference relay directly, by namespacing it under `Relay`&nbsp;or some other form or fashion. Even when "relay" isn't referenced directly in the code, often any mention of connections in the documentation will be accompanied by the word relay - something like "In relay, pagination is handled using connections..."

This may seem like a nitpick, but it's actually a real problem in my opinion. The way we name things has a big impact on how they are perceived, from what they represent, to how they work, to when, where, why, and how to use them. In this case, newcomers who aren't using relay see the word “relay” associated with these concepts and their immediate reaction is “oh, I'm not using relay, so I can't use this”.

This is one of the most common things I've seen come up with newcomers to GraphQL. They ask how to do pagination with GraphQL, looking for help on best practices. Someone will mention connections, and they immediately say “but I'm not using relay”. This indicates to me that by including the word “relay” in the naming, as well as talking so extensively about relay when we talk about those things, we have created a conflation between the two that has lead to a lot of confusion.

## Closing Thoughts

I get it. I understand why it happened this way. These concepts were introduced into the GraphQL community largely through relay, and they are defined in the relay spec. In a way, it makes sense to associate these things so closely. At the same time though, there are core concepts underlying these concepts that relay doesn't lay claim to. Why can't we just drop the “relay” part and call it what it is?

It's important to name things well, and naming is one of the hardest parts of what we do. Let's continue to improve on that, and start with disassociating relay with concepts that can be used without relay in GraphQL by being more intentional with our naming. After all, it's not just users of relay who can benefit from cursor-based pagination, but anyone who needs to paginate!

There may be a good reason to keep the close association that I haven't thought of it yet - if you disagree with me, I'm more than happy to discuss! Drop thoughts in the comments section, shoot me a message from the [about page](/about/), or come hit me up in the GraphQL slack! (I'm @mengledowl and I don't bite!)

