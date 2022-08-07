---
layout: post
title: N+1 Queries No More
date: 2017-12-09 21:28:44.000000000 -06:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Ruby on Rails
- Tutorials
tags: []
meta:
  _edit_last: '1'
  _wpcom_is_markdown: '1'
  _thumbnail_id: '248'
  _aioseop_description: GraphQL lends itself pretty heavily to N+1 queries. Here's
    how you can handle them in graphql-ruby using graphql-batch.
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2017/12/09/n1-queries-no-more/"
---
![]({{ site.baseurl }}/assets/images/2017/12/computer-fire.jpeg)

_It's fine, it's just this N+1 query burning up my server._

GraphQL makes a lot of the problems of REST much easier to solve. However, one of the things that actually becomes&nbsp;_harder_ to solve is N+1 queries. Today we're going to be talking about precisely how to resolve N+1 queries in rails and GraphQL. We will dive into the nitty-gritty details of how the concept of batching works and get our hands dirty with some code.

Let's start with an example to showcase the problem.

### Naming The Beast

Imagine a pretty simple and common scenario. You have a `User`&nbsp;model that `has_many :posts`, and a `Post`&nbsp;model that `belongs_to :user`. In GraphQL, maybe it looks something like this:

```
Types::Post = GraphQL::ObjectType.define do
  name 'Post'
  description 'A blog post'

  field :id, types.ID
  field :user, Types::User, 'The user who wrote this post'
end

Types::User = GraphQL::ObjectType.define do
  name 'User'
  description 'A user in the system'

  field :id, types.ID
  field :posts, types[Types::Post], "All of the user's posts"
end

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  connection :posts, Types::Post.connection_type, 'Retrieve a list of posts' do
    resolve ->(_obj, _args, _ctx) { Post.all }
  end
end
```

So now you could submit a query that looks like this:

```
{
  posts {
    edges {
      node {
        user {
          id
        }
      }
    }
  }
}
```

And what's going to happen exactly? Well....

```
Post Load (1.3ms) SELECT "posts".* FROM "posts"
User Load (0.4ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 4], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 9], ["LIMIT", 1]]
CACHE User Load (0.0ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 4], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 7], ["LIMIT", 1]]
CACHE User Load (0.0ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 9], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 8], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 2], ["LIMIT", 1]]
CACHE User Load (0.0ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 2], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 5], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 6], ["LIMIT", 1]]
User Load (0.1ms) SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ? [["id", 10], ["LIMIT", 1]]
....
```

And on and on. We've got a classic N+1 query because we asked for a list posts and for each post, we wanted to grab the user that posted it. This is pretty simple to solve in REST, but how exactly does one go about solving it in GraphQL?

Well, the first thing that might come to mind is using `includes`&nbsp;- this is definitely an option:

```
Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  connection :posts, Types::Post.connection_type, 'Retrieve a list of posts' do
    resolve ->(_obj, _args, _ctx) { Post.includes(:user) }
  end
end
```

_Side note: if you're not familiar with connections, you can read my post about how to use them [here](https://graphqlme.com/2017/09/24/graphql-connections-rails/)._

And this certainly works:

```
Post Load (0.5ms) SELECT "posts".* FROM "posts"
User Load (0.2ms) SELECT "users".* FROM "users" WHERE "users"."id" IN (4, 9, 7, 8, 2, 5, 6, 10, 3, 1)
```

But there's a problem. Let's try a different query:

```
{
  posts {
    edges {
      node {
        id
      }
    }
  }
}
```

So we're no longer asking for the user, but what do you think's going to happen?

```
Post Load (0.5ms) SELECT "posts".* FROM "posts"
User Load (0.2ms) SELECT "users".* FROM "users" WHERE "users"."id" IN (4, 9, 7, 8, 2, 5, 6, 10, 3, 1)
```

Yep. That's right. Even though we weren't asking for a user in our query, we still preloaded it! This may not seem like a big deal with an example as trivial and small as this one, but as your graph expands, this becomes increasingly problematic. Just imagine how inefficient it would get if your graph got to the point where your query looked like this:

```
Post.includes(:categories, :banner_image, :likes, comments: [:user], user: [:comments, :friends])
```

This many relationships could very easily exist on a single item in your graph - and many more even. At this point, our query above would end up running a ton of unnecessary queries to get all this data - not to mention mapping it all out in ActiveRecord creating lots of objects that you won't even touch. This request should take a few dozen milliseconds to execute and render, but it will end up taking a lot more than that every single time, no matter how little data you are requesting.

Talk about inefficient!

