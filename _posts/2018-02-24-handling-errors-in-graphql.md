---
layout: post
title: Handling Errors in GraphQL
date: 2018-02-24 22:34:45.000000000 -06:00
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
  _thumbnail_id: '347'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/02/24/handling-errors-in-graphql/"
---
![]({{ site.baseurl }}/assets/images/2018/02/HNCK2423-1024x684.jpg)

If you work in software, you'll inevitably have to deal with errors at some point. As hard as we try to make our code bulletproof, our systems fault tolerant, and our user interfaces crystal clear, there will be problems.

Code won't work as intended.

Systems will fail.

Users will get confused and do something unexpected.

And when those things happen, our software should be robust enough to handle it. Displaying helpful error details is an important task for any developer. The user needs to know what went wrong so they can fix it, and the same can be said for developers.

Errors are a hot topic right now in GraphQL. One of the most common questions I see is from people wondering how they should handle returning errors from the server. People have given talks on error handling. Heck, it even came up as a point of discussion during [the last working group meeting](https://github.com/graphql/graphql-wg/blob/master/notes/2018-02-01.md#discuss-errors). I have my own opinions on how to handle errors, which I'll share here. This is not necessarily anything new, but I've heard so many people ask the question that I thought I would put pen to paper (fingers to keyboard?) and outline exactly where I stand on this topic.

**This comes with a caveat** : as the notes from the working group meeting indicate, there are lots of different needs when it comes to errors. What works for one company may not necessarily work well for another. With that being said, I want to share a formula that I think makes _the most sense for a large majority of use-cases_ from both a flexibility and simplicity perspective.

One more thing that I should add: the kind of errors that I'm going to be talking about here are those related to _validation errors occurring during a mutation_ - eg. “email already taken”, etc. There are [other types of errors](/2017/12/31/stop-fighting-the-type-system/) that I don't plan to address (type errors which are handled automatically, and application errors, for example).

## An Example

Before we dive too far in, let's define an example for us to work off of. Say we have a User type:

```
type User {
  id: ID
  email: String
  password: String
  name: String
}
```

And then a mutation for creating a new user:

```
type Mutation {
  createUser(email: String!, password: String!, name: String): User
}
```

In our server code, we specify some validations on our user:

- Email must match a certain format
- Email must be unique
- Password must be at least 6 characters long

If any of these are not met, the mutation should fail and return enough information to the client that they can adequately communicate the problem to the user.

## Returning Usable Errors

The first thing to consider here is: _where should these error messages live_?

When you get a type error in GraphQL (eg. if you try to pass in a string where your argument expected an integer), you get back an `errors` key which has a bunch of information about the error and where it occurred.

Is this where our validation errors belong?

There are a few problems with putting our errors there.

For one thing, it now gets intermingled with errors output from the type system in GraphQL, which feels wrong to me. In addition, if we were to follow that format, then we have to provide a path to which mutation the error occurred in, which can be difficult to achieve, not to mention difficult for the front-end to parse! Finally, it distances our error details from the mutation that caused it.

Remember too that you can perform many mutations in a single query/request, and if one fails, execution continues for all the remaining queries. This means that the first mutation could fail and we would see the execution continue on to the next two which could conceivably pass. If we dump our errors in the root `errors` key, it becomes sticky trying to determine if we got a type error (which the developer needs to fix) or a validation error, and whether or not everything failed or just _certain_ things failed.

So where should the errors be returned then?

**I would assert that the correct place for validation errors is on the type itself.**

Returning to our example:

```
type User {
  id: ID
  email: String
  password: String
  name: String
  errors: ?
}
```

I've left the return type blank for now, we'll come back to that.

What exactly does this accomplish, and why is it preferable? For one thing, it keeps the errors close to the item that they occurred on. If the mutation fails, the client just has to check the errors field on that specific mutation to see what the problem was. This makes for much easier parsing on the client side. It also works nicely when you consider multiple mutations in a single request, as you can easily determine which mutations failed and which were successful.

## Error Type

Let's go back to that question mark. What exactly should our errors field contain?

My first go around with this, I simply made it a list of strings, each one containing an errors message:

```
type User {
  id: ID
  email: String
  password: String
  name: String
  errors: [String]
}
```

So our response from an error might look something like this:

```
{
  “createUser”: {
    ...
    “errors”: [
      “email must contain an ‘@’ symbol”,
      “password must be at least 6 characters"
    ]
  }
}
```

Now, for simple use cases, this might work just fine. If all you need to do is display a message, then just returning an array of strings probably works great. Generally we want more out of our UI though. Most forms these days will do things like highlight the email and password fields in red, and tell you what the error was directly adjacent to the field it occurred on.

How do you do that when all you have is an array of strings?

Sure, you could parse each string and pull out the first word which will give you the field... but that's pretty risky and brittle. What if the error message format changed to “you must create a longer passphrase”? Suddenly, you can't match on “password” anymore because that word is not only no longer at the beginning of the string, it's not in there at all!

Instead, I believe the better solution (and what I've settled on), is to have the errors field be an array of `Error` types, where `Error` looks like this:

```
type Error {
  field
  message
}
```

This way, we can reliably determine which field our error occurred on! Take a look at our response now:

```
{
  “createUser”: {
    ...
    “errors”: [
      {
        “field”: “email”,
        “message”: “email must contain an ‘@’ symbol”
      },
      {
        “field”: “password”,
        “message”: “password must be at least 6 characters”
      }
    ]
  }
}
```

Now when we look at the errors field, we can see an array containing the name of each field that had an error, and what the error message was. This is much safer and more flexible as we can now add additional fields to our `Error` type in the future if needed without having to create a new `errors` field on the mutation!

Another thing you can add to the type you're performing your mutation on (`User`&nbsp;in this example) is a `successful`&nbsp;boolean to indicate whether or not the mutation was successful. This comes down to taste to some degree as this can be inferred based on whether or not `errors`&nbsp;is empty/null, but I like to add it as an option for the client/front-end to use if it makes their lives easier.

## Drawbacks

Of course, this is an imperfect solution. Everything has it's strong points and it's weak ones. Outside of the aforementioned fact that this solution won't work for everyone, there's one other issue that I see with this:

The client has to remember to check the `errors`&nbsp;field.

This can be especially problematic when performing an update mutation, or any other kind of mutation where the other fields might end up coming back with data in them. For example, imagine that we also had an `updateUser`&nbsp;mutation and we passed in some bad data that should trigger an error:

```
mutation {
  updateUser(email: "invalid") {
    name
  }
}
```

We forgot to ask for our `errors`&nbsp;field here! Since every request in GraphQL results in a 200 OK HTTP response, we can't tell that our mutation just failed. The good thing is, the solution is simple - just add the `errors`&nbsp;field:

```
mutation {
  updateUser(email: "invalid") {
    name
    errors {
      field
      message
    }
  }
}
```

This will likely bother some people a lot more than it bothers me.

## Best Practice Perhaps?

As I said before, this probably won't work for all use-cases, but I think it does a pretty good job covering most people's needs. I will be keeping a close eye on what comes out of the working group discussions about errors to see what they come up with. Personally, I think we need a best practice here and not any kind of change to the spec, as this seems a bit too use-case specific. Time will tell. Until then, I think that this is a great solution, and I hope you've found it helpful!

**_UPDATE 03-17-2018:_** _There is [now a "part 2" of this post](/2018/03/17/i-thought-of-a-better-way-to-handle-errors/), so-to-speak where I show why this solution is still not quite right and present a couple of solutions that I think address the problem with this approach. The solution outlined there should be used over this one._

