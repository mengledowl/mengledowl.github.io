---
layout: post
title: 'FUD: Facebook and GraphQL'
date: 2017-10-28 15:19:24.000000000 -05:00
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
  _thumbnail_id: '151'
  _wpas_done_all: '1'
  _wpas_mess: A while back, I wrote about a few different fears that I think hold
    some people back from using GraphQL. Apparently I missed one.
author: Matt Engledowl
permalink: "/2017/10/28/fud-facebook-and-graphql/"
---
A while back, I wrote about [a few different fears](/2017/09/09/are-you-afraid/) that I think hold some people back from using GraphQL.

Apparently I missed one.

It's called...

_Wait for it..._

### Facebook

![]({{ site.baseurl }}/assets/images/2017/10/facebook-2387089_1920-1024x682.jpg)

_Shhh, they're perfectly harmless_

For those that don't know, GraphQL was built by Facebook. Their front-end engineers got tired of dealing with the problems that REST presented them with, and so they came up with a way to interact with their API the same way that we tend to think about data: in graphs. This eventually led to the GraphQL we have today, and it was announced publicly in 2015. The spec was open-sourced along with the reference implementation ([graphql.js](https://github.com/graphql/graphql-js)), and many other implementations sprung up rather quickly following these events.

I'll start with the part of this that may or may not have had some legitimacy to it. Up until about a month ago, there was a somewhat decent chance that many people were infringing on Facebook's patent on GraphQL by using it. How much risk there ever was of being sued by Facebook over this, I don't know, but given the fact that they've since [relicensed the spec under OWFa](https://medium.com/@leeb/relicensing-the-graphql-specification-e7d07a52301b), I'd venture a guess that it's pretty low. While some still seem to be in a panic, most agree that this move to relicense has resolved the issue at hand.

The thing I really want to talk about here is fear that comes from...

### Distrust In Facebook

I've been surprised to see that some people who are choosing to forego working with GraphQL do so based on this vague notion that Facebook is "evil" and "not to be trusted". The problem with this line of thinking is that, even if it were to be true, in order for Facebook to be able to do something evil to you by your use of GraphQL, they would have to be exercising some form of control over you/GraphQL. The fact of the matter is that it's a spec, and an open-source one at that. With the relicensing issue touched on above, there really doesn't seem to be a whole lot that Facebook could do. In any case, this just amounts to FUD (Fear, Uncertainty, and Doubt) that to me seems pretty baseless.

By not using GraphQL out of fear, these people are missing out on some tremendous technology. It is changing the way we use the web, much the same way that REST did when it put SOAP into the ground many years ago (_although not quite deeply enough, as I found out when I discovered that I was going to be dealing with a SOAP API a while back - who even still builds those? plz stop_).

![]({{ site.baseurl }}/assets/images/2017/10/why-are-you-the-way-that-you-are.jpg)

I'll be the first to admit that Facebook itself **can be** problematic for many countless reasons. In fact, I deleted my Facebook account a while back after reading Cal Newport's fantastic book [Deep Work](http://amzn.to/2zgX09a), and I've seen nothing but benefits from having done so. But their technology tends to be pretty incredible - after all, they are one of the largest tech companies and most widely used websites in the world. **It would be damn near impossible for them to have grown to the scale that they're at now without having had some pretty impressive and well-built technology come out of it**. And really, while I believe using Facebook could be harmful to you, Facebook != GraphQL, and there are several layers of protection between GraphQL and Facebook - namely an open source license and the fact that it's a spec rather than some technology that you use through Facebook.

Let go of your fear.

Try GraphQL.

You won't regret it.

