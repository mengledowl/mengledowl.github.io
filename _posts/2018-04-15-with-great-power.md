---
layout: post
title: With Great Power...
date: 2018-04-15 17:22:18.000000000 -05:00
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
author: Matt Engledowl
permalink: "/2018/04/15/with-great-power/"
---
... comes great responsibility.

These words are often quoted in reference to some situation where a person in power could easily cause severe consequences by misusing their power. So how does this relate to GraphQL?

It's amazing the kind of power that you can coax out of GraphQL. The [benefits](/2017/12/17/benefits-of-graphql-on-the-backend/) are quite impressive and [extensive](/2017/10/15/5-things-love-graphql/), and the [type system](/2017/12/31/stop-fighting-the-type-system/) alone can work wonders for your API.

The way that GraphQL exposes your data as a graph makes it easy to navigate that data, and especially if you have an ORM on the back-end that is powering your data and relationships from that front, it can be tempting to try to build something that can automatically build your GraphQL API based on that ORM or your underlying data access modules.

For example, if you're familiar with rails, you know that ActiveRecord makes accessing and managing the data in your database very straightforward and provides a nice API. Here are some examples of what you can do with it:

```
Post.all # => returns a list of all posts
Post.first(10) # => returns the first 10 posts

post = Post.first
post.user # => returns the user who created the post
post.body # => the body of the post

Post.where(category: 'News').order_by(:title) # => retrieves all posts in the news category, ordered by the title

user = User.first
user.posts.where(published: true).offset(5) # => get posts by the user that have been published, skipping the first 5
```

This can make it easy to start wondering - what if I just wrote some code that would expose this more directly? I mean after all, the GraphQL API will likely closely resemble this model. It would make things move a lot more quickly if we just had some code that looked at all of our (in this case) ActiveRecord classes, built types for them based on the columns and fields within them, modeled the relationships correctly, and created queries and mutations for us.

For example, assuming we had a `Post`&nbsp;class that had a `title`, `body`, and `created_at`&nbsp;fields with a `user`&nbsp;relationship where `User`&nbsp;has a `first_name`, `last_name`, and `email`, it would generate the following automagically:

```
type Post {
  title: String
  body: String
  createdAt: DateTime
  user: User
}

type User {
  first_name: String
  last_name: String
  email: String
  posts: [Post]
}

query {
  posts: [Post]
  users: [User]
}

mutation {
  postCreate(input: PostCreateInput!): Post
  postUpdate(input: PostUpdateInput!): Post
  postDelete(id: ID!): Post
  userCreate(input: UserCreateInput!): User
  userUpdate(input: UserUpdateInput!): User
  userDelete(id: ID!): User
}
```

Along with resolvers for each to handle everything for us. I mean, cool right?

Perhaps, but this also&nbsp;poses several problems:

1. It's easy to over-expose queries/mutations
2. It exposes all fields, relationships, and classes/types by default
3. It tightly couples your GraphQL schema to your underlying data model, [which should not always match each other](/2018/04/07/schema-design/)

The first two are really essentially the same problem, which is that **it's easy to accidentally expose more than you meant to**.

Imagine that you create a new class that is backed by your ORM that you never intended to be exposed in your API, or that you added a new field that shouldn't be accessible from the API. Suddenly, your code that was supposed to make your life easier is exposing your `SuperSecretAdminData`&nbsp;and allowing mutations against it. Changing your code to allow opting out isn't quite enough, because it would still be too easy to forget to tell it not to expose something and end up with a big mess on your hands. Even making it "opt-in" only where you would have to specify each class, field, query, and mutation that you want to expose can be problematic because of the complexity that adds. Not to mention that at this point you're probably writing close to the same amount of code that would have been required without your magically generated schema. And this doesn't even take into consideration that you would likely need to be able to override your resolvers at some point to customize how they work.

In any case, let's say you're okay with all of this complexity and you figure out a good way to manage it, thus taking care of numbers 1 and 2. Number 3 is still not something you're going to get away from - at least, not easily.

I've already written about #3 so I won't rehash it here. What it boils down to is that you don't necessarily want your data model to always match your back-end data-model 1:1. With this solution, you would have a hard time building things in such a way that you could easily create further abstractions without losing the benefits you were hoping to gain in the first place - which was (arguably) less code and quicker implementation.

Now _this isn't to say that I necessarily disagree with building a system like this_ - **I'm simply urging extreme caution here**.

Personally, I wouldn't write this kind of code myself. If we were talking about reliable libraries that did a lot of this for me and didn't leave me with a GraphQL API that was tightly coupled to anything, that's a different story entirely (for example, tools like Prisma seem like they are doing a lot of good work in this realm). My point is that this is dangerous territory and can easily lead to a place where you're doing things that you don't mean to. Time savings in the beginning could lead to an incredible amount of complexity in the long-run or even exposing sensitive information accidentally.

And no one wants that.

Do you have any thoughts on this? I'd love to hear them!

