---
layout: post
title: How is GraphQL "Versionless"?
date: 2019-04-18 14:40:24.000000000 -05:00
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
  _aioseop_description: One of the touted advantages to using GraphQL is that it's
    "versionless" - but what does that mean and how is it possible?
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2019/04/18/how-is-graphql-versionless/"
---
<!-- wp:paragraph -->
One of the more underrated benefits of GraphQL that gets glossed over a bit I think is that **GraphQL is versionless**. It's one of those things that we don't really think about a whole lot - we sort of take it for granted that we have to version.

But what if we didn't?

The amount of time and energy that goes into this one single thing is astronomical. Consider all of the things that go into versioning a REST API which you must spend time on:

<!-- /wp:paragraph -->

<!-- wp:list -->

- Deciding **when to cut a new version**
- Deciding **what to include in the new version**
- Deciding **how long to maintain** the new version(s)
- **Actually maintaining** the old version(s)
- **Documenting the upgrade process** between versions
- **Performing the upgrades** themselves
- Fielding **bug reports that come down to a versioning issue** (eg. "you're on v2 - that feature was introduced in v3, so you'll have to upgrade")

<!-- /wp:list -->

<!-- wp:paragraph -->
That's a lot of time to spend on something that isn't directly pushing the product forward. The promise of GraphQL is that you don't have to worry about these concerns anymore and can instead focus on building and evolving your API, serving the client without fiddling with versions.

How is this possible though? What does it even mean to say that GraphQL is versionless?

To answer this question, I think it's important to look at why we version in the first place.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## Why We Version

<!-- /wp:heading -->

<!-- wp:paragraph -->
Let's say you've just built a new REST API and released your v1. You're quite proud of it - but being the initial release, there were a few things you had to rush through a bit in order to get it done and, well... let's just say that there are a few rough edges.

So now that you've hit your deadline and had a bit of a breather, you're able to start looking back at some of the rushed design decisions that had to be made. One in particular stands out to you - it's a particular endpoint that is used to retrieve data about a specific user:

GET /api/v1/users/:id

This endpoint returns a payload that, among other things, has a `role` field which returns.... an integer:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  "id": 123,
  "role": 1,
  ...
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
This was done hastily and relies on the underlying storage mechanism which stores the roles as integers, where `0` is "standard" and `1` is "admin". Looking at it again though, it's not really the best idea - I mean, an integer in this case isn't semantic at all. It would be better to display it as a string that just said "standard" or "admin".

The problem is that you obviously can't just change the return value of `role` to a string because this would break any clients that rely on that field.

This leaves you with two options.

**Option #1: Add a new field to the payload**

With this option, we simply come up with a new field with a different name that returns the data the way we want it (as a string) - we'll say we call it something like `namedRole`, making our payload look something like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  "id": 123,
  "role": 1,
  "namedRole": "admin",
  ...
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
This certainly works in that we now have a more semantic representation and we haven't broken any clients by changing `role` out from underneath them - but it comes with some problems.

For one thing, this is contributing to the problem of overfetching - receiving more data back from the server than we need. Not only that, but in this case, the problem is made more painful by the fact that we now have a redundancy issue here: we're sending the same data over the wire in the payload _twice_ without any real benefit to the client other than "semantics", which while important, may not be as important as keeping response times and payload sizes low.

**Option #2: We cut a new version**

So what's our other option?

In this case, we decide to create a new version, `v2`, which changes the returned value to be a string, so that our payload now looks like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  "id": 123,
  "role": "admin",
  ...
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
In this case, we haven't broken any clients, we haven't contributed to overfetching or needless redundancy, and we've made this field more semantic. But of course, this comes with all the costs of versioning that we discussed above.

<!-- /wp:paragraph -->

<!-- wp:heading -->

## What About GraphQL?

<!-- /wp:heading -->

<!-- wp:paragraph -->
So we've covered why it is that we version, but we still don't understand why it's just not relevant in GraphQL. Why is it that this isn't still an issue?

Let's go through the same example with GraphQL.

If you're not already familiar, GraphQL is all about types and fields - you create a type (which is like an object or a struct), specify fields on it, and then you can ask the GraphQL API for exactly what you want with a query, and get that and only that back.

So let's say we've created this API using GraphQL - we just got it released, but we've got a problem with our user type, which among other things allows us to retrieve a `role` field that returns an integer - just like our REST example:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
type User {
  id: ID!
  role: Int!
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
So our client(s) might have a query that looks something like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  user(id: 123) {
    id
    role
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
And the resulting response would be:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  "user": {
    "id": 123,
    "role": 1
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
Again, we take a look at this and decide it's not very semantic and that `role` really should just be a string. Of course, we still can't just change the `role` field out from under the client, because it would break them.

Interestingly enough, what we can do is go with **option 1 from our REST example**. Let's go through that so we can see why.

To do this, we simply add a new field to our `User` type - `namedRole`:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
type User {
  id: ID!
  role: Int!
  namedRole: String!
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
Much like the REST example, we haven't broken the client, but what's more interesting is that we also have not gotten the downsides - namely **nothing has been added to the payload** since you only get what you ask for, and the client is still only asking for our original `role` field. On the client-side, the query is still the same, and so the response is still the same. Now once the client is ready, they can update their query to ask for only the new field:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  user(id: 123) {
    id
    namedRole
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
And get only that information back:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  "user": {
    "id": 123,
    "namedRole": "admin"
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
Finally, you can deprecate the old field to let the client-side developers know that it should not be used:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
type User {
  id: ID!
  role: Int! @deprecated(reason: "Use `namedRole`")
  namedRole: String!
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
This will also ensure that it does not show up in tooling such as GraphiQL.

So there you have it! This is how GraphQL provides a way to evolve your API without needing to version it, saving you lots of precious time and energy to do more important things.

Bonus: if you're more familiar with GraphQL, you probably will notice that `namedRole` is actually a great use-case for an enum :D
<!-- /wp:paragraph -->

