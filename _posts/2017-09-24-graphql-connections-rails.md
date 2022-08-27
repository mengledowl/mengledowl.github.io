---
layout: post
title: GraphQL Connections In Rails
date: 2017-09-24 00:49:45.000000000 -05:00
categories:
- Ruby on Rails
- Tutorials
tags: []
author: Matt Engledowl
permalink: "/2017/09/24/graphql-connections-rails/"
---
So you've been doing some GraphQL. You've made some fields that you can query on, maybe even a few mutations, and life is good. Early on however, you think "hmm, what if I have a large set of data that I need to return? I should probably paginate that." So you go to your trusted friend and ally:

![]({{ site.baseurl }}/assets/images/2017/09/Screen-Shot-2017-09-16-at-10.13.22-PM.png)

&nbsp;

And you probably see [this documentation](http://graphql.org/learn/pagination/)&nbsp;from graphql.org where they start throwing around terms like "edge", "connection", "cursor", and if you're anything like me you think "what the hell is this, I just wanted to add pagination to my results set". Maybe at this point you gave up, or maybe you tried to push through. Maybe you're way smarter than me and this was a walk in the park and you figured it out instantly. I'll tell you what I did: I said to myself "whatever, I'll just create a couple of arguments called `page`&nbsp;and `per`&nbsp;and use those to paginate and be done with it".

**Don't do what I did.**

This was lazy of me, and luckily this was just during my exploration phase. I eventually got the hang of it, and I can tell you that it's much simpler than it first appears. The quickest way to understand this concept, at least in my opinion, is to jump into the weeds and implement it.

_SIDE NOTE: Is me showing you the "what" and "how" a violation of the principle of&nbsp;[Start With Why](http://amzn.to/2yzy8cL)?_ _I'll at least tell myself it's not since I'm using those two as a mechanism to get to get to the why, but it probably is._

### Connections In GraphQL And Rails

So let's say we've got an app that has a lot of users, and we want a field in our schema that allows us to expose the full list of users. So here's an example of what our schema might look like starting out:

```
# graphql/types/user_type.rb

Types::UserType = GraphQL::ObjectType.define do
  name 'UserType'
  description 'A user for the application'

  field :id, types.ID
  field :firstName, types.String, property: :first_name
  field :lastName, types.String, property: :last_name
  field :email, types.String
end

# graphql/types/query_type.rb

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :users, types[Types::UserType] do
    resolve ->(_obj, _args, _ctx) {
      User.all
    }
  end
end
```

Our `users`&nbsp;field is pretty naive - it just returns everything right now. So let's change it to use connections instead:

```
Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  connection :usersConnection, Types::UserType.connection_type do
    resolve ->(_obj, _args, _ctx) {
      User.all
    }
  end
end
```

_Shockingly simple_, right? Let me explain real quick.

We define a connection by replacing our usual call to `field`&nbsp;with `connection`. We name it `usersConnection`, then where we set the type, we pass it `Types::UserType.connection_type`&nbsp;which is going to automatically handle building all the pieces involved in this (there are quite a few). Our resolve function looks exactly the same.

At this point you may think "_wait a minute, this just grabs all the users, where's the pagination?!_" So this is really cool - in the graphql gem, a connection expects to receive a full list that it can load&nbsp;_lazily_. When you use ActiveRecord methods such as `all`&nbsp;and `where`, the query gets evaluated lazily, meaning that it won't run until you attempt to do something with it. The gem is smart enough to know how to paginate our call to `User.all`&nbsp;and will do so before running the query.

Now we can run a query and start discussing all the pieces:

```
{
  usersConnection(first: 3) {
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      cursor
      node {
        id
        firstName
        lastName
      }
    }
  }
}
```

Here's what running that query looks like for me:

![]({{ site.baseurl }}/assets/images/2017/09/Screen-Shot-2017-09-16-at-6.49.29-PM-1024x699.png)

**There's a lot going on here** , so let's step through it one piece at a time.

First of all, there are all kinds of arguments and fields and objects that we never created! These were all automatically added by doing our call to `connection`&nbsp;- we got them for free.

In the first line of our query, we ask for our `usersConnection`&nbsp;field and pass it `first: 3`. This is pretty straightforward: give me the first three items from my `usersConnection`&nbsp;field (which our query happily returns).

Then we've got this crazy `pageInfo`&nbsp;object - what's that all about? This is going to contain some important information about the data-set we've just retrieved. Some of those things will probably be obvious, such as `hasPreviousPage`, and some of them may not be, such as those relating to cursors. We're going to skip over explaining those for the moment and come back to it in a bit.

After the call to `pageInfo`, we drill down into something called `edges`. This is where it really helps to look at the data response. `edges`&nbsp;is just an array of objects (edges) - and each of those objects has a `node`&nbsp;that contains the data for a single `UserType`. So `edges`&nbsp;is an array where each item is an `edge`, and each `edge`&nbsp;has a node, which is just our type - in this case a user object. Each `edge`&nbsp;also has a `cursor`, which is basically just an identifier for that particular edge that we can use to paginate from a specific point.

Okay, so we got our first page of users, what happens if we want to get the next page? This is where those cursors come into play. If we look at that last edge, we'll see that it has a cursor value of `Mw==`. We can use this and pass it as an argument in our query to get the next page:

```
{
  usersConnection(first: 3, after: "Mw==") {
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      cursor
      node {
        id
        firstName
        lastName
      }
    }
  }
}
```

And we get back a new set of data! Basically what our query says now is "get me the first 3 users&nbsp;_after_ the edge known as `Mw==`". We can also paginate in the _opposite_ direction using the arguments `before`&nbsp;and `last`.&nbsp;With this knowledge we can understand the `startCursor`&nbsp;and `endCursor`&nbsp;pieces of `pageInfo`&nbsp;- they're just defining what the first cursor is in the set of edges, and the last cursor so that you can quickly use that information for paginating forwards and backwards.

Take some time and play around with this. As you spend some time changing the arguments and watching what information you get back, it should help with understanding precisely what is going on here. Once you get the hang of it, it feels very natural.

### Customize The Connection

This is cool, but what if we want to customize our connection? For example, maybe we want to add a new argument to be able to order our users. How would we go about doing that?

Well, `connection`&nbsp;takes a block that accepts all the same calls as `field`, so we can just set additional arguments there:

```
Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  connection :usersConnection, Types::UserType.connection_type do
    argument :orderBy, types.String, 'Column to order the results by', as: :order_by, default_value: 'first_name'

    resolve ->(_obj, args, _ctx) {
      User.all.order(args[:order_by])
    }
  end
end
```

And then we can use it in our queries just like normal:

```
{
  usersConnection(first: 3, after: "Mw==", orderBy: "last_name") {
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      cursor
      node {
        id
        firstName
        lastName
      }
    }
  }
}
```

### Customize The Connection More

We saw that we can customize the connection, but what if we want to customize the data we're returning? One of the common things people add to this is a `totalCount`&nbsp;field that will show the total number of users, not just how many are displayed in the current page. Let's see how we can add that.

In order to make this work, we need to use the `define_connection`&nbsp;method on our `UserType`. First, create a new file under `graphql/connections/users_connection.rb`&nbsp;and add the following code:

```
Connections::UsersConnection = Types::UserType.define_connection do
  name 'UserConnection'

  field :totalCount do
    type types.Int

    resolve ->(obj, _args, _ctx) {
      obj.nodes.count
    }
  end
end
```

So here we're defining a `UsersConnection`&nbsp;and adding a field to it called `totalCount`. The important piece is in the resolve function. We first grab our `obj`&nbsp;which is going to be our connection object, then we drill down to the list of nodes, and ask for a count on them. In order to use this, we have to change our query type to use our new connection:

```
connection :usersConnection, Connections::UsersConnection do
  argument :orderBy, types.String, 'Column to order the results by', as: :order_by, default_value: 'first_name'

  resolve ->(_obj, args, _ctx) {
    User.all.order(args[:order_by])
  }
end
```

The only difference here is that we replace `Types::UserType.define_connection`&nbsp;with `Connections::UsersConnection`, which is the connection we just defined. Now our query can include the `totalCount`:

```
{
  usersConnection(first: 3, after: "Mw==", orderBy: "last_name") {
    totalCount
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
    edges {
      cursor
      node {
        id
        firstName
        lastName
      }
    }
  }
}
```

Pretty neat, huh? There's a lot more that you can do here, but rather than continuing to dive into this, I'll just drop a link to the [documentation](http://graphql-ruby.org/relay/connections.html) so that you can continue to explore this further.

### Yes But Why?

Okay, so we have a basic grasp of what this whole "connections" thing is and how it works, but&nbsp;_why would we want to do this?_ If you want to go deep into the history of connections, the naming, and why it became the best practices way of doing pagination, I would recommend [this really thorough explanation](https://dev-blog.apollodata.com/explaining-graphql-connections-c48b7c3d6976). The basic gist has to do with keeping the pages stable when items get added/deleted while paginating. Go ahead and read the full article for more elaboration on that point.

Now, I want to point out something very important - one of the main things that connections are meant to do is provide stable cursors, but **by default, the ruby gem does not provide stable cursors for ActiveRecord**. If you want to have this functionality, you will either have to implement it yourself, or you can pay for GraphQL::Pro.

With that being said, I would still highly recommend using connections for pagination even if you don't get stable cursors out of it. Why? For one thing, I'm big on following the expected conventions and best-practices that have been set forth. This allows for consistency - if I'm coming into a project that uses GraphQL, I am going to expect that pagination uses connections, and if it doesn't then it's going to add to the cognitive load for learning my way around. It also means that I don't have to sit there and think about how I'm going to do pagination going into a new project if I just know that I'm going to be using connections. My other reason is that because it is a best-practice, client-side frameworks expect to see it. The more that we can keep our API following an expected path, the less we'll struggle and fight with it later on down the road.

I hope this was enlightening and was helpful in grasping the concept of connections and how to use them. Thoughts, questions, comments? Drop them below!