The problem is, we can't really know at this level of execution what information the user is going to be asking for unless we want to try to get into some complex parsing of the tree to determine which relationships we should load. In addition, each field is loaded without the context of anything else surrounding it, which is why we get the N+1 queries in the first place.

So how do you solve it?

### You Batch!

What exactly does that mean, though?

In the normal order of things, when you hit a line of code during execution, you expect that code to execute immediately. With batching, the basic idea is to delay that using a concept called "lazy-loading" or "promises". For those of you wondering - yes, this is the same "promise" concept that javascript has. In this case, promises allow us to defer execution of a piece of code until later. This is important because it means that rather than immediately executing a query, we can "batch" up a list of all the items that we intend to load, and execute a single query to get them all.

So if we return to our example above, this is what batching would allow us to do:

1. Ask for the post's user - but instead of loading it, use a promise to ask for it to be fulfilled at a later time
2. Each time we ask for a user in the code, queue up the user's id into a list
3. When it's time to fulfill the promises, execute a single select statement on `users`, passing in the list of user ids we collected during the process of creating promises
4. For each user that we get back, "fulfill" the promise by saying "here's the user that was requested for promise X"

### Making It Happen

At this point you might be thinking "that's great Matt, but theory isn't going to pay the bills - how do I actually implement this so my GraphQL/rails server doesn't keep giving me N+1 queries?"

I'm so glad you asked!

