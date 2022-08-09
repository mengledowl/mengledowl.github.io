---
layout: post
title: When Not To Use GraphQL
date: 2018-03-10 22:11:25.000000000 -06:00
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
  _wpas_done_all: '1'
  _thumbnail_id: '355'
author: Matt Engledowl
permalink: "/2018/03/10/when-not-to-use-graphql/"
---
![]({{ site.baseurl }}/assets/images/2018/03/3546059144_64e632801c.jpg)

I spend a lot of time talking about the vast [benefits of using GraphQL](/2017/10/15/5-things-love-graphql/)&nbsp;for your API. I believe that it's a solid technology that works for most use-cases when it comes to web APIs, and likely a lot of other applications as well (such as server-to-server communication). However, I would be remiss if I failed to point out that there are times when it might not make sense to use GraphQL for certain situations.

## Short-lived/Small Projects

Every once in a while, I like to do a bit of freelance work - just something on the side that doesn't take up too much of my time and can bring in a little extra money. These tend to be very small projects that don't necessarily need a whole lot too them and will likely never need to be expanded beyond the initial build. While GraphQL might be fun for a project like that (especially for someone who doesn't get to use it for their day job or would like to give it a go), it doesn't necessarily make sense when considering the overhead. GraphQL certainly makes front-end work much quicker and easier, but it does so by moving complexity to the back-end to some degree.

To give a concrete example, a while back I had a client who needed me to build an app that would keep their Shopify store in sync with their broader system so that their inventory numbers were always up-to-date. This project ended up being about 30 hours worth of work, and most of that time was spent trying to understand the terribly outdated system they were using to track inventory (which was using SOAP - yuck). It only needed to do 3 very simple things:

1. Receive webhooks from Shopify for updates
2. Poll 3rd party inventory system for updates
3. Update inventory information in each

In the end, using GraphQL for this would have added additional time and complexity where it wasn't needed. I only needed just a couple of endpoints, which I could do very quickly using a framework like Rails, and I knew that this would likely never need any further new development work. There was also no front-end for this project. None of the problems GraphQL was meant to solve were present for this.

## File Uploads

Most websites need to allow users to upload files at some point. In fact, it's one of the earliest things I ran into with GraphQL when I started doing it - how&nbsp;_does_ one upload files using GraphQL? Now, I should say that this is certainly possible. In fact, I've [written about how to do it](/2017/09/16/upload-images-to-s3-in-graphql-using-rails-and-paperclip/) and it's one of my most popular blog posts to date. For the scenario I dealt with there, it makes sense up to a certain point. For those that haven't read it, the basic idea is that if you want to upload images, you can base64 the image on the client and then perform a mutation passing in the base64 as a string and then you're done. For simple use-cases like that where you're not likely to have very large images/files that you're dealing with, this is probably fine.

Where that approach starts to break down is when you start dealing with medium to large files. Past a certain threshold, the process of base64 encoding a file becomes quite intensive and time-consuming, and then you still have to dump the string into a payload that goes to the server where it gets processed and possibly decoded (depending on what you need to do with the file). This can take a lot of extra time over doing a simple multi-part upload. It's probably best to stick with that for those types of situations, although I'd be very interested to hear others thoughts on this.

## Authentication

This one may be somewhat controversial. Not everyone is going to agree with me, but I feel that the place for authentication is outside of GraphQL. There tends to be a lot of really great tools and libraries that take care of the bulk of this for you (for example, [Devise](https://github.com/plataformatec/devise) is incredibly powerful if you're a rails developer and makes it very easy to authenticate a user). I don't think that this is the problem that GraphQL was created to solve, it's already solved very well by the existing tools, and I see no real benefit to doing it in GraphQL. That said, I'm open to changing my opinion on this if anyone has a compelling argument.

Generally I tend to advise others to do authentication&nbsp;_before_ you get to you GraphQL layer (or outside of GraphQL, depending on how you look at it), and then&nbsp;let your resolvers/business logic handle authorization. By doing this, you can restrict access at a very granular level if needed and still allow for utilizing the existing tools for authentication. Best of both worlds!

## What Did I Miss?

I'm sure there are plenty of other places where GraphQL doesn't make sense. After all, it was meant to solve a specific set of problems, and in order to do that, it has to focus on those and not on every other problem out there. These are the biggest ones that I've run into, and I would love to hear what other scenarios people might have come across where they feel that GraphQL might not be the best solution!

