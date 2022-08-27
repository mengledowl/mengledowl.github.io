---
layout: post
title: Clean Up Your Schema With Resolvers And Functions
date: 2017-10-07 23:48:27.000000000 -05:00
categories:
- Ruby on Rails
- Tutorials
tags: []
author: Matt Engledowl
permalink: "/2017/10/07/clean-up-schema-resolvers-functions/"
---
Once you've been doing GraphQL for a while, you might start to notice that you have some repetition, or that your schema is getting unruly due to large resolvers. In this post, we will explore some ways that you can trim this down and share functionality between your fields using resolver classes and `GraphQL::Function`.

### When Your Resolver Is A Monstrosity

![]({{ site.baseurl }}/assets/images/2017/10/ashim-d-silva-106275-1024x1024.jpg)

Sticking your hand in this pile is _not_ recommended.

Let's imagine you have a resolver that is doing a lot of different things. Perhaps it's handling filtering, searching, and maybe a handful of other things on your `users`&nbsp;set. Maybe a [connection](/2017/09/24/graphql-connections-rails/) - something like this:

```
connection :allUsersConnection, Types::UserType.connection_type do
  description 'Retrieve a list of users'

  argument :ids, types[types.ID]
  argument :category, types.String
  argument :hasComments, types.Boolean, as: :has_comments
  argument :hasPosts, types.Boolean, as: :has_posts
  argument :search, types.String

  resolve ->(_obj, args, _ctx) {
    users = User.all
    users = users.where(id: args[:ids]) if args[:ids]
    users = users.where(category: args[:category]) if args[:category]
    users = users.joins(:comments) if args[:has_comments]
    users = users.joins(:posts) if args[:has_posts]

    if args[:search]
      queries = args[:search].split(' ').map { |val| "%#{val}%" }

      users.where('first_name ILIKE ANY ( array[:queries] ) OR last_name ILIKE ANY ( array[:queries] )', queries: queries)
    else
      users
    end.uniq
  }
end
```

Now imagine that there are _dozens of fields_ with resolvers like this.

Don't worry about the code inside the resolver too much - there are definitely better ways it could be written. The point is simply to show that our schema is a bit cluttered. Come to think of it, it seems a bit strange to have this logic directly in our schema. In my opinion, **the schema is meant to define the&nbsp;structure of the data** , not how we get it!

_"But there has to be code to tell it how to resolve the field!"_

True, but **I prefer to think of the resolve function as a _hook_ into the business logic layer.** &nbsp;Then I can just let the business logic layer define how to retrieve the correct data (or modify it in the case of a mutation).

### Using The Resolver Pattern

As I mentioned in my post on [building a GraphQL API in rails](/2017/09/04/building-a-graphql-api-in-rails/), the `resolve`&nbsp;function takes a proc. A proc, behind the scenes, is just an object that has the `call`&nbsp;method called on it. You can think of it like this:

1. You create a proc `-> (val) { val + 1 }`
2. Ruby then dynamically builds a class around it and converts the block to a method called `call`:
```
class MyClass
  def call(val)
    val + 1
  end
end
```
3. Somewhere your proc gets called by doing `MyClass.new.call(val)`

The important thing about this is that it means that you can pass in any object that responds to `call`&nbsp;on your `resolve`&nbsp;and it will work. So the resolver pattern takes the original version and turns it into this:

```
# graphql/resolvers/users_resolver.rb

class Resolvers::UsersResolver
  def call(_obj, args, _ctx)
    users = User.all
    users = users.where(id: args[:ids]) if args[:ids]
    users = users.where(category: args[:category]) if args[:category]
    users = users.joins(:comments) if args[:has_comments]
    users = users.joins(:posts) if args[:has_posts]

    if args[:search]
      queries = args[:search].split(' ').map { |val| "%#{val}%" }

      users.where('first_name ILIKE ANY ( array[:queries] ) OR last_name ILIKE ANY ( array[:queries] )', queries: queries)
    else
      users
    end.uniq
  end
end

# graphql/types/query_type.rb

connection :allUsersConnection, Types::UserType.connection_type do
  description 'Retrieve a list of users'

  argument :ids, types[types.ID]
  argument :category, types.String
  argument :hasComments, types.Boolean, as: :has_comments
  argument :hasPosts, types.Boolean, as: :has_posts
  argument :search, types.String

  resolve Resolvers::UsersResolver.new
end
```

