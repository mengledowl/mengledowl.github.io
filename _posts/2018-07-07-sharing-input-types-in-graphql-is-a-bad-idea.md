---
layout: post
title: Sharing Input Types in GraphQL is a Bad Idea
date: 2018-07-07 13:41:22.000000000 -05:00
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
  _thumbnail_id: '483'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/07/07/sharing-input-types-in-graphql-is-a-bad-idea/"
---
![]({{ site.baseurl }}/assets/images/2018/07/greta-pichetti-713479-unsplash-768x1024.jpg)

I don't tend to think it's a good idea to share input types between different mutations.

"But wait," you might say, "that seems like it would be helpful in reducing boilerplate between create/update variations that are identical - why would it be a bad idea?"

**I'm so glad you asked.**

The main reason for this is because **sharing input types between fields makes schema evolution more difficult**.&nbsp;It can present the need for either **breaking changes to your schema** or else **compromising on schema design** , both of which should be avoided as much as possible.

This is probably best shown with an example.

Imagine that we had an input type:

```
input UserDetailsInput {
  email: String
  name: String
  # etc.
}
```

This input type is used for two mutations:

```
type mutation {
  userUpdate(input: UserDetailsInput!): User
  adminUpdate(input: UserDetailsInput!): Admin
}
```

At first, all seems great, but then one day a new business requirement comes up: an&nbsp;`Admin`&nbsp;now has a new attribute called `publicEmail`&nbsp;to allow admins to have a different email exposed to the user-base besides their private one for people to use to contact them. Suddenly, we've got a new argument that you need to be able to pass into `adminUpdate`, but&nbsp; **not** `userUpdate`.

The problem is: you're using the same input type for both! What are you supposed to do?

The way I see it, you've got a few options:

- Create a new input type that you use for `adminUpdate`&nbsp;instead of `UserDetailsInput`&nbsp;- **this is a breaking change** which requires a lot of coordination work with any clients using your API
- Create a new argument outside of the input type for `adminUpdate`, eg. something like: `adminUpdate(input: UserDetailsInput, publicEmail: String)`&nbsp;- **this is quite awkward and can quickly turn into a mess** if you keep needing to add new arguments
- Create a new input type that you use in&nbsp;_addition_ to the original input type: `adminUpdate(input: UserDetailsInput, adminInput: AdminDetailsInput:)`&nbsp;- **this is also awkward** in my opinion, though less messy than the previous option
- Add the argument to the `UserDetailsInput`, ignoring the fact that this argument makes no sense in the context of `userUpdate`&nbsp;- **this is by far the worst option** , as it is not semantic and requires the API consumer to know somehow that this argument only holds meaning in the context of&nbsp;_one of the mutations_&nbsp;that it can be passed to rather than utilizing the type system to communicate this fact

All of these options are pretty bad in my opinion.&nbsp;As a result, I tend to avoid sharing input types unless I have a _very compelling reason_ to do it. On the other hand, if you started out with separate input types for each mutation, there would be no problem to solve - you simply add your argument to the input type for the `adminUpdate`&nbsp;field.

This also leads me to another pattern that might seem curious without the previous context: **my input types follow a naming pattern that matches the mutation they were created for**. This makes naming input types really easy, and creates a clear pattern.

All of that being said, it's not a hard and fast rule for me. There could be cases where it would make sense to share input types, though I have so far not run into any that were compelling enough to make me do it, especially considering that thus far I have seen no downsides to just duplicating the arguments across input types and just handling duplication as needed on the server-side instead.

