---
layout: post
title: Benefits of GraphQL on the Backend
date: 2017-12-17 03:21:09.000000000 -06:00
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
  _thumbnail_id: '276'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2017/12/17/benefits-of-graphql-on-the-backend/"
---
![]({{ site.baseurl }}/assets/images/2017/12/william-bout-264826-1024x683.jpg)

There's a lot of information out there discussing what the benefits of GraphQL are, but many of them focus on the front-end more than anything. This is why it's so easy to convince front-end developers to use GraphQL - after all, it was built to ease a lot of the struggles they had. But what about back-end developers? What are the benefits from their perspective? How do you convince your back-end developer that they should use GraphQL?

### Documentation Is Much Easier

One of the most difficult, time-consuming, and obnoxious things in software development is writing documentation. No one wants to do it, but we all know how important it is,&nbsp;_especially_ when it comes to a RESTful API. If it's not documented, then&nbsp;_no-one can use it_. I've spent literally hundreds of hours documenting a single RESTful API, describing each different endpoint, what it does, how to interact with it, what responses look like, what a request would look like, what parameters you can pass in, etc.

It's. So. Tiring.

Ugh.

If you hate documenting your APIs so painstakingly, you know who your new best friend is?

**Fucking GraphQL.**

Just take a look at this:

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.22.56-PM-1024x640.png)

Do you see that section to the right of the "schema" tab? That's the documentation for a GraphQL API. You know what the best part is? It was all generated automatically. You know what writing documentation looks like in GraphQL? You write the code for your API. That's it. Well, basically - you should write descriptions for the fields to explain what they are, but that's basically nothing in terms of documentation, and it's something that you do in the code. **Your code literally defines your documentation for you.**

### No More Conversations About Views

That might be a slight overstatement, but let me explain.

Imagine yourself writing a RESTful API. What does the process look like? Well, first you probably look at the views and start having conversations with the front-end developers about what data they're going to need for a given view. After you determine that, you have to do it again for each and every screen. Then you have to spend time going back and forth with the front-end developers attempting to reach a compromise between returning too much and too little for a given endpoint so that they can get all the information they need without dumping the entirety of the database and killing performance or eating up bandwidth. Now imagine adding multiple different teams because you have a mobile app, a web app, and an external API for people to plug into, and all of them have varying needs. That's a lot of conversations that need to happen about precisely what data should be returned from a given endpoint.

The main problem here is that these conversations shouldn't be taking place with the back-end developers at all. GraphQL recognizes that - the client/front-end is the thing that cares about what data it needs. With GraphQL, you don't have to have these conversations at all because instead of creating a bunch of endpoints that return a designated response, you are simply looking at what data the client&nbsp;_could potentially_ need and&nbsp;_exposing_ that to them. Each client/view can then ask for precisely what it needs and no more. Every single one of those conversations vanishes overnight - all you care about is modeling your data, not whether or not you should include the comments in the payload or have it be located at a separate endpoint. In other words, you're...

### Thinking In Graphs

This shift to [thinking in graphs](https://graphqlme.com/2017/11/11/build-better-graphql-apis-thinking-in-graphs/) takes many newcomers to GraphQL a while to get down, but once you do, it simplifies a lot of things. No longer is there this strange attempt to take your data and the relationships between your models and cram them into endpoints. Those two things just don't mesh well. Instead, you focus on your data and the things you'd like the client to have access to. Once this mental shift occurs, it's actually much more intuitive than the RESTful way. It actually reflects much more directly the way that we would draw out our data models on a whiteboard when discussing the relationships between different structures. This makes it much easier to build your API, and it allows both the front and back-end developers to move more quickly (at least in my experience).

### Better Tooling For Testing

Running requests against your RESTful API while you're developing on it to see if your changes are working can be a bit clunky. We do have tools like Postman that help a lot with that process, but even that has some difficulties.

GraphQL makes this incredibly easy with tools like [GraphiQL](https://github.com/graphql/graphiql) and [GraphQL Playground](https://github.com/graphcool/graphql-playground)&nbsp;(you can check out my review of GraphQL Playground [here](https://graphqlme.com/2017/12/03/graphql-playground-review/)). These allow you to run queries, see your documentation, and basically give you all the niceties of a fully-fledged IDE such as autocomplete, code prediction, and more. Look back at the image above showing the schema - that's GraphQL Playground. I can't express how powerful these tools are and how much easier they have made my life when it comes to this stuff.

### Conclusion

There are many more benefits that I've experienced, but hopefully I've been able to adequately convey (some of) the benefits that a back-end developer can expect from using GraphQL. As someone who is primarily a back-end developer and loves building APIs, let me just tell you that I would not choose REST over GraphQL without a pretty good reason.

If you found this helpful and/or you know someone who isn't sure what the benefits would be for them on the back-end, please share this article with them! Leave your thoughts/questions/feedback in the comments below and I'll do my best to address them.