And that's it - we're done! Now we've just got a&nbsp;_hook_ from our `resolve`&nbsp;function to our resolver instead of having our logic sitting in directly in our query type. This also means that we can break logic out into multiple methods within our `UsersResolver`&nbsp;if we want to, which gives us more flexibility. Another great benefit to this is that it suddenly becomes&nbsp; **much easier to write tests** for the behavior of our resolve function without the hassle of having to construct queries. Now we can just write unit tests against our `Resolvers::UsersResolver`&nbsp;class!

### When Your Field Declarations Aren't Dry ![]({{ site.baseurl }}/assets/images/2017/10/photo-1444384851176-6e23071c6127-1024x768.jpeg)

Another problem that can come up pretty quickly is seeing fields that look identical, or almost identical. Take some simple query fields, for example:

```
field :post, Types::PostType do
  description 'Retrieve a blog post by id'

  argument :id, !types.ID, 'The ID of the blog post to retrieve'

  resolve ->(_obj, args, _ctx) {
    Post.find(args[:id])
  }
end

field :user, Types::UserType do
  description 'Retrieve a user by id'

  argument :id, !types.ID, 'The ID of the user to retrieve'

  resolve ->(_obj, args, _ctx) {
    User.find(args[:id])
  }
end

field :comment, Types::CommentType do
  description 'Retrieve a comment by id'

  argument :id, !types.ID, 'The ID of the comment to retrieve'

  resolve ->(_obj, args, _ctx) {
    Comment.find(args[:id])
  }
end
```

Each of these does exactly the same thing, it's just a different resource that it performs it on it. The resolver pattern depicted above wouldn't really get us a whole lot in this situation, but you know what would?

**`GraphQL::Function`**

This is a way to share attributes between fields in a reusable manner. By creating a class that inherits off of `GraphQL::Function`, we can set descriptions, arguments, and even a resolver function (by implementing a `call`&nbsp;method). The minor details that change between the three fields above can be passed in using dependency injection, and will yield a pretty powerful result. Here's how the above would look when extracted out into a more generic function class:

```
# graphql/functions/find_function.rb

class Functions::FindFunction < GraphQL::Function
  attr_reader :model_class

  def initialize(model_class)
    @model_class = model_class
  end

  description 'Retrieve resource by ID'

  argument :id, !types.ID, 'The id of the resource to retrieve'

  def call(_obj, args, _ctx)
    @model_class.find(args[:id])
  end
end

# graphql/types/query_type.rb

field :post, Types::PostType, function: Functions::FindFunction.new(Post)
field :user, Types::UserType, function: Functions::FindFunction.new(User)
field :comment, Types::CommentType, function: Functions::FindFunction.new(Comment)
```

Pretty cool, huh? We just reduced the lines of code **from 29 lines down to 3**. Even if we include our new class in the line count, it's still sitting at only 18 lines, and we could add hundreds of find fields with one line a piece.

What if one something changes for one of those for some reason and we need to modify some piece for that one only? Say for example on our comment field, we want to add a default value to the `id`&nbsp;argument. Well, we can still pass a block to our field, and anything within that block would override what we set in the function:

```
field :comment, Types::CommentType, function: Functions::FindFunction.new(Comment) do
  argument :id, types.ID, default_value: 1
end
```

This would work for the description and resolve functions as well. You could also take this pattern to the next level and use functions for every field you define. I can see how this could be really helpful when you have a very large schema, but for the cases I've encountered, it seems a bit like overkill. I'm still not sure where I fall on that though to be honest, as it does clean up your root types quite a bit. Anyway, I think that largely comes down to preference/taste.

Have you done anything like this to clean up your schema? Perhaps you take a different strategy than those outlined here - if so, I'd love to hear about it! I'm always looking for ways to improve my code and to clean up my solution further. Drop a note in the comments and let me know!

