---
layout: post
title: Presenter/Decorator Pattern in GraphQL Rails
date: 2017-09-30 16:00:42.000000000 -05:00
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
  _wpas_done_all: '1'
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _thumbnail_id: '96'
author: Matt Engledowl
permalink: "/2017/09/30/presenterdecorator-pattern-in-graphql-rails/"
---
![]({{ site.baseurl }}/assets/images/2017/09/Aleksei_Sheludko_presenting_the_critical_thickness_theory.jpg)

When I first got into rails, I heard the mantra "fat model, skinny controller" an awful lot. If you've never heard this before, the idea is that there should be very little code in your controllers, and your models should have a lot of code/logic. This always felt weird to me - isn't one of the principles of [clean code](https://www.amazon.com/gp/product/0132350882/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0132350882&linkCode=as2&tag=graphqlme-20&linkId=2a9719deb989593f0854f21d5e96968f) ![]({{ site.baseurl }}/assets/images/2017/09/ir?t=graphqlme-20&l=am2&o=1&a=0132350882) to keep&nbsp;_all_ of your classes small and tightly focused? I saw a lot of code (and even wrote some myself, I'm a bit ashamed to admit) where people were just cramming all kinds of logic into their ActiveRecord models. For example, how many times have you seen something like this?

```
class User < ApplicationRecord
  # code

  def full_name
    "#{first_name} #{last_name}"
  end

  # code
end
```

Yep. I've done it. The problem with this of course is that `User`&nbsp;should probably know nothing about `full_name`&nbsp;- it's focus should be the data itself, not the way it's presented. Usually the reason a method like this exists is so that the view has access to it, maybe to display it in a menu or to show full names in a user list. So really, this is a violation of the&nbsp; **Single Responsibility** design principle.

### Enter: The Presenter/Decorator Pattern

From this point forward, I'm just going to refer to it as the "presenter" pattern. They are technically different, but they're so close that it's not really worth the effort in my opinion.

In this pattern, rather than place "view" specific code in the model, you have a "presenter" class that contains the code. You instantiate this class by passing it whatever object you want to "present" to `new`, and then delegate methods down to the presented object. This may sound confusing if you've never used this patten before, but it will make a lot more sense once we implement it.

Some people use [draper](https://github.com/drapergem/draper)&nbsp;for this, but I generally avoid it. I prefer the simplicity of using the built-in `SimpleDelegator`. This is a class that you can inherit off of that will handle the method delegation for us. So building on our previous example, let's create a presenter called `UserPresenter`:

```
class UserPresenter < SimpleDelegator
  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end
end
```

And then if we wanted to use it, here's how we would do that:

```
user = User.new(first_name: "Matt", last_name: "Engledowl")
user_presenter = UserPresenter.new(user)

user_presenter.full_name # "Matt Engledowl"
user_presenter.first_name # "Matt"
user_presenter.id # nil - since this is new and not saved
```

So now we can see a bit more clearly what I meant about delegating methods. We pass our user into our `UserPresenter`&nbsp;class, then we can call `full_name`&nbsp;which is a method on `UserPresenter`, but we can also call `first_name`&nbsp;and `id`, which are methods on our `User`&nbsp;class - `SimpleDelegator`&nbsp;just delegates those methods. This is pretty cool because it allows us to separate our logic while still maintaining an easy interface.

### Presenting The User

Okay, so let's loop back around to GraphQL now. Imagine we've got the following:

```
# graphql/types/user_type.rb

Types::UserType = GraphQL::ObjectType.define do
  name 'UserType'
  description 'A user for the application'

  field :id, types.ID
  field :firstName, types.String, property: :first_name
  field :lastName, types.String, property: :last_name
end

# graphql/types/query_type.rb

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :findUser, Types::UserType, 'Find a user by id' do
    argument :id, !types.ID, 'The id of the user to find'

    resolve ->(_obj, args, _ctx) {
      User.find(args[:id])
    }
  end
end
```

We want to use our presenter to add `fullName`&nbsp;to our `UserType`&nbsp;- so here's how we would change these two things:

```
# graphql/types/user_type.rb

field :fullName, types.String, property: :full_name

# graphql/types/query_type.rb

# inside our resolve function...
UserPresenter.new(User.find(args[:id]))
```

Super easy, right? Now I know what you're thinking -&nbsp;_couldn't I just have a custom resolve on my `fullName`&nbsp;field rather than having a separate object just for that?_ And you would be right, you absolutely&nbsp;can do that. I would argue that you&nbsp; **shouldn't** though. **In my opinion, GraphQL object types &nbsp;are just describing the "view" from an API perspective**. I know this isn't a view in the "traditional" sense of the MVC pattern, but it&nbsp;_is_ a view in the sense that it gets rendered to the&nbsp;client. Therefore, to have a bunch of resolvers for custom fields that don't map directly to an attribute on the underlying data type seems like just putting a bunch of logic in the view, which is something I try to avoid. This way is clean, the logic is contained in an object rather than randomly sitting in a resolver on a field, and it also is&nbsp;_reusable_. If I have another type come up at some point, say a `Client`&nbsp;that should also have a `full_name`&nbsp;functionality,&nbsp;we can just pass our client object in to our presenter and be done.

Okay, so far so good. This has all been fairly simple, but I ran into something that took some time to figure out when I first encountered it...

### Presenter Pattern With Connections

This is where things get a bit trickier. With connections in the ruby gem, things work a bit different. Imagine your connection looking like this:

```
connection :usersConnection, Types::UserType.connection_type do
  resolve ->(_obj, _args, _ctx) {
    User.all
  }
end
```

If you read my blog post outlining [how connections work in the ruby gem](/2017/09/24/graphql-connections-rails/), you know that the `resolve`&nbsp;function should return something that can be lazily-loaded so that it can add the pagination functionality (if not, you should definitely give it a read before continuing as an understanding of connections is pretty important for this piece to make sense). This presents a problem for us, because if we do something like this:

```
User.all.map { |u| UserPresenter.new(u) }
```

Then suddenly we're not lazily loading, and instead of paginating before the query runs, we're running a query to get _all_ the users&nbsp;_immediately_, looping through each to wrap it up in a presenter, and returning this all before paginating the full array down to whatever we asked for. So if we have 10,000 users, **we just asked for all 10,000, looped through all 10,000 in ruby, and then trimmed down the array**. Not good at all.

So how can we resolve this problem?

**By using a custom edge.**

Yes, you can customize the edges on your connection! This took some trial and error to figure out, but I'm going to walk you through it. So, if you remember, our edge is going to have a node. The node is whatever our GraphQL object type is - in this case `UserType`&nbsp;- so if we can get to our node, that's the thing we want to present.

Let's build a custom edge:

```
Connections::PresenterUserEdge = Types::UserType.define_edge do
  name 'Edge'

  field :node, Types::UserType do
    resolve ->(edge, _args, _ctx) {
      UserPresenter.new(edge.node)
    }
  end
end

Connections::UserConnection = Types::UserType.define_connection(edge_type: Connections::PresenterUserEdge)
```

Alright! So, line by line, let's break that down.

```
Connections::PresenterUserEdge = Types::UserType.define_edge do
```

Here we create a new edge by calling `define_edge`&nbsp;on our `UserType`. This is much like how we define other object types in GraphQL.

```
name 'Edge'
```

We're just overriding the edge type, so we should probably keep the name Edge.

```
field :node, Types::UserType do
```

Now we define a field called `node`&nbsp;- what we're actually doing here is just overriding the default field that GraphQL defines for us behind the scenes. We want to replace what's in the default resolver with our presenter, so that leads us to this:

```
resolve ->(edge, _args, _ctx) {
  UserPresenter.new(edge.node)
}
```

So we have our standard resolve. The object that was resolved in the parent resolver is going to be an `edge`, and as I mentioned before, each edge has a `node`&nbsp;that in this case would be the user. That means that we can access the user object by drilling into `edge.node`&nbsp;- so we wrap that up inside of our presenter, and that gets us presenting all of our users. This tactic also avoids attempting to do this before pagination has occurred - this piece of the code won't run until we have already run the paginated query!

Let's look at that last line now:

```
Connections::UserConnection = Types::UserType.define_connection(edge_type: Connections::PresenterUserEdge)
```

All this is doing is defining a new connection and setting the edge type to the new edge type that we created above. We're basically telling the connection "hey, use this edge type for your edges".

The last step to get this to actually work is to modify our `QueryType`&nbsp;to use our new connection:

```
connection :usersConnection, Connections::UserConnection do
  resolve ->(_obj, _args, _ctx) {
    User.all
  }
end
```

### Boom, Done!

Now you should be able to run queries against your connection, ask for the `fullName`&nbsp;and get the correct value back. Pretty sweet, huh?

_Got any thoughts? Drop them in the comments below!_

