---
layout: post
title: We Need More Best Practices In GraphQL
date: 2017-10-22 02:54:02.000000000 -05:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Opinion
tags: []
meta:
  _edit_last: '1'
  _wpcom_is_markdown: '1'
  _wpas_done_all: '1'
  _thumbnail_id: '131'
author: Matt Engledowl
permalink: "/2017/10/22/best-practices-graphql/"
---
The other day, a coworker pulled up a chair next to me and said one of my favorite things to hear.

"I've got some questions for you about GraphQL."

I was among the [first to start to venture out into the world of GraphQL at RevUnit](/2017/09/04/building-a-graphql-api-in-rails/), and I've been been singing it's praises ever since in my mission to **expand it's reach and help turn it into the standard for APIs**. As a result, people will oftentimes come to me when they have GraphQL questions as they're getting ramped up.

![]({{ site.baseurl }}/assets/images/2017/10/60b5625f2b03a3c8a7b3f64012de1272.1000x588x1.jpg)

_Me showing people GraphQL_

We had a great discussion about various different things, such as how to handle authentication and authorization, as well as a number of other things. Then he asked me a question I wasn't expecting. A really great question that I kind of fumbled my way through.

"What has been the thing that you haven't liked about GraphQL, or that you would change about it?"

I'm not going to lie, I felt a bit like a deer in the headlights for a minute as I tried to scrape something together for him. Eventually I landed on something that has been bothering me, and I've been reflecting on it ever since: **there aren't many best practices or standards in GraphQL that are easily accessible**.

### Why Is This Important?

I spend a decent amount of time hanging out in the [GraphQL slack](https://graphql-slack.herokuapp.com/), and I generally see two main categories of questions:

1. Technical questions - eg. how do I do a/b/c in GraphQL/my library of choice?
2. Best practices questions - eg. what's the best way to do a/b/c or how do you (plural) do a/b/c?

**Technical questions** are generally pretty matter-of-fact in nature - how do I define a connection in ruby? [Like this](/2017/09/24/graphql-connections-rails/). How do I mark a field as required? Use a `!`&nbsp;on your type declaration. These tend to have a clearly defined answer, even if it's complicated. This can also include questions about the fundamentals of GraphQL in general.

**Best practices questions** on the other hand, tend to be much more ambiguous and more difficult to find answers to - what should I do if I have a really long arguments list? What's the best way to do authentication/authorization in GraphQL? These can also oftentimes overlap with the technical questions which at their heart might be more of a question about best practices.

Newcomers can generally find the answers to technical questions by browsing through documentation, searching Google, reading blog posts, or asking around. When it comes to questions related to best practices though, no amount of googling tends to turn up many answers. Yeah sure, there are certain things that we have defined as best practices - such as using connections for pagination, but beyond that there's not a whole lot. In order to get these questions answered, they have to ask questions to the community, and the community doesn't always have much of an answer. At any rate it tends to just be "well&nbsp; **this is how I do it** , but I know some other people do it this way" which is fine, but when you're new it's not always that helpful.

### Proposal

I've seen plenty of people ask questions about best practices in GraphQL - oftentimes very directly, and time and again I've seen their questions fall flat.

This is a shame if you ask me.

When writing code, we should primarily be concerned with two things:

1. How do I accomplish this task?
2. How do I write this so that it's easy for the next developer to understand?

These questions correspond very closely to the two categories of questions that I outlined above. We have a lot of information for developers concerned with the first, but very little for those concerned with the second.

I propose that we as a community start to outline some of these best practices and standards, and compile these somewhere so that they are easy to find. This will allow newcomers to get up to speed more quickly, it will make those questions easier to answer, and will allow developers stepping into a new project to get their bearings and become productive more quickly.

I want to clarify that I'm not proposing that we only have one standard, or that we change the spec to reflect the standards or somehow force people into doing things a certain way. **That would be bad for GraphQL and does not reflect my values or my viewpoint at all.** Instead I'm suggesting that we define the things that we feel are best practices and encourage people to use them where they make sense, and step outside of them where they don't. It might even be that we decide to have multiple different sets of best practices depending on what kind of thing you're trying to do. I'm not sure how that would look, but I can see the merit in saying "yes, these two problem spaces are different enough that they can result in different best practices", and I'm fine with that. My main call to action is just for best practices to be documented and accessible. I want to make GraphQL easy and default, and it's my belief that in order to accomplish that, we need to have some of these things figured out so that developers and teams have less to figure out on their own.

So my proposal in a nutshell:

1. **Define best practices** for as many things as are realistic to define best practices for.
2. **Make it explicit** rather than implicit.
3. **Make it simple** to understand and begin implementing today.
4. **Make it accessible** and easy to find.

If you have any thoughts on this, please drop them in the comments below or hit me up in the [GraphQL slack](https://graphql.slack.com/messages/general/) (@mengledowl). I'd love to discuss this further and hear about any resources that may already exist around this that I may not have come across yet.

