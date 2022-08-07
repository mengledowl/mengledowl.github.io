---
layout: post
title: Should You Use GraphQL For Your MVP/POC?
date: 2018-01-20 18:30:03.000000000 -06:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Opinion
tags: []
meta:
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _thumbnail_id: '311'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/01/20/should-you-use-graphql-for-your-mvp-poc/"
---
![]({{ site.baseurl }}/assets/images/2018/01/igor-ovsyannykov-219666-1024x683.jpg)

Startups and large corporations alike know the concept of an MVP or a POC. These are important tools when attempting to determine the viability of a concept without sinking a lot of unnecessary time, money, and energy into the idea. This brings us to the question I want to explore today:&nbsp; **does GraphQL make sense for MVP/POC stage development?**

Let's start off by defining our terms and what I feel each hopes to accomplish.

**MVP** - Minimum Viable Product. When building a new piece of software, be it from the ground up or as simple as a new feature, an MVP is an attempt to build out the&nbsp;_smallest, simplest version which is a complete, functioning product.&nbsp;_What this looks like in practice can vary widely, but the main point is that anything that isn't considered an essential function gets stripped out so as to provide a functioning product as quickly and cheaply as feasible in order to see if you're on the right track before sinking a lot of dollars and hours into it.

**POC&nbsp;** - Proof of Concept. In software, a POC is meant to provide a level of certainty that a particular idea is actually possible to implement. This is easily conflated with MVP as it shares many of the same attributes: quick, stripped-down build, low-cost, etc. The difference is that rather than attempting to prove&nbsp;_market viability_, which is what the MVP is intended for, a POC attempts to prove&nbsp;_technical viability_. A POC often amounts to throwaway code that never sees production and is just a way to say "hey, this is possible to build within a reasonable timeframe", giving the business confidence in giving the project the green light.

Some of you might already be annoyed that I spent as much time defining those two things as I did, as many of you probably already know what those two terms mean. I can just here you groaning right now: "Matt, wtf man, I already know what these things mean".

I hear you. I'm defining them here very intentionally though, so as to be sure we address the main points of what each of these hopes to achieve. With the goals of each in mind, it makes it more productive to dive into how GraphQL can help with these.

## GraphQL For MVPs and POCs

Let's start with a recap of what the characteristics are for MVPs and POCs (many of which are overlapping):

- Smallest unit of work that constitutes a complete, functioning product
- Quick (not spending an inordinate amount of time on it; quick in terms of being able to iterate)
- Cheap (avoiding blowing lots of money)
- Can prove (or disprove) market viability and technical viability

Does GraphQL allow you to build MVPs/POCs with these characteristics?

Yes, absolutely!

It's actually pretty quick and easy to learn the basics of GraphQL needed to get to a working knowledge, so even if you don't have anyone who knows it, you can get up and running pretty quickly. When building a GraphQL API, you don't have to use all the fancy tools that come with it from day one, meaning that you can strip out all that is unnecessary for you MVP. My own experience as well as those of others indicates that development moves much quicker on the front-end when using GraphQL than REST. In fact, it's very easy to get moving with fake-data to allow the front-end to get busy implementing things without needing to wait on the back-end work to be completed. This can be achieved in various different ways - I've personally created portions of my schema as needed by the front-end, supplying fake-data at first until I could come back around and implement with real data. There are also libraries that can achieve this sort of functionality. I haven't used any of them, but I've heard good things about them.

By nature of GraphQL allowing you to run in a "versionless" manner, it also lends itself to being able to iterate quickly on your MVP once you've moved onto the "proving market viability" phase. If you need to add some new fields to try some new iteration, you can do it without worrying about your payloads becoming bloated or needing to protect your API. There's no need to worry that your API will quickly need a V2 or risk instability in the beginning phases like there might be with REST as you try to figure out what you need. It's not an issue with GraphQL!

In terms of&nbsp;_technical viability_ for a POC, I would actually consider it somewhat of a non-issue in that it doesn't really have an impact either way - it neither helps nor hinders you there outside of the benefits of being able to move more quickly. Obviously the exception to this would be if you are attempting to build a POC to determine if GraphQL is a good fit for your use-case!

