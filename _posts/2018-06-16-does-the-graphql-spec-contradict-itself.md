---
layout: post
title: Does the GraphQL Spec Contradict Itself?
date: 2018-06-16 20:50:49.000000000 -05:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories: []
tags: []
meta:
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _thumbnail_id: '456'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/06/16/does-the-graphql-spec-contradict-itself/"
---
![]({{ site.baseurl }}/assets/images/2018/06/ken-treloar-346065-unsplash-768x1024.jpg)

The other day, I saw an interesting question come up from someone who was new to GraphQL and reading the spec. It was one of those things that made me realize that it could be a point of confusion for many people who are not yet deeply familiar with GraphQL, and I thought it was worth outlining and addressing here.

## The Question

The question was about how queries and mutations are executed in GraphQL, and whether only one query can be executed at a time or both. According to the spec:

> Otherwise, if a GraphQL Document contains multiple operations, each operation must be named. When submitting a Document with multiple operations to a GraphQL service, the name of the desired operation to be executed must also be provided.

([source](http://facebook.github.io/graphql/June2018/#sec-Language.Document))

As the person asking the question pointed out, this seems to indicate that only one query can be executed since you have to provide the name of which one to execute. But then later on, the spec talks about executing multiple queries concurrently whereas mutations are executed serially ([source](http://facebook.github.io/graphql/June2018/#sec-Normal-and-Serial-Execution)). This seems to indicate the opposite - that multiple queries _can_ be executed at once.

The question basically comes down to the following:

- **Can you execute multiple queries in GraphQL at once?**
- **How can these two seemingly mutually-exclusive behaviors coexist?**

## My Answer

The quick and easy answer to that first question is: **yes, you can execute multiple queries in GraphQL at once**.

The quick answer to the next question is: **they're not really mutually-exclusive.** This one will require some explanation.

### Submitting Queries in GraphQL

To those unfamiliar with GraphQL and it's terminology, it may seem that these are talking about one thing, but they are actually separate things. The explanation for this starts with how you submit queries in GraphQL.

There are two different ways of submitting a query that are talked about. The quote above from the spec talks about "multiple operations" - these are "separate" queries so to speak and look something like this:

```
query AllPosts {
  posts { ... }
}
query PostsByUser {
  posts(userId: 123) { ... }
}
```

When submitting a GraphQL query in this manner, **only one of the queries will be executed**. You'll notice that I gave each of them a name (the part after `query` eg. `AllPosts`). This name is designated by the person writing the query; it can be whatever you want and is known as the "operation name". When submitting multiple operations this way, you must send the name of the operation that you want to execute to the server, so if I sent this query with the param `operationName` set to `AllPosts`, it would only run the `AllPosts` query and ignore the other. Likewise, setting `operationName` to `PostsByUser` would result in only running the `PostsByUser` query.

When you start talking about the queries executing concurrently vs mutations executing serially, it's talking about **sending multiple queries in a single operation** , which is _distinctly different_ from the above. These types of queries would look more like this:

```
query {
  posts: { ... }
  friends: { ... }
}
```

In this case, you're submitting **multiple queries in a single operation**. When this hits the server, it sees that you've got a single `query` operation, and it will execute `posts` and `friends` queries and return the results to you, which would happen concurrently. Doing the same thing with a mutation would result in executing serially since mutations have side-effects.

So really, this amounts to some confusion about terminology. The key word in all of this is "operation" - where an operation is a query, mutation, or subscription. Only one operation can be executed in a single request, and you must name them if you send more than one in a single document. Each operation can contain multiple _queries_ (except for subscriptions for the time being) which get executed together when sent to the server.

That about wraps up this post - I hope you learned something!

