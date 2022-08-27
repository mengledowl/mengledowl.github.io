---
layout: post
title: Shorten Your Argument List With Input Types
date: 2017-11-04 18:07:48.000000000 -05:00
categories:
- Ruby on Rails
- Tutorials
tags: []
author: Matt Engledowl
permalink: "/2017/11/04/input-types/"
---
![]({{ site.baseurl }}/assets/images/2017/11/1280px-Mocking_Bird_Argument-1024x640.jpg)

_My money's on the one on the right_

Before I discovered ruby, I used to be a java programmer. I have nothing against java (or java programmers), but there just tends to be something about java programmers and method calls that look something like this:

```
buildSomethingFromThisAbstractFactoryAndSomeOtherStuffThatNobodyCanFollow(wow, there, are, really, sixteen, arguments, null, null, null, null, null, here, null null, null)
```

_Hint: if you counted the arguments, yes I'm screwing with you - there's only 14._

_Hint #2: just kidding, it's 15. See how horrible this kind of code is?_

Who can follow that? Every time I saw it, I wanted to pluck my eyes out. Now obviously the solution here is to find a way to make your list of arguments smaller (not to mention your method names - but that's a different topic for another day). Ideally when I'm coding, I like to aim for a single argument, and no more than 2. **If I have more than 2 arguments, it generally means that I need to reconsider how I'm doing things and maybe break some stuff apart.**

But even when trimming down the number of arguments that are being passed to a method, it can still create some level of cognitive load.&nbsp;_"What order were these supposed to be in again?"_ Then you have to go look and see, and it's a bit of an annoyance because by the time you come back you may have forgotten exactly what you were doing. It doesn't generally read very nice either. Let's take an example. Say we have a method that sets some values on an object, something like this:

```
def set_user_attributes(first_name, age, best_friend)
  self.first_name = first_name
  self.age = age
  self.best_friend = best_friend
end
```

Now when you either go to use this code or come across something that's using it, it can be a bit confusing:

```
john.set_user_attributes('Johnny', 34, jacob)
```

Okay, so probably most of us could figure out what's going on here, but you'd still want to go look at the method definition to verify - and hopefully my point has been made.

**This is unnecessary cognitive load.**

We have ways to solve this in ruby - such as using the splat operator to accept a hash of arguments - but I always hated having to assign the variables or access them through the hash. Then ruby graced us with [keyword arguments](https://robots.thoughtbot.com/ruby-2-keyword-arguments), which means that the above can be turned into this:

```
def set_user_attributes(first_name:, age:, best_friend:)
  self.first_name = first_name
  self.age = age
  self.best_friend = best_friend
end

john.set_user_attributes(name: 'Johnny', age: 34, best_friend: jacob)
```

In my opinion, this is just so much more clear. Each argument is prefaced by a name defining what it is so that it reads more like a human might explain it, and it also no longer matters which order the arguments are in! Very nice.

When I saw that GraphQL had named arguments&nbsp;_only_, I leapt for joy. This means that there are no risks of things like my java example above in a GraphQL query - you are _required_ to give every argument a name.

### No One Likes Long Arguments

There can still be a bit of pain here though. Let's imagine you have a mutation for a `UserType`&nbsp;in GraphQL for you to update your user. Let's start out with an example that builds off of my tutorial for [building a GraphQL API in rails](/2017/09/04/building-a-graphql-api-in-rails/)&nbsp;(plus a couple extras that I've added in for the sake of this example):

```
# graphql/types/user_type.rb

Types::UserType = GraphQL::ObjectType.define do
  name 'UserType'
  description 'Represents a user model'

  field :id, types.ID, 'The unique ID of the user'
  field :firstName, types.String, 'The first name of the user', property: :first_name
  field :lastName, types.String, 'The last name of the user', property: :last_name
  field :bio, types.String, 'A bio for the user giving some details about them'
  field :age, types.Int, 'The age of the user'
  field :nickname, types.String, 'A nickname that the user goes by'
  field :favoriteColor, types.String, 'This is important for some reason', property: :favorite_color
  field :bestFriend, Types::UserType, 'Who could it be?', property: :best_friend
  field :posts, types[Types::PostType], 'A list of blog posts by the user'
  field :comments, types[Types::CommentType], 'A list of comments posted by this user'
end

# graphql/mutations/mutation_type.rb

field :updateUser, Types::UserType do
  description "Allows you to update the user attributes for a user"

  argument :id, types.ID, "The ID of the user to update"
  argument :firstName, types.String, "The user's first name", as: :first_name
  argument :lastName, types.String, "The user's last name", as: :last_name
  argument :bio, types.String, "A short description about the user"
  argument :nickname, types.String, "A nickname that the user goes by"
  argument :favorite_color, types.String, "The user's favorite color"
  argument :best_friend_id, types.ID, "The ID for the user that is this user's best friend"

  resolve ->(_obj, args, _ctx) {
    params = args.to_h.with_indifferent_access

    User.find(params.delete(:id)).tap { |user| user.update(params) }
  }
end
```

If you've never seen that `tap`&nbsp;method, essentially it just allows us to "tap into" the object in question, perform some operations with it, and then return that same object, which means we avoid having to set a variable and return it. You can read more about it [here](http://seejohncode.com/2012/01/02/ruby-tap-that/).

Now imagine writing your query for this. It would likely look something like this:

```
mutation {
  updateUser(
    id: 1,
    firstName: "New",
    lastName: "Name",
    bio: "Here's the story of my life...",
    nickname: "Noob",
    favoriteColor: "blue",
    bestFriendId: 2
  ) {
    firstName
    lastName
  }
}
```

That's a decent amount of arguments, and it's not far-fetched to picture this user model growing to have many more arguments on it than this. We could dump these in the variables, but all that does is move the values, add more boilerplate, and really just make it even grosser. There's also another issue to consider with this: what happens if we want to add a `createUser`&nbsp;mutation? We'd have to duplicate this whole thing! We could [use functions](/2017/10/07/clean-up-schema-resolvers-functions/)&nbsp;to do this too, but it's still not quite right.

So what's the solution?

### Input Types

What is an input type? In GraphQL, this is a special type of argument that wraps one or more arguments up inside of itself.&nbsp; **It might be easier to think of an input type as an object that you can pass in your argument list** - so rather than having this long list of arguments, we could have one argument that we pass an object in to. Since it's a GraphQL object/type, it can also be re-used throughout your schema wherever you need it.

That explanation might be a bit dense and confusing, so let's take a look at what the above query would look like if you used an input type. We'll come back around to the code to implement this later - for now I just want to show the end-result so that you can see the value.

Here's our query again, this time using an input type called `UserInput`&nbsp;that we'll pass to an argument called `userInput`:

```
mutation {
  updateUser(id: 1, userInput: {
    firstName: "New",
    lastName: "Name",
    bio: "Here's the story of my life...",
    nickname: "Noob",
    favoriteColor: "blue",
    bestFriendId: 2
  }) {
    firstName
    lastName
  }
}
```

The main difference here is that we took everything but `id`&nbsp;and stuck it inside this new `userInput`&nbsp;argument. In its current state, what this gets us is:

1. A separation of concerns between our "lookup" argument(s) that will be used to find the user that we want to update (`id`), and our "modifier" arguments that will be used to update the user in question
2. A hard break between these two types of arguments on the server-side, allowing us to more easily find and then update without having to remove arguments or pluck out only those that are relevant for our `find`&nbsp;versus `update`

**But this isn't good enough yet!** There are more benefits that we can still derive here!

Let's see how things look if we move the `userInput`&nbsp;object into our query variables:

```
mutation UpdateUser($userInputDetails: UserInput!){
  updateUser(id: 1, userInput: $userInputDetails) {
    firstName
    lastName
  }
}

# query variables

{
  "userInputDetails": {
    "firstName": "New",
    "lastName": "Name",
    "bio": "Here's the story of my life...",
    "nickname": "Noob",
    "favoriteColor": "blue",
    "bestFriendId": 2
  }
}
```

Now we're getting somewhere - this makes our query look much better! We also get another nice benefit, this one for the front-end: since our `userInputDetails`&nbsp;is just a JSON object, the client-side code could have an object representing the user that it just dumps straight into the query variables rather than having to map things one-by-one. For example, imagine that on the client-side you had a `user`&nbsp;object that you were updating to send to the server. Your object could look something like this:

```
user = {
  "firstName": "New",
  "lastName": "Name",
  "bio": "Here's the story of my life...",
  "nickname": "Noob",
  "favoriteColor": "blue",
  "bestFriendId": 2
}
```

And then when you're setting query variables, it could be as simple as something like this:

```
queryVariables = {
  "userInputDetails": user
}
```

Obviously I'm leaving a few things out here - my point is how simple this makes passing the attributes you want to update to the server.

### Ruby Codez

Okay, now that I've beat that horse to death, let's see what things look like on the server-side! The first thing we need to do is define our input type, which I like to put under `graphql/inputs`:

```
# graphql/inputs/user_input.rb

Inputs::UserInput = GraphQL::InputObjectType.define do
  name 'UserInput'
  description 'An input object representing arguments for a user'

  argument :firstName, types.String, "The user's first name", as: :first_name
  argument :lastName, types.String, "The user's last name", as: :last_name
  argument :bio, types.String, "A short description about the user"
  argument :nickname, types.String, "A nickname that the user goes by"
  argument :favoriteColor, types.String, "The user's favorite color", as: :favorite_color
  argument :bestFriendId, types.ID, "The ID for the user that is this user's best friend", as: :best_friend_id
end
```

We now have an input object that we can pass around for use in arguments. Let's update our `updateUser`&nbsp;mutation to use our new input type:

```
field :updateUser, Types::UserType do
  description "Allows you to update the user attributes for a user"

  argument :id, types.ID, "The ID of the user to update"

  # remove all of our other arguments and replace them with a single argument that takes a UserInput
  argument :userInput, Inputs::UserInput, "The user attributes to update", as: :user_input

  # notice how this is just one line now!
  resolve ->(_obj, args, _ctx) {
    User.find(args[:id]).tap { |user| user.update(args[:user_input].to_h) }
  }
end
```

Ahhh, very nice. I like this so much better. We cleared out that long list of arguments and wrapped them up nicely in an input object, and our resolver is simplified by not having to dig through the arguments, so to speak. We can also re-use this input object anywhere else we want. So for example, if we wanted to add a new mutation for creating a user, it's as simple as this:

```
field :createUser, Types::UserType do
  description "Create a new user"

  argument :userInput, Inputs::UserInput, "The attributes for the new user", as: :user_input

  resolve ->(_obj, args, _ctx) { User.create(args[:user_input].to_h) }
end
```

Super easy, right?

### But Wait, There's More! (Nested Inputs)

Let's imagine an expanded scenario here. Your user model has a `has_one`&nbsp;relationship to an `Address`:

```
class User < ApplicationRecord
  has_one :address
end
```

Your `Address`&nbsp;model has several columns representing the address, eg. `street`, `city`, `state`, `zip`. Now, we want to be able to set this address in GraphQL somehow - but how do we do that? One option would be to have a new mutation for setting the address, maybe something like `setUserAddress`, but I don't really like that - it would be nice to have the ability to just nest that information inside the mutations we already have.

Turns out we can! Rails supports sending nested attributes for relationships in the create/update methods using `accepts_nested_attributes_for`, and on the GraphQL side, we can easily create a new input object for the address arguments, and pass that to an argument in our `UserInput`. Here's what that might look like:

```
# models/user.rb

class User < ApplicationRecord
  has_one :address

  # I like to set update_only: true to prevent rails creating orphaned records when the nested attribute gets changed
  accepts_nested_attributes_for :address, update_only: true
end

# graphql/inputs/address_input.rb

Inputs::AddressInput = GraphQL::InputObjectType.define do
  name 'AddressInput'
  description 'An input object representing arguments for an address'

  argument :street, types.String, 'The street address eg. 123 Main St.'
  argument :city, types.String, 'The name of the city for the address'
  argument :state, types.String, 'The state for the address'
  argument :zip, types.String, 'The 5 digit zip code'
end

# graphql/inputs/user_input.rb

Inputs::UserInput = GraphQL::InputObjectType.define do
  name 'UserInput'
  description 'An input object representing arguments for a user'

  argument :firstName, types.String, "The user's first name", as: :first_name
  argument :lastName, types.String, "The user's last name", as: :last_name
  argument :bio, types.String, "A short description about the user"
  argument :nickname, types.String, "A nickname that the user goes by"
  argument :favoriteColor, types.String, "The user's favorite color", as: :favorite_color
  argument :bestFriendId, types.ID, "The ID for the user that is this user's best friend", as: :best_friend_id

  # add the nested address argument here!
  argument :addressAttributes, Inputs::AddressInput, "The user's address information", as: :address_attributes
end
```

That's all we need on the server-side! One quick note - naming the argument `address_attributes`&nbsp;was very intentional. When using `accepts_nested_attributes_for`, rails expects that the nested attributes will come nested inside of a key called `[name_of_relationship]_attributes`, which in this case translates to `address_attributes`. More to the point, the way you would create a new user with an address would be `User.create(address_attribues: { street: '123 Main St.',  ... })`, which is why we named our argument `address_attributes`. This way in our resolver, we don't have to map the arguments to different keys or anything like that because&nbsp;`args[:user_input].to_h`&nbsp;returns a hash structured the way rails expects it to be.

So then back on the querying side, our new mutation would look like this:

```
mutation UpdateUser($userInputDetails: UserInput!) {
  updateUser(id: 1, userInput: $userInputDetails) {
    firstName
    lastName
  }
}

# query variables

{
  "userInputDetails": {
    "firstName": "New",
    "lastName": "Name",
    "bio": "Here's the story of my life...",
    "nickname": "Noob",
    "favoriteColor": "blue",
    "bestFriendId": 2,
    "addressAttributes": {
      "street": "123 Main St.",
      "city": "My City",
      "state": "My State",
      "zip": "12345"
    }
  }
}
```

Pretty cool huh?

### Conclusion

We learned some neat things about how to use GraphQL input objects to clean up our arguments and make dealing with them much easier. I'd encourage you to use this pattern - it has really helped keep my GraphQL code cleaner, more modular, and easier to reason about.

Do you have any thoughts on this pattern? Drop them in the comments below!

