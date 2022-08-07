---
layout: post
title: GraphQL Didn't Kill REST
date: 2018-04-01 02:46:25.000000000 -05:00
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
  _thumbnail_id: '378'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/04/01/graphql-didnt-kill-rest/"
---
There are lots of blog posts talking about GraphQL as though it killed REST. Here’s why they are wrong.

## The Background

You’ve probably seen the articles. They have catchy titles like “REST in Peace”, “REST is dead, long live GraphQL”, and the like. They are commonly written as an introductory piece to GraphQL, and are exciting to read. The implication is clear, and in many cases explicitly stated: GraphQL killed REST.

I don’t believe that this is the case, however.

Now I certainly believe that GraphQL is superior to RESTful architecture [in most cases](https://graphqlme.com/2018/03/10/when-not-to-use-graphql/). There are [many good reasons](https://graphqlme.com/2017/10/15/5-things-love-graphql/)&nbsp;to use GraphQL, [back-end included](https://graphqlme.com/2017/12/17/benefits-of-graphql-on-the-backend/), and [many of the fears](https://graphqlme.com/2017/09/09/are-you-afraid/)&nbsp;out there are [unfounded](https://graphqlme.com/2018/01/13/dispelling-common-misconceptions-about-graphql/). But did GraphQL really kill REST?

## I’m Not Dead Yet

![]({{ site.baseurl }}/assets/images/2018/04/9o19fr4iovoz-978x1024.jpg)

First and foremost, can we really say that REST is dead to begin with? I think that’s a pretty bold statement and quite frankly, one that's dishonest.

There is no doubt that RESTful architecture has been incredibly successful. It is one of the most common methodologies for creating web APIs to this day. In comparison, GraphQL, while it has been achieving rapid adoption in the marketplace, is still in its infancy (to some degree anyway, though it has been around for a lot longer than some may realize). Even looking at trends for REST, GraphQL, and SOAP on Google Trends reveals that REST is still pretty popular (interestingly enough, SOAP is still a fairly popular search term compared to GraphQL).

![]({{ site.baseurl }}/assets/images/2018/04/Screen-Shot-2018-03-24-at-5.56.04-PM-1024x550.png)

Granted, Google Trends isn’t exactly great market research, but it still gives us some information to work with about what people are searching for.

REST has been around for a long time - it was a big improvement on SOAP and was widely adopted. Countless APIs have been written with REST in mind, and they will likely be around for a long time. I think that it’s far from dead.

## REST Killed Itself

![]({{ site.baseurl }}/assets/images/2018/04/aJdz_IJIdblOC5OMtDvV_lAp_ir16tM-ROksPkWneQo.png)

“But wait,” you are undoubtedly thinking, “you just spent an entire section of this article trying to say that REST isn’t dead!”

Yes, I did. Let me explain.

No REST is not dead - yet. But I do believe that it’s death is inevitable, and that the blow is going to be (or was) ultimately dealt by REST itself.

How so? The obvious response is that all things die, especially in technology (except for the mainframe, I’m amazed how much of the world still runs on that). This goes further than that, however.

There are a lot of defenders of RESTful architecture out there. They sometimes appear to come out of the woodwork when GraphQL comes up, saying things about “HATEOAS” and “you can do that with REST” and “well, most people aren't&nbsp;_really_ writing RESTful services”, and on and on. This is all well and good, but it's precisely the problem I’m referring to.

Yeah, sure, the things that you do with GraphQL you can theoretically do in REST. You can have discoverability, and okay, maybe most people who claim to do REST aren’t actually adhering to it. But who actually knows what a true RESTful architecture is supposed to look like? If you listen to the people who claim to know, then the answer is “no one”. It’s nearly impossible to find people who fully agree on what constitutes as "RESTful". Not to mention that if you want to get all of these things, you have to go and implement them yourself, and good luck finding enough time to do that.

Now don’t get me wrong, the “general” idea of what REST consists of is pretty straightforward, but again, most people are supposedly doing it wrong. In this way, _REST is complicated_, which means that it is actively killing itself. The reason that GraphQL is gaining such widespread adoption so quickly is because it solves many of the problems that people have experienced with REST, and regardless of whether or not you could “solve them on your own”, the fact is that GraphQL makes this much simpler. Everything is outlined very clearly and concisely. If you want to know how something is supposed to act in GraphQL, the spec is very clear and simple, and there are libraries for almost every language you can think of that implement the spec. Where can you find that with REST? Sure, you can find libraries and frameworks that use MVC pattern, but that’s not the same as REST itself.

So while I believe that GraphQL is in many ways set to “replace” REST in a certain sense, I don’t believe that it will kill REST. Its demise comes from itself.

