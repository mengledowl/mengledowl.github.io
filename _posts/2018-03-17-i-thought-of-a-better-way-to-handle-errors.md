---
layout: post
title: I Thought of a Better Way to Handle Errors
date: 2018-03-17 14:54:54.000000000 -05:00
categories:
- Best Practices
- Opinion
tags: []
author: Matt Engledowl
permalink: "/2018/03/17/i-thought-of-a-better-way-to-handle-errors/"
---
A few weeks ago I wrote about [handling errors in GraphQL](/2018/02/24/handling-errors-in-graphql/). Shortly thereafter, I realized that I needed to post an update because I discovered both a flaw with the existing way of doing it and a better solution.

## Where We Left Off

To recap, we had talked about how it made sense to separate errors that the end-user cares about from those that the developer integrating with the API cares about. I made a case for putting these errors on the mutation object, and our end-result looked like this:

```
type User {
  id: ID
  email: String
  password: String
  name: String
  errors: [Error]
}
```

```
type Error {
  field
  message
}
```

This way, you can derive what field the error was for, what went wrong, and display that to the user however you see fit without having to do a lot of work to determine what type of error you're getting (type-system level vs validation level).

Something about this still seemed just a bit off to me, but it took a while to put my finger on it. The problem is that the `errors`&nbsp;field is on the `User`, which isn't quite right.

**A user doesn't have errors, errors occur on a mutation!**

The weirdness becomes more evident when you think about querying on a user when you're&nbsp;_not_ performing a mutation. Imagine this:

```
{
  currentUser {
    id
    name
    # wat
    errors {
      field
      message
    }
  }
}
```

Super weird, right? I'm able to ask for errors on the currently signed in user... during a normal query. That doesn't really make sense! Any time that you see something like this where you can ask for data that sometimes doesn't make semantic sense, you should re-evaluate how you're doing it. Which is exactly what we're going to do here!

## A Slight Iteration

So how can we get the errors separated from the `User`&nbsp;while still satisfying all of our other constraints and keeping it in the mutation payload? It actually turns out to be pretty simple. To solve this problem, we can change our mutation to return a special type specific to the mutation which will contain our errors and the result of the mutation. The end result would look something like this:

```
type CreateUserPayload {
  user: User
  errors: [Error]
}

type Mutation {
  createUser(...): CreateUserPayload!
}
```

And our query would follow this format:

```
mutation {
  createUser(...) {
    user: { ... }
    errors: { ... }
  }
}
```

This makes semantic sense - it gets our `errors`&nbsp;field out of the `User`&nbsp;type so that we're not able to get to it in places that don't make any sense, and moves it to a new type that is specific to the mutation we're performing. It makes sense for a `CreateUserPayload`&nbsp;to have errors on it!

_Full disclosure here: I didn't exactly come up with this iteration on my own. The design was bothering me a bit and then I came across this pattern in Shopify's GraphQL API and that's when it clicked for me._

## An Alternative Iteration

Now, there's&nbsp; **one more way of doing this** that I've been toying with, and I really like it as well. It's hard to say which I think is better at this point (I'd actually love to hear thoughts/opinions on this), but I wanted to go ahead and share both. The other way is to make `CreateUserPayload`&nbsp;a `union`&nbsp;type. If you're not familiar with unions in GraphQL, they're basically a way of specifying that a returned value can be one of multiple different types. Here's how this would look:

```
type OperationError {
  errors: [Error]
}

union CreateUserPayload = User | OperationError

type Mutation {
  createUser(...): CreateUserPayload!
}
```

This is pretty close to what we have above, with some slight differences. First of all, our `CreateUserPayload`&nbsp;is a `union`&nbsp;now between `User`&nbsp;and `OperationError`, meaning it could return&nbsp;_either_ a `User`&nbsp;_or_ an `OperationError`. This `OperationError` is new though - what's up with that?

In our prior example, we just had a list of `errors`&nbsp;in our `CreateUserPayload`, but you can only use object types in a union, and an array is not an object type. Meaning that in GraphQL, _this is impossible_:

```
union CreateUserPayload = User | [OperationError]
```

To get around this, we create a new type called `OperationError`&nbsp;that has a single `errors`&nbsp;field that has our array of errors. So then to query on this, we would do this:

```
mutation {
  createUser(...) {
    ...on User { ... }
    ...on OperationError {
      errors: { ... }
    }
  }
}
```

## Comparing Solutions

The first version is a bit more concise both in terms of it's implementation as well as when it comes to how you construct your queries. Where the union shines though is in the fact that it will only ever return one or the other, never both in the response. In contrast, the first method when being successful, still returns an `errors`&nbsp;key in the JSON, and vice-versa. You could also argue that the second could be a bit more semantic.

So what's the right answer? Both of them get the job done and allow quite a bit of flexibility for future changes to the API as new requirements and/or best practices emerge. I'm not sure either one appears to be a clear winner to me, and as with most things, I think the answer here might end up depending on the use-case. As I said in my original post on this, error handling is still somewhat up in the air in GraphQL land right now, and there's not necessarily a consensus on it just yet. Perhaps one day soon I'll be able to definitively say "here's the best way to handle errors", but for now I'll just say "I think either one of these are likely a good solution for most use-cases".

Let me know what you think of this latest iteration on how to handle errors! Which way do you prefer?

