---
layout: post
title: Beware of Complex Filtering in GraphQL
date: 2018-05-05 19:06:35.000000000 -05:00
categories:
- Best Practices
- Opinion
tags: []
author: Matt Engledowl
permalink: "/2018/05/05/beware-of-complex-filtering-in-graphql/"
---
![]({{ site.baseurl }}/assets/images/2018/05/john-carlisle-539580-unsplash-1024x683.jpg)

When something [new and powerful](/2018/04/15/with-great-power/) that enables a different paradigm for working with and seeing something, people can sometimes take it to far and go overboard with it. This can be seen clearly in adoption of new technologies, as well as new programming patterns. I know I sometimes have a habit of learning some new design pattern and then seeing and using it everywhere, only to come back 6 months or a year later and think "yeah, I was really into doing that back then, but there was probably a better way to do it."

Of course, GraphQL is no exception to this. And there's one thing in particular that I see many trying to reach for that has been gnawing away at me.

##

## Complex Filtering

So what exactly do I mean when I say "complex" filtering? I'm talking about this idea of being able to submit a GraphQL query that can enable you to do very complicated filtering patterns. Imagine a query that looks something like this:

```
{
  posts(where: {
    and: {
      authorId: 1,
      gt: {
        or: {
          commentCount: 10,
          likeCount: 20
        }
      }
    }
  }) {
    # ...
  }
}
```

The idea is to expose an ORM-like query-ability through your GraphQL API where you can have extreme flexibility on the client-side to ask for complex pieces of data. The above query for example would ask for posts by a specific user that has gotten more than 10 comments or more than 20 likes.

At first glance this may seem like a good idea, and in some certain situations I would agree that it might be useful, but those situations are very limited. In fact, there's only one circumstance that I can think of where it might make sense, and that's as an **actual ORM over a database that is accessible from the server only.**

This may seem like an overly strong opinion, but there are good reasons for it.

For one thing, **this opens up the API a lot to where you really don't know what kind of query someone might craft**. You can start to see how quickly someone could craft a really complex query, and it's hard to determine on the server at runtime how expensive the resulting SQL query might be. Someone could pretty easily send a query that could cripple your database/server, accidental or otherwise.

This kind of thing would also be difficult to build by hand, and I can imagine authorization becoming a bit of a nightmare with this sort of thing - where normally a query against `posts`&nbsp;could add a `where`&nbsp;clause behind the scenes on the server-side that filters out anything that the user doesn't have access to, it gets a bit harder when you've opened up such complicated querying capabilities.

Even if you could somehow mitigate these concerns, there's still the fact that this pushes the complexity and the responsibilities that should be on the server/API down to the client. The client is now responsible for creating these queries, which can quickly become verbose, and it's no longer clear what the API can do. To me, this is almost as bad as using RESTful architecture to send a string to the server telling it what query to execute like "/posts?where='user\_id = 1 and comment\_count \> 10'" - maybe not as dangerous, but just as complex and useless for the client. The whole point of the API is to abstract this level of detail away from the client, and I think it completely misses the mark of what makes GraphQL so powerful to start to do this.

Not to mention the fact that with these kinds of queries, you no longer have that business logic living in a shared place. If you need the same data on your mobile app now as you displayed in your web app, you have to write the query twice instead of once.

## What To Do Instead

Make your queries specific to the problem you're attempting to solve. What problem is the query we crafted above actually attempting to solve? If I had to put it into a sentence, I would say: "it retrieves a user's popular posts". Here's how that might look in practice:

```
type Query {
  popularPostsByUser(userId: ID!): [Post!]!
}
```

And now our actual query gets much simpler and more straightforward:

```
{
  popularPostsByUser(userId: 1) {
    # ...
  }
}
```

I mean holy shit, isn't that a lot nicer? It also states&nbsp;_exactly what it is we're trying to accomplish_ and it&nbsp;_tells a story_. We want to see this user's popular posts. The implementation isn't important, the server handles that.

Not only that, but **we can even change what it means to have a post be popular very easily in this case**. Hell, we could even move it outside of being a "simple" SQL query to using some more complex data analytics to find posts that are popular relative to the user's other posts, maybe something that doesn't even hit our SQL database at all. So not only has our query gotten simpler and clearer, but we actually made our code much more robust and flexible, as shown by that example.

## In Closing

I want to reiterate that there can be times where having some complex filtering system like that makes sense, but I think it's incredibly rare and pretty well cordoned off to a specific use-case. If you find yourself wanting to expose this sort of functionality to the client, I would strongly encourage you to rethink it. I have a sneaking suspicion that it might come back to bite you.

