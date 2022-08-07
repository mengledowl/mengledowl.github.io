---
layout: post
title: 'Namespaced GraphQL Mutations: It''s A Trap'
date: 2020-07-09 21:40:50.000000000 -05:00
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
  _thumbnail_id: '636'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2020/07/09/namespaced-graphql-mutations-its-a-trap/"
---

![]({{ site.baseurl }}/assets/images/2020/07/itsatrap.jpg)

<!-- /wp:image -->

<!-- wp:paragraph -->
It was probably a couple of years ago now that I first heard the idea. A random blog post that I stumbled across; someone who was new to GraphQL and had a wild idea that they were exploring.

The idea? **Namespacing your mutations.**

Since then, I've seen it touted as a "good idea" and even a "best practice". In reality, the approach is problematic and dangerous.

Before we get into that though, let's back up a bit.
<!-- /wp:paragraph -->

<!-- wp:heading -->

## The Problem

<!-- /wp:heading -->

<!-- wp:paragraph -->
Some people find that by the time you've got a few dozen mutations in your schema, they can start to feel unwieldy. Current tooling doesn't allow for a simple way to group your mutations, so a large list of them can make it difficult to see what sort of operations you can perform on a given resource (eg. `add`, `delete`, `promote`, `hide`, `like`, etc).

To solve this, many people resort to a `nounVerb` naming schema, but this has it's problems. For one thing, it feels unnatural to many people; `postAdd` just doesn't read as well as `addPost`. On top of that, this really only groups things in the sense that it puts them next to each other in the list since the fields are listed alphabetically.
<!-- /wp:paragraph -->

<!-- wp:heading -->

## The Proposed Solution

<!-- /wp:heading -->

<!-- wp:paragraph -->
Another solution that many have proposed and adopted, and the subject of this article, is to **namespace** your mutations.

