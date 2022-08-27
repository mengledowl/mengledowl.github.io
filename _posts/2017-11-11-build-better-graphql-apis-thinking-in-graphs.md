---
layout: post
title: 'Build Better GraphQL APIs: Thinking In Graphs'
date: 2017-11-11 22:32:49.000000000 -06:00
categories:
- Opinion
- Tutorials
tags: []
author: Matt Engledowl
permalink: "/2017/11/11/build-better-graphql-apis-thinking-in-graphs/"
---
![]({{ site.baseurl }}/assets/images/2017/11/paul-285358-1024x683.jpg)

When making the transition to a new technology, there are two really big blockers people tend to encounter that can cause them to give up:

1. There are too many things that the learner has to understand before they can see and experience the benefits.
2. The paradigm shift is difficult and can take time before the "lightbulb moment".

Number one is pretty well covered when it comes to GraphQL if you ask me. One of the great things about GraphQL is that due to tools like GraphiQL, it can be very easy to start to see the benefits very early on, which can give people enough drive to keep going with it. The paradigm shift can still be quite the barrier to some people though. There is a pretty significant mindset change that needs to occur in order to transition from REST to GraphQL, and in the meantime it can lead to some sloppily designed APIs that try to stick REST specific strategies and practices into GraphQL.

### **Stop Thinking In Endpoints**

If you haven't been doing GraphQL for very long, especially if you've been doing REST for many years, **you're probably still thinking in endpoints and don't even realize it**. This is detrimental to designing a great, easy to use GraphQL API. If you want to build an intuitive API, the first step is to pinpoint the ways that you are still thinking in endpoints.

But wait - if what I just said is true and you don't even realize that you're doing it, how do you know what to change or whether or not you _need_ to change?&nbsp;Let's look at some warning signs that can indicate that you are still stuck in an endpoint mindset.

1. You find yourself mapping out RESTful endpoints and then trying to cram that out into your GraphQL API.
2. You are trying to build a schema out that allows you to drill in by resource \> action or vice versa eg:
```
{
  user {
      create(...) { ... }
  }
}
```
3. You are trying to separate out some of the resources by what page might need what parts of that resource eg. page A only needs a users name and email, but page B needs both of those plus their phone number and address, so therefore I need two fields for users, one to return the data for page A and one to return the data for page B.
4. When designing your object types you ask yourself questions about the page or pages that will be using that resource to determine what data and relationships to expose on that type.&nbsp;_(Some people may try to argue with me on this point - I'm not trying to say you shouldn't think about what the client-side needs, just that the question should lean more towards "could the client need this" as opposed to "what does this page need")_
5. You keep calling fields endpoints or comparing them to endpoints.
6. Your fields are designed in such a way that in order to fetch a relationship, you have to send a request to get the id from one field and use it in a subsequent request to get the related item you are interested in. Eg. ask for `comment { userId }`&nbsp;in request #1 and then send a second request for `user(id: userId)`&nbsp;in order to get the user.

There are plenty more, but these are pretty common in my experiences. Now, I don't bring this up to shame anyone - **this is one of the most difficult aspects about GraphQL to grasp and it takes some time to make the shift to thinking in graphs rather than endpoints**. If this is you and you're wondering how you can start thinking in graphs and what that means, then read on!

### **How To Start Thinking In Graphs**

A lot of resources on GraphQL talk about this concept of “thinking in graphs”, touting it as superior to thinking in endpoints or discussing how we naturally think about data in this way, but I haven't seen many that go on to explain it. I have seen a lot of developers struggle to make this shift in their thinking, and I know it took me some time as well. **This is such a core concept that once you get it down, you'll find that a lightbulb goes off and designing your schema becomes a much simpler task.**

I'm going to explain what I do in order to figure out how to structure my object types in my schema. Before I do this, throw out everything else - forget about endpoints, payloads, etc. and just focus on this one thing.

Here's what I do:

When I am looking at a GraphQL object that I'm building, I ask myself “what data or relationships might the client-side conceivably need access to from this object?”

Let's take an example. Say I have a `UserType` that represents a user. The temptation might be to say “what pages are there and how do I…” stop right there. That's endpoint thinking. We don't even want to consider pages, generally speaking. Our only concern is to expose data. So we look at the users data and say “what data or relationships might the client need to be able to get to from a user?” Or “what information is relevant to a user?”. Some obvious things would be their name, email, website URL, etc. That's the data that directly correlates to a user.

But what about relationships? This would be things like a users posts, comments, liked articles, groups they're part of, etc. Again, don't think about whether or not there are currently any use-cases on the front end for getting a user and then pulling down their groups. That's not a relevant question here. In fact, **if an explicit, implicit, or otherwise abstract relationship applies to a given object type, you should generally allow access to that data unless there is a good reason not to**. Why? Mostly because we really don't know what the client is going to need to do or what's going to be the most intuitive way to do something. It's relatively "inexpensive" to throw those relationships into our graph, whereas the back-and-forth with the front-end devs trying to determine exactly what they need access to and from where can get taxing, especially when it turns out there were relationships that were missed. This is even more important if you're building an API that's going to be external because then you&nbsp;_really_ don't know what they are going to need to be able to do.

Another good way to do this is to think about how you would logically draw out a relationship map with boxes/circles containing a single object type and lines to connect them. For example, our example might look something like this:

![]({{ site.baseurl }}/assets/images/2017/11/graphql-graph.jpeg)

_Tip: your GraphQL graph does not have to reflect your database tables. In fact, many times it won't. For example, generally speaking you don't want to have an object type for your join tables, unless they can be logically counted as their own individual entity that contains information other than foreign keys._

The next piece of this is to realize that relationships go both ways. So not only does a user have many comments, but a comment belongs to a user. What this means is that you should express that relationship on both the user type as well as the comment type. Go back to our graph above. Each line connects two objects/types. That means that each type should have a field pointing back to the type at the other end of the line.

Hopefully this strategy will help you make the transition from thinking in endpoints to thinking in graphs. If you found this helpful, please share it out so that other developers can have an easier transition into the world of GraphQL. Be sure to drop your thoughts in the comments below - I'd love to hear what you think and any strategies&nbsp;_you_ have for thinking in graphs!

