---
layout: post
title: Schema Design != ...
date: 2018-04-07 19:03:49.000000000 -05:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Best Practices
- Opinion
tags: []
meta:
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _thumbnail_id: '392'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/04/07/schema-design/"
---
![]({{ site.baseurl }}/assets/images/2018/04/jose-aljovin-331066-unsplash-1024x726.jpg)

There are a few different ways that I've seen newcomers to GraphQL attempt to approach GraphQL schema design that are sub-optimal:

1. Using "endpoint style" rather than [thinking in graphs](https://graphqlme.com/2017/11/11/build-better-graphql-apis-thinking-in-graphs/)
2. Mapping their GraphQL schema directly to their database tables (foreign keys and all)
3. Mapping their GraphQL schema directly to their back-end data model (eg. your model classes from your ORM or the like)

I've already written a bit about the first one, so I won't rehash that here. The second is pretty similar to the first.

## GraphQL Schema != DB Schema

While it isn't "thinking in endpoints", it is still not quite thinking in graphs. In this pattern, you might see a schema with types that look something like this:

```
type User {
  id: ID
  name: String
  email: String
}

type Post {
  id: ID
  title: String
  body: String
  userId: ID
}

type Comment {
  id: ID
  body: String
  userId: ID
  postId: ID
}
```

... Etc.

At first glance to a newcomer, this might seem to make sense. This is pretty much identical to how you might set up your database tables, where you have foreign keys to reference the different records. I mean, after all, it's pretty easy to associate "GraphQL schema" to "database schema", and see types as "tables" and fields as "columns".

This isn't an optimal way to do this though for several reasons. First of all, it doesn't allow us to tie these things together in a single query to the database, which is a huge part of the benefit of GraphQL! For example, if on a user's profile page we want to show their name, posts, and comments on each post, we would need 3 separate requests to the server, with code to tie things together. So we end up with something like this:

```
{
  user(id: "123abc") {
    id
    name
  }
}

# some js code that runs that query, stores the information from it, and then uses that id to do the next query...

{
  posts(user_id: "123abc") {
    id
    title
    body
  }
}

# code to parse through the posts and grab the ids and pass those into the next query:

{
  comments(post_ids: [{array of ids, assuming you created this query with the ability to take an array}]) {
    id
    body
    postId
  }
}

# code to parse the comments and map them back to the posts from above
```

Wow, that's already a lot of work, and we haven't even discussed the fact that this isn't even everything you'd need to do - after all, you probably need to display the names of the users who posted each comment next to their comment... So more queries, and lots of code to tie things together!

This on it's own turns into a mess. There is more that can be said is wrong about it though: it's not a graph at all, and so doesn't represent the way a client might think about the data. This approach also forces the client to know&nbsp;_a lot of information_ about how the database works, not to mention forcing them to rehash this type of logic in every client that uses the API. So we have also lost the benefit of having common logic reside in one place on the server.

Alright, so let's say we fix the model above. We think about it in terms of a graph and the relationships between each item in the graph and come up with something like this:

```
type User {
  id: ID
  name: String
  email: String
  posts: [Posts]
}

type Post {
  id: ID
  title: String
  body: String
  user: User
  comments: [Comment]
}

type Comment {
  id: ID
  body: String
  user: User
  post: Post
}
```

Now look how easy our query becomes (and note that there is no extra code needed to map the pieces of data together!):

```
{
  user(id: "123abc") {
    id
    name
    posts {
      id
      title
      body
      comments: {
        id
        body
        user {
          id
          name
        }
      }
    }
  }
}
```

Boom, done, just like that. We now get everything we need to populate our page with a single query, a single round-trip to the server, and no extra code!

This probably reflects what you would expect your back-end data model to look like. If you use an ORM, this is almost certainly how it looks. So the next logical step is "this seems to work well for an ORM and it fixes the problems we had from mapping our schema directly to our database schema - what could be wrong with just mapping them together like this?"

## GraphQL Schema != Back-End Data Model

It's not yet clear where the problem lies with this line of thinking, but I hope I can communicate the issue clearly with another example. Let's say we now decide we need to expand our schema. We have added the ability for users to join different groups. In our database, we have a `groups`&nbsp;table that at least for now has two columns: `id`&nbsp;and `name`. Then we have a join table that maybe we called `users_groups`&nbsp;and it links to two together using `user_id`&nbsp;and `group_id`&nbsp;foreign key columns.

Now, we know based on the previous example that it's not really a great idea to model this directly in the database. Maybe our ORM allows us to express the relationships here using a `UserGroup`&nbsp;model that reflects a record in `users_groups`, and has associations to `user`&nbsp;and `group`, such that you could say `user_group.user`&nbsp;and `user_group.group`&nbsp;to get the related items. If we reflect this directly into our schema, we end up with something like this:

```
type User {
  id: ID
  name: String
  email: String
  posts: [Posts]
  user_groups: [UserGroup]
}

type UserGroup {
  user: User
  group: Group
}

type Group {
  id: ID
  name: String
  user_groups: [UserGroup]
}
```

On it's face, this might not seem so bad - I mean, it's still a graph, you can still get everything you need with a single query, and it's&nbsp;_fairly_ straightforward....

The problem here is, this&nbsp;_still forces the client to understand more about how the data is modeled than it should need to_. In this case, they have to know that a `UserGroup`&nbsp;basically joins a user to a group, but why should they need to do that? Really all they likely care about in this scenario is getting from a group to a list of it's users, or getting the groups that a user is part of. This can be expressed more succinctly and straightforward this way:

```
type User {
  id: ID
  name: String
  email: String
  posts: [Posts]
  groups: [Group]
}

type Group {
  id: ID
  name: String
  users: [User]
}
```

Much better - now the client doesn't need to know anything about the join, and as a special benefit, we have less types to worry about dealing with! The logic to get these pieces can be handled on the server-side and abstracted away from the client.

This may not seem like such a big deal in this somewhat less-than-ideal example, but I assure you that as you encounter increasingly complex back-end concepts that need to be expressed in your GraphQL API, this can have a much more drastic effect on your GraphQL schema and make it much easier to reason about and work with on the client-side.

## Designing Good Schemas Is Hard

These were fairly simple examples. Things tend to get a lot more complex than this and it won't always be so straightforward to see a good way to model something. The good thing is that designing schemas can be an iterative process and the more you understand your domain, your data, and your clients, the better your schema will become over time.

Some good questions to ask yourself as you iterate through your schema design to keep these concepts in mind:

- Is there a simpler way I can model this?
- Does the client really need to know that this exists?
- What is the likelihood that the client will need multiple queries to get the information they need, and can I model it so that it can be done in a single query?
- What complexity can I hide?
- What does this force the client-side to understand about our back-end data model?
- Might this schema require me to explain something about the back-end to client-side developers, and if so, can I change it so that it still gets them what they need without requiring an explanation?

These are not necessarily catch-all questions, but they should help keep you on the right track. The main point is to always be keeping in mind how your clients might be using this API. If you are designing an API, the client is your user, and you need to design for them. Keep it simple, flexible, and take things off their plate where you can.