Here's how a mutation might look using this solution:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
mutation {
  article {
    publish(id: "123") {
      status
    }
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
The SDL might look something like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
type ArticleActions {
  publish(id: ID!): Article!
}

type Article {
  id: ID!
  # etc.
}

type Mutation {
  article: ArticleActions!
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
At first glance this might _seem_ like a good idea. It feels more organized. There's a hierarchy/namespace for grouping actions. It sorta feels like calling functions on an object (`article { publish }` feels very similar to `article.publish`). Of course, there's a problem...
<!-- /wp:paragraph -->

<!-- wp:heading -->

## Queries and Mutations Don't Follow the Same Execution Pattern

<!-- /wp:heading -->

<!-- wp:paragraph -->
Many people aren't aware that queries and mutations are more than just _semantically_ different - they're actually different in how they are executed.

First, let's take a look at how queries are executed by GraphQL servers. According to the spec, `ExecuteQuery` is expected to behave like so:
<!-- /wp:paragraph -->

<!-- wp:quote -->

> 1. Let <var>queryType</var> be the root Query type in <var>schema</var>.
> 2. Assert: <var>queryType</var> is an Object type.
> 3. Let <var>selectionSet</var> be the top level Selection Set in <var>query</var>.
> 4. Let <var>data</var> be the result of running [ExecuteSelectionSet](https://spec.graphql.org/June2018/#ExecuteSelectionSet())(<var>selectionSet</var>, <var>queryType</var>, <var>initialValue</var>, <var>variableValues</var>) _normally_ (allowing parallelization).
> 5. Let <var>errors</var> be any _field errors_ produced while executing the selection set.
> 6. Return an unordered map containing <var>data</var> and <var>errors</var>.<cite><a href="https://spec.graphql.org/June2018/#sec-Query" target="_blank" rel="noreferrer noopener">https://spec.graphql.org/June2018/#sec-Query</a></cite>

<!-- /wp:quote -->

<!-- wp:paragraph -->

You can ignore pretty much everything except for #4 - this is the key step. This is where it notes that we run ExecuteSelectionSet in the "normal" way that **allows parallelization**. What does that mean exactly? It means that when we query for fields, they are **not** expected to be executed in any kind of order. In other words, if I have a query:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  post { ... }
  article { ... }
  comment { ... }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
The execution engine should be able to execute all the selections in parallel, so that execution could be completed in any order. (Note: from my reading, this is not a _required_ behavior, but it is something that, especially as a client, you should absolutely expect as a _possibility_ - this is important).

Now let's take a look at how mutations work. `ExecuteMutation` is expected to behave like so:
<!-- /wp:paragraph -->

<!-- wp:quote -->

> 1. Let <var>mutationType</var> be the root Mutation type in <var>schema</var>.
> 2. Assert: <var>mutationType</var> is an Object type.
> 3. Let <var>selectionSet</var> be the top level Selection Set in <var>mutation</var>.
> 4. Let <var>data</var> be the result of running [ExecuteSelectionSet](https://spec.graphql.org/June2018/#ExecuteSelectionSet())(<var>selectionSet</var>, <var>mutationType</var>, <var>initialValue</var>, <var>variableValues</var>) _serially_.
> 5. Let <var>errors</var> be any _field errors_ produced while executing the selection set.
> 6. Return an unordered map containing <var>data</var> and <var>errors</var>.
>
> <cite><a href="https://spec.graphql.org/June2018/#sec-Mutation" target="_blank" rel="noreferrer noopener">https://spec.graphql.org/June2018/#sec-Mutation</a></cite>

<!-- /wp:quote -->

<!-- wp:paragraph -->

Again, the important one is #4. Compare it to #4 for queries.

Do you see the difference? Let's take a look at the preceding two paragraphs, which may make it a bit more clear:
<!-- /wp:paragraph -->

<!-- wp:quote -->

> If the operation is a mutation, the result of the operation is the result of executing the mutation’s top level selection set on the mutation root object type. This selection set should be executed serially.
>
> It is expected that the top level fields in a mutation operation perform side‐effects on the underlying data system. Serial execution of the provided mutations ensures against race conditions during these side‐effects.
>
> <cite><a href="https://spec.graphql.org/June2018/#sec-Mutation" target="_blank" rel="noreferrer noopener">https://spec.graphql.org/June2018/#sec-Mutation</a></cite>

<!-- /wp:quote -->

<!-- wp:paragraph -->

The two call-outs here are "This selection set should be executed **serially**." (emphasis mine) and "Serial execution of the provided mutations ensures against race conditions".

In case that's not quite clear enough, here's the difference:

**Queries** can be executed in any order.

**Mutations** _must_ be executed in the order they appear in the document.

That means that for the query:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
{
  field1
  field2
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
It's possible for the query to complete execution of either `field1` followed by `field2` _or_ `field2` followed by `field1`. On the other hand, given the following mutation selection set:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
mutation {
  mutation1 { ... }
  mutation2 { ... }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
The server will **always** execute `mutation1` followed by `mutation2` - following the order they are declared in. This is because mutations have _side-effects_. That means that mutations could technically have an impact on each other. Executing them in order ensures that:
<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->

1. The end result of running the mutations is predictable
2. There are no possible race conditions

<!-- /wp:list -->

<!-- wp:paragraph -->
An example may help here. Say we've got two mutations: one for `likePost` and another for `unlikePost`. Given a document that looks like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
mutation {
  likePost(id: 1)
  unlikePost(id: 1)
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
Since selections on the mutation root object type are executed serially, we know that after executing this document, the post with an ID of 1 will be unliked. The server would first execute `likePost` so that the post would be liked, and then it would execute `unlikePost` so that it would be unliked by the end of execution.

So, what does all of this have to do with namespacing? Well, as it turns out, **everything.**

Remember what our namespaced query looks like? Let's take another look:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
mutation {
  article {
    publish(id: "123") {
      status
    }
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
Notice what's happening here. We are making a selection starting at the `mutation` root. The selection we make at the `mutation` root is `article`. This is the level that executes serially, but we're not actually _doing_ anything at that level in this example. Instead, the side-effect happens in the sub-selection on `article` - namely `publish`.

The problem is that the serial execution **only applies to selections on the root mutation type**. `article` is at the root of `mutation`. `publish` is _not_. Meaning that if we had something like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
mutation {
  article {
    publish(id: "123") { status }
    unpublish(id: "123") { status }
  }
}
```

<!-- /wp:code -->

<!-- wp:paragraph -->
We have no way to determine what the status of article 123 is after this document gets executed. Is it published or unpublished? No way to know, because publish and unpublish are not expected to execute serially.

This is a **serious flaw** , and is the primary reason why I would never recommend this approach.

Even if you're using a server where you know that all fields are being executed serially (not just mutations) I still wouldn't recommend this approach because it flies in the face of the spec. Why? Because it means that _clients can no longer rely on an understanding of the spec to tell them how the server will behave_.

Even if the library or server you use is executing everything in serial today, who's to say that it won't change in the future? The spec allows for all selections - except for root-level mutation selections - to be executed in parallel, so the library would not be diverging from the spec by making that change. In fact, they would probably want to make that change because then they would be getting the benefits of parallelism.
<!-- /wp:paragraph -->

<!-- wp:heading -->

## What Are The Alternatives?

<!-- /wp:heading -->

<!-- wp:paragraph -->
We already talked about one of the alternatives, which is to **name mutations in the pattern of `nounVerb`** , which as we discussed earlier, has its limitations.

It's also possible to get a list of possible mutations for a given resource by **searching for the name of that resource in GraphiQL** (or whatever you use). This has it's own limitations of course, the biggest of which is that there's no way to search _just_ mutations. Couple that with a large GraphQL API, which is when people normally start wanting a way to group related mutations together, and you've got a pretty long list of items coming back and the majority of them may not even be mutations.

I'd also argue that this is a good use-case for **documentation**.

"Wait, isn't GraphQL self-documenting?"

Yes. Ish.

GraphQL "documents" itself in that it gives us the object graph with relationships, types, and (optional) descriptions of the different fields, types, etc., but this is a very narrow view of what constitutes documentation. I'd argue that this is where you should probably start if you're looking to make it more clear what mutations are possible on a given type/object. How this looks in practice is going to differ from company to company and team to team.

At this point I'm going to get into a couple of ideas that I've never actually messed with or seen implemented, so it's a bit of uncharted territory, but stick with me.
<!-- /wp:paragraph -->

<!-- wp:heading -->

## Into the Great Unknown

<!-- /wp:heading -->

<!-- wp:paragraph -->
The first idea I want to discuss is actually one I got from Marc-André's fantastic book "[Production Ready GraphQL](https://book.productionreadygraphql.com/)".

_Quick aside: If you haven't read Marc-André's book and you're serious about GraphQL, do yourself a favor and pick it up. It's a very thorough and well thought-out resource for designing and implementing GraphQL APIs._

In the book, he puts forth the idea of **using a custom directive `@tags` to "tag" fields based on what they are mutating**. The example he gives looks like this:
<!-- /wp:paragraph -->

<!-- wp:code -->

```
type Mutation {
  createProduct(...):
    CreateProductPayload @tags(names: ["product"])

  createShop(...):
    CreateShopPayload @tags(names: ["shop"])

  addImageToProduct(...):
    AddImageToProductPayload @tags(names: ["product"])
}
```

<!-- /wp:code -->

<!-- wp:paragraph {"fontSize":"small"} -->

_Source: "Production Ready GraphQL" by Marc-André Giroux_

<!-- /wp:paragraph -->

<!-- wp:paragraph -->
I like this for a few reasons:
<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->

1. It's very direct and clear
2. It can be re-used for other things besides just tagging mutations
3. You can easily associate a mutation with multiple different types (eg. `["cart", "product"]`

<!-- /wp:list -->

<!-- wp:paragraph -->
The idea here would be that you would want to have tooling that could somehow expose these tags, allowing you to group the mutations by the tags. Of course, no such tooling currently exists - if you wanted to implement something like this, you'd have to write the tooling yourself.

My mind jumps immediately to expanding tooling that allows you to generate documentation based on your schema so that it could understand this custom `@tags` directive and provide groupings for each. The hardest part of this would be building it, and there would still be the limitation that **you wouldn't be able to retrieve this information from introspection**. This may or may not be problematic for you - it depends on your use-case.

That leads me to my second thought, which _could_ be better, but much more involved: adding a concept of **introspect-able metadata** to the spec. This is actually something [that was proposed back in 2017](https://github.com/graphql/graphql-spec/issues/300) and is still in the beginning stages of proposal, having never gotten off the ground. Hence the reason it would be so much more involved - RFCs don't tend to move very quickly in the GraphQL spec.

In any case, this solution _would_ allow you to set some metadata that could be introspected and then extend a tool like GraphiQL to take advantage of this metadata, allowing you to list out the operations you can perform on a given resource. Given the length of time this RFC has spent in the first stage and the depth of the discussion around it, it's not very straightforward and the current ideas for it have not been convincing enough. Time will tell if it goes anywhere.
<!-- /wp:paragraph -->

<!-- wp:heading -->

## Final Thoughts

<!-- /wp:heading -->

<!-- wp:paragraph -->
We covered a lot of information in this blog post, so if you made it this far, thanks for sticking with me! To sum it up more succinctly:
<!-- /wp:paragraph -->

<!-- wp:list -->

- GraphQL has **no mechanism to group related mutations together**
- One popular way of grouping them is " **namespacing**"
- This form of namespacing is problematic because it means that **mutations would no longer be being run in serial, opening the door to race conditions and unpredictability**
- **There are a few alternatives, each with its own drawbacks** , including naming patterns and utilizing the search function in GraphiQL
- A couple of **other possible solutions exist which require quite a bit more work** , and which I haven't actually seen in action (or haven't been approved to become part of the spec)

<!-- /wp:list -->

<!-- wp:paragraph -->
One final closing thought: if the spec ever changes to where this pattern would be possible _without_ these kinds of problems manifesting, I'd be happy to revisit this. It's not the pattern that I'm against, but the current consequences of implementing it, due to how the spec defines mutation behavior.

Do you have any alternative methods of handling this? Do you disagree with my assessment? Is there something I missed? Drop me a note - I'd love to hear from you!
<!-- /wp:paragraph -->

