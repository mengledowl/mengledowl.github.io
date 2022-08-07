---
layout: post
title: 5 Things to Love about GraphQL
date: 2017-10-15 02:56:44.000000000 -05:00
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
  _thumbnail_id: '107'
author: Matt Engledowl
permalink: "/2017/10/15/5-things-love-graphql/"
---
There are a lot of things to love about GraphQL, and a lot of reasons to use it. Here are 5 of my top favorite things about it.

### #1 Introspection

![]({{ site.baseurl }}/assets/images/2017/10/thinking-thinking-work-man-face-60061-1024x742.jpeg)

GraphQL APIs understand themselves. I can query my API and see everything about my schema - what fields, objects, types, interfaces, and other entities that I have access to, and how they relate to each other. The schema documents itself, which means that I don't have to spend tons of time either digging through code to remember things, or writing a ton of documentation to cover everything. Documenting APIs is one of the worst things I had to do with REST. I have spent hundreds of hours on a single project writing documentation around just the API, and it's a very painful experience. With GraphQL, I just define my schema and then I can see everything about it. This is what allows GraphiQL to do it's thing. In my opinion, **introspection is one of the most powerful features of the GraphQL spec, and is enough reason on it's own to make the switch from REST**.

### #2 Versionless

![]({{ site.baseurl }}/assets/images/2017/10/1wdfb7.jpg)

Anyone who has ever worked with RESTful APIs has likely dealt with versioning, even if they didn't realize it. With REST, each endpoint has it's own payload that the client uses but has no direct control over. Essentially what happens is that clients use these payloads and become dependent on the expected structure of the data from that endpoint. What happens if at some point, I do an overhaul on the server-side to the data structure that would move things around, rename things, or otherwise break clients using it? These are things I have to think about as the one building the back-end, and the solution in REST is to release another version. This is why you see API urls with `api/v1`&nbsp;and `api/v2`. This is a sub-par solution because this generally results in a lot of duplicated code, having to maintain two versions, and all kinds of pain. In GraphQL, this is a non-issue. Since the client asks for what they need, we can safely just leave the old fields, and add new ones if we want to modify something. **This way we can make changes without risking introducing breaking changes for the client.**

### #3 Client-Driven

![]({{ site.baseurl }}/assets/images/2017/10/drive-516376_1280-1024x682.jpg)

An API is just an interface to interact with data, and it is meant to _serve the client__'s needs_. REST is honestly pretty terrible at this because all the control is on the server-side. If the client-side needs an additional piece of data, they have to ask the developers on the back-end to add it. If they need less data, well, they're probably just going to have to get over it because there are probably other things relying on this API than just them. This lends itself to a lot of back and forth between those dealing with the front-end and those building the API, and this is communication of the unnecessary and painful type. GraphQL serves as a much more flexible API that puts the&nbsp;_client_ in the driver's seat. **Where REST says "I will give you whatever I think you should have", GraphQL instead says "tell me what you want and I'll give it to you".** Now rather than the back-end programmers having to listen to what the front-end developers need, this can be abstracted away and the API can listen to the front-end developers needs.

### #4 One Endpoint (To Rule Them All)

![]({{ site.baseurl }}/assets/images/2017/10/13583362554_97d89bede0_b.jpg)

REST has a lot of endpoints - generally 1-5 per resource, and there can be any number of resources. This is part of what leads to needing so much documentation. It's also a large cognitive load figuring out how to structure the endpoints and how to cram your data into an endpoint structure. **GraphQL only uses one endpoint and then you can represent your data within that endpoint as a graph.**

### #5 GraphQL Is A Spec

![]({{ site.baseurl }}/assets/images/2017/10/13134020174_5246cb94b7_b-1024x683.jpg)

It's not a library. **This is important because it means that it doesn't matter what language you use, it can be implemented (or already has been) to follow the spec meaning that you can expect things to be the same between implementations**. It also means that as a community, GraphQL can draw learnings and best-practices from a breadth of experienced developers, not just those from a specific language. It also has a much greater chance for wide-spread adoption because it is language-agnostic. The fact that the spec has been getting implemented as libraries in multiple languages gives it yet another leg-up on REST because it doesn't leave as much room for individual teams to implement it incorrectly (this is actually one of the big complaints that many REST purists have - most implementations of "REST" don't actually follow the spec). If there's a library that already implements the spec, you're a lot more likely to just pick up the library and use it as opposed to rolling your own.

### Conclusion

There are obviously a lot more things to love about GraphQL than just these 5 things, but as I was reflecting on my journey thus-far, these are some of the things that came to mind for me as some notable favorites. I'm sure these will expand as time goes on, but I think these will remain core to what I love about GraphQL.