There are multiple libraries out there to handle this, but my favorite - and the one we will be using today - is called [graphql-batch](https://github.com/Shopify/graphql-batch)&nbsp;and was built by the fine folks at Shopify. As we discussed above, this gem will allow us to batch our queries together to execute a single query avoiding N+1 queries using promises.

The readme has some code to get us started that we can adapt for our use-case here. Personally, I find that the documentation is a bit lacking in terms of explaining precisely what the gem is doing and how to use it, so I'd like to explain that in a bit more detail. Let's start with the code and then move into a deeper explanation of what exactly is happening.

The first thing we'll need to do is install the gem:

```
gem 'graphql-batch'
```

Next we need to tell our schema to use it:

```
MySchema = GraphQL::Schema.define do
  use GraphQL::Batch
  # ...
end
```

This just does some setup on our schema to allow the lazy-loading to take place correctly.

The next thing we need to do is to create a loader. This is a class that inherits off of `GraphQL::Batch::Loader`&nbsp;and will handle the logic of resolving the data - running the queries and fulfilling the promises. This class must implement `perform`&nbsp;which takes a single argument. Here's what our class is going to look like:

```
# graphql/loaders/primary_key_loader.rb

module Loaders
  class PrimaryKeyLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(ids)
      @model.where(id: ids).each { |record| fulfill(record.id, record) }
      ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
    end
  end
end
```

Don't worry if this is confusing, we'll dive into it here in a minute and I'll explain what's happening one line at a time. First though, we need one more piece to make this work.

In our `PostType`, we need to batch our requests to `user`&nbsp;- so let's do that real quick:

```
Types::Post = GraphQL::ObjectType.define do
  name 'Post'
  description 'A blog post'

  field :id, types.ID
  field :user, Types::User, 'The user who wrote this post' do
    resolve ->(post, _args, _ctx) {
      Loaders::PrimaryKeyLoader.for(User).load(post.user_id)
    }
  end
end
```

At this point you should be able to execute your query again and see that you don't get an N+1 query anymore. Woot!

How exactly does this work? I'll start with the simple version: you call `for`&nbsp;with arguments that get passed to initialize. It returns an instance of the loader, which you then call `load`&nbsp;on, queueing up a list of ids on which to eventually execute the query. Eventually `perform`&nbsp;gets called, which handles executing the query and fulfilling the promises with data.

If you're not interested in the details, you can stop here. I would highly encourage you to read on, however, as having a deeper understanding of how this works will allow you to use this library for more complex scenarios such as `has_many`&nbsp;and polymorphic associations.

### The Nitty Gritty Details

There are two key objects that we need to know about to understand how this code is working:

- **Loader** &nbsp;- these are objects that inherit off of `GraphQL::Batch::Loader`&nbsp;and are responsible for "loading" the data (hence the name) and fulfilling promises (essentially saying "here's the item that you asked me to get for you later from the full list of results")
- **Executor** - this object handles storing instances of loaders based on a cache key (or "loader" key) that can be retrieved later to add more items to a loader or "execute" them.

So let's start out with this line, which is the starting point for everything:

```
Loaders::PrimaryKeyLoader.for(User).load(post.user_id)
```

When you call `for`&nbsp;on your loader class, it does a few very important things. First, it will generate a unique "loader key" for that loader based on a combination of the class name of your loader (in this case, `Loaders::PrimaryKeyLoader`) and any arguments you pass to `for`. That means for our example, the loader key would be `[Loaders::PrimaryKeyLoader, User]`. This key will then be used to check the cache that our `Executor`&nbsp;object is maintaining to see whether or not we've already stored an instance of that particular loader. If so, it returns that instance. Otherwise it will create a new instance of the loader, store it in the executor's cache, and then return the loader. By this point, our executor should have a hash that looks something like this:

```
{
  [Loaders::PrimaryKeyLoader, User]: Loaders::PrimaryKeyLoader.new(User)
}
```

So after the first time this line of code gets hit, we will keep re-using the same instance of our loader each time rather than continually creating new instances (assuming that we pass in the same arguments to `for`). This is very important because it allows us to collect a list of items to load in one place, which is where `load`&nbsp;comes in.

`for`&nbsp;returns the instance of our loader, and then we call `load`&nbsp;on it, which takes a single argument - in this case the user's id for that post. This is where things get really interesting. When you call `load`, the first thing it's going to do is generate a cache key for it. This is similar to, but separate from, the loader key we discussed above. In this case, it's going to serve as a reference to the item that we're asking for in our resolver so that we can return the correct user from the full list of users that we'll eventually query for.

After creating the cache key, the argument passed into `load`&nbsp;gets added to a "queue" object which is just an array consisting of all items that have been passed to `load`&nbsp;on that particular loader. The last step is to create a promise which gets added to the cache using the cache key generated above.

Eventually, we will have created a bunch of promises for many different users that we want to resolve. The code will reach the point where all of the users have been batched up and it's time to retrieve them all from the database. At this point, the code will call into the `perform`&nbsp;method we created above, passing the "queue" of all of the user ids into it. Let's look back at that method for reference:

```
def perform(ids)
  @model.where(id: ids).each { |record| fulfill(record.id, record) }
  ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
end
```

So in the first line, we use `@model`&nbsp;to query for our list of users. For clarity, the first part of the line would look something like this if it was done explicitly:&nbsp;`User.where(id: [1, 2, 3, ...])`. This is where we execute our single select query - yay! But what is the rest of it?

After we get back our list of users, we have a problem - how do we tie each user back to the post that it was requested for? This is where those promises come into play. For each record we're going to call `fulfill`, passing in the `id`&nbsp;and the `record`. The `id`&nbsp;is actually going to be used once again to generate a cache key to look up the item you passed into `load`&nbsp;back in your resolver, and then essentially say "okay, `record`&nbsp;is the object that was asked for in regards to this cache key". So this basically says "here's the user with id 1 that was asked for" (for example).

At this point, we have fulfilled all of the promises we were able to from the set of records we got back from our select statement. So what is this last line?

I'll admit, this threw me for a loop when I first looked at it.&nbsp;_What_ it does is pretty straightforward: it loops through each id and fulfills the promise for it with `nil`&nbsp;if it hasn't already been fulfilled. It's the&nbsp;_why_ that's a little less apparent, and it's best explained with an example.

Going back to our scenario, imagine that for some reason we ask for a user with an id that doesn't exist - what happens? The promise wouldn't get fulfilled by the first line, so the second line is basically a catch-all to go back through and fulfill any promises that hadn't already been fulfilled to say "hey, we didn't find anything for this promise". It's probably not a super likely thing to happen in this specific scenario (assuming that you're making sure you don't orphan any records), but imagine a slightly different scenario: what if instead of asking for the user who posted, you were asking for the first comment on that post? There are bound to be posts with no comments, so this scenario would be highly likely to occur in that case.

### Conclusion

This was a fairly simple example that only makes use of batching on `belongs_to`&nbsp;relationships - things start to get a bit more interesting when you get into things like `has_many`&nbsp;and polymorphic relationships, and things of that nature. However, as long as you have an understanding of how these different components work together within the gem - loaders, executors, loader keys, cache keys, promises - it will help a lot with figuring out how to handle those more complex scenarios. Really the most important concepts to grasp here (in my opinion) are the two cache keys, as these form the basis of how your queries are batched together, as well as how the data you retrieved is tied back to the associated object. If you can nail down those things, you'll be golden.

I would also highly recommend reading through the code as this was incredibly helpful to me when I was trying to grasp what was going on. It's a relatively small gem, and most of the "important" bits of code for understanding how to use it are contained in 2 short files. It will be well worth your time!

I hope you enjoyed this post and that it has been helpful in making your GraphQL rails API resilient enough to avoid those pesky N+1 queries!

