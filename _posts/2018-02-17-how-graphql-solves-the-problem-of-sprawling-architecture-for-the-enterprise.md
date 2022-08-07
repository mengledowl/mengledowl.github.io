---
layout: post
title: How GraphQL Solves the Problem of Sprawling Architecture for the Enterprise
date: 2018-02-17 17:08:38.000000000 -06:00
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
  _thumbnail_id: '336'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/02/17/how-graphql-solves-the-problem-of-sprawling-architecture-for-the-enterprise/"
---
Have you ever worked at an enterprise or large corporation that has been around for at least a few decades? I don't know about you, but I'm somewhat amazed that many of them continue to be able to operate with the way their system architecture looks (which is about how my living room looks after my 15 month old son has had his way with it).

The big one I want to talk about today is services.

![]({{ site.baseurl }}/assets/images/2018/02/Screen-Shot-2018-02-17-at-9.23.04-AM.png)

## A Big, Hairy Problem

Companies that have been around for a long time and have been successful tend to have gone through lots of different tech phases and stages. Typically what you can expect is:

- Sprawling architecture with countless services
- Lots of different standards (SOAP, REST, etc)
- Little to no documentation, or documentation that is inaccurate/old - plus for each service it's hosted in a different place with a different service and you have to ask around for a week before you can find it
- Inevitably a service exists that follows no standard at all, has no documentation, and was the brain-child of that guy that works in a different department than you and can only be reached by scaling the side of a building, learning french and at least three dialects of Chinese, and cracking his home-baked crypto algorithm (which you're pretty sure isn't a real algorithm and is just him mashing keys on the keyboard to screw with you)
- Several services do similar things or have overlapping responsibilities

I could go on, but I'll spare you.

So what's the answer? It's too much to rewrite it all. It's too much to even document it all - plus, how do you think the 50 different ways of doing documentation came about? That's right - some new person who came in and said "hey, we should just write up some documentation using this great new tool, X!" Not to mention that there are tons of applications that rely on these services, and many of them probably rely on each other.

![]({{ site.baseurl }}/assets/images/2018/02/eao9e.jpg)

_Waiting for all those services to get fixed_

## API Gateway

My answer to this problem is simple on it's face, but very powerful in practice: use GraphQL as an API gateway.

So what exactly is an API gateway? My simple explanation would be: **it's a single point of entry into your system architecture.&nbsp;** Let's say you have a bunch of different services, one for managing each of the following separately:

- Products
- Inventory
- Shipping
- User details

Without a gateway, you would have to hit each of these separately from each app that required them. This quickly becomes an implementation and maintainability nightmare - if one of these changes, you have to change it in every app that touches it. Good luck "moving fast" and "being agile" in an enterprise setting where you've got dozens of these services and as many apps all using them.

![]({{ site.baseurl }}/assets/images/2018/02/without-1.jpg)

_Without a gateway_

A gateway would be a layer over the top of all of these services. Rather than hitting them directly, you go through the API gateway, which then routes to a specific service depending on what it needs to do.

![]({{ site.baseurl }}/assets/images/2018/02/with.jpg)

_With a gateway_

When you use this pattern, you have now decoupled your services from the applications that use them. If you need to make a change in your products service, you now only need to change the service and the gateway. Without the gateway, you would be forced to change every app that uses that service, which could be dozens of applications which are likely managed by separate teams, all of which have their own priorities and deadlines to hit that are more important to them than spending several weeks (or months) updating their application code and coordinating with you just because you wanted to update an endpoint.

This gateway architecture fits really well into the GraphQL story. Let's look at some of what GraphQL provides:

- Single endpoint into your API
- Ask for what you need/want and get it
- Moves business/shared logic into a single place
- Data-layer agnostic (doesn't know or care where your data is coming from, just tell it how/where to get it)
- Self-documenting

To me, this is basically an iteration on what a gateway is/does, adding some nice sugar on top. By using GraphQL as your gateway, you can have all of your documentation in one place (introspection query against the endpoint), all your services are hit from one place, you don't have to decide what to return to the client since they get to ask for it specifically, and your resolver logic can be easily swapped out at any time. The fact that your resolvers function on such a granular level makes it really simple and easy to iterate on your services and upgrade them or even completely rewrite/replace them over time with no impact to your client applications.

With this one architectural change, an enterprise can go from a brittle, sprawling architecture barely hobbling along, to one where that complexity and maintainability nightmare is suddenly very manageable. What's going on behind the gateway may still be a big, hairy mess, but now you can more easily and quickly start fixing those pieces without creating a mess for the client-side applications. Your front-end/client-side developers will love you for giving them access to such powerful technology that allows them to not have to worry about the implementation details of which services to hit and maintaining that, and your back-end developers will love you for giving them the freedom to operate without having to coordinate so heavily to avoid breaking everything.

Plus, imagine how nice it is to onboard people into the system architecture now and get them productive. On their first day, you show them a diagram like the one above with the gateway, and sit them down in front of a tool like GraphiQL pointed at your API's GraphQL gateway endpoint. They can drill through the entirety of the graph of your architecture to see how it all fits together, read the documentation, play around with some queries to see what comes back, and could probably be building something in a couple of hours or less.

## Is It Worth It?

This is a no-brainer to me.

Wins all over the place.

Obviously the caveat here is that this requires building the GraphQL API and pointing your existing apps to that rather than at the services directly. And I'm not oblivious to the effort required to do this - it can be really heavy-lifting. The nice thing about this is that it's a change that can be done incrementally. Start with moving one or two services into your GraphQL gateway and focus your effort around pointing all apps that use those services to your GraphQL endpoint instead. Once you've gotten that, you can keep going one service at a time, and before you know it, your client-side code is decoupled from your services!

