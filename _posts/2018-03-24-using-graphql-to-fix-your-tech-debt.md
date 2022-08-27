---
layout: post
title: Using GraphQL to Fix Your Tech Debt
date: 2018-03-24 23:33:44.000000000 -05:00
categories:
- Opinion
tags: []
author: Matt Engledowl
permalink: "/2018/03/24/using-graphql-to-fix-your-tech-debt/"
---
![]({{ site.baseurl }}/assets/images/2018/03/vladimir-solomyani-502936-unsplash-1024x683.jpg)

Technical debt or "tech debt" is a hot topic these days. If you've been in tech for more than 5 minutes, you've probably heard of and/or read about it, and every team I've ever been on has nearly constant discussions around it - how to manage it, avoid it, pay it back, etc. Still, this doesn't prevent it from accruing.

In the fast-paced and changing world of business and technology, there is no escape from it if you want your company to survive. Even if you&nbsp;_mostly_ avoid it, at some point you'll have to move quickly to get something out the door or make an architectural/coding decision without all of the facts in front of you, and the result is still that you have some level of tech debt.

There are lots of tools for managing this - from design principles and coding patterns to bug trackers to dedicated time for reducing tech debt, and so on. I would like to propose that **GraphQL can be an effective tool for cleaning up tech debt** without creating a bigger mess. If you read my post about [sprawling architecture](/2018/02/17/how-graphql-solves-the-problem-of-sprawling-architecture-for-the-enterprise/), I actually briefly mentioned this, and would like to expand on it some here.

## How So?

By design, GraphQL is very modular, focused, and simple. When you expose a GraphQL API, you are getting very granular with your data, specifying the fields that are exposed, and then specifying precisely how to get that piece of data. This can lend itself to swapping out debt-ridden services or code with cleaner implementations.

Let's take a contrived example.

Imagine that you have a service of some sort that handles returning data about recommended items for a user based on their previous browsing on your site. It's got all the nastiness of a service that was put together hastily with too little thought or input into how it would work, and now it's hobbling mess. When you hit it, you have to send multiple separate requests to get all the information that you need, you have to combine some of the fields that come back, dismantle others, and it's super slow because it hits 4 different data stores behind the scenes.

Currently your apps interact with this service by making REST calls to it, and any changes to that REST API would require that every app that uses it gets updated. This&nbsp;_could_ be handled somewhat by versioning the API, but the problem is that the level of overhaul needed for this would take months if not years to fully complete, and in the meantime new features need to be added. The best way to do this would be incrementally, but with versioning an API that becomes nearly impossible.

## Enter GraphQL

With GraphQL, this becomes easier to deal with. The first step is to graph out how your data&nbsp;_should_ look to the client(s) consuming the API. Once you've figured that out, you have your schema and can lay a GraphQL API over the top of what you've already got. All of that sticky stuff that we discussed above - making multiple calls to get the data you're looking for, combining/dismantling fields to get at the data, etc - that all gets handled by the GraphQL API in resolvers at the field level. So if you had a single string coming back that had 3 different pieces of data in it before, now you've got three separate fields, each with a different resolver that says "hey, get that string and grab the first 10 characters or match this regex to get the value I want to return for this field".

Now with your apps hitting your GraphQL API, you can start working out the underlying problems in the system. Take the part of the code that's got 3 pieces of data in a single field and change that one piece to work in a more intuitive way, and update your resolvers accordingly. Your service is working more intuitively but the clients consuming your API don't need to make any changes or&nbsp;_even know that it changed at all._

What about continuing to add new features?

Well, that can be handled easily as well. Adding new fields to GraphQL has no cost and does not require a versioned change or anything like that - you simply add it. The client can then be updated to use that whenever. As an added benefit, since the client is asking for the data they want, you can actually monitor&nbsp;_which fields are still getting called and how often_. So if you wanted to add a new field that eventually replaces another, you can deprecate the old field and watch your analytics to see if it's still being used anywhere, and who it is that's using it.

This allows you to incrementally begin to get tech debt under control and iterate quickly on it without creating a huge mess and having to coordinate the updates with other teams/systems. Obviously, you have to pay the price of switching to GraphQL, but isn't it better to do that once than to do it over and over again as you try to do various releases to grapple with your tech debt? I would think so.

