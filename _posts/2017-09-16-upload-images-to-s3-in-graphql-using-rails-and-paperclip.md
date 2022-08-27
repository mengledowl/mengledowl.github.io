---
layout: post
title: Upload Images to S3 in GraphQL Using Rails and Paperclip
date: 2017-09-16 14:07:47.000000000 -05:00
categories:
- Ruby on Rails
- Tutorials
tags: []
author: Matt Engledowl
permalink: "/2017/09/16/upload-images-to-s3-in-graphql-using-rails-and-paperclip/"
---
![]({{ site.baseurl }}/assets/images/2017/09/Pictures-Desk-Photographs-Images-Office-Photos-2618641.jpg)

_Update:&nbsp;[Softdroid](http://softdroid.net)&nbsp;has posted a Russian translation of this article here:&nbsp;[http://softdroid.net/zagruzka-izobrazheniy-na-s3-v-graphql](http://softdroid.net/zagruzka-izobrazheniy-na-s3-v-graphql)_

When I first started using GraphQL, one of the more frustrating things was figuring out how to&nbsp; **upload an image in GraphQL**. This is pretty straightforward in REST, and if you don't know how to do it, you can find information really quickly. There are plenty of tutorials for getting set up to upload images to Amazon's S3 file storage service in rails, but&nbsp;_damn_ was it hard to find something that talked about that in GraphQL! This is one of those things that once I figured it out seemed painfully obvious, but the mindset switch from REST to GraphQL can take some time. With that in mind, I wanted to share how I upload images to S3 with a GraphQL API.

Let's assume you've got a `User`&nbsp;model that you want to be able to add profile images to. You've also got a `UserType`&nbsp;in GraphQL as well as a field on your `QueryType`&nbsp;for retrieving a user by id, say `findUser`. This all might look something like this:

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

  field :findUser, Types::UserType, 'Find a user by id' do
    argument :id, !types.ID, 'The id of the user to find'

    resolve ->(_obj, args, _ctx) {
      User.find(args[:id])
    }
  end
end

# graphql/types/mutation_type.rb

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :updateUser, Types::UserType, 'Update a user profile by id' do
    argument :id, !types.ID, 'The id for the user to update'

    resolve ->(_obj, args, _ctx) {
      u = User.find(args[:id])
      u.update(args.to_h)
      u
    }
  end
end
```

Okay great, we've got our starting place - obviously our mutation isn't really useful right now, but we'll come back to that. Go ahead and add the [paperclip](https://github.com/thoughtbot/paperclip)&nbsp;and [aws-sdk](https://github.com/aws/aws-sdk-ruby)&nbsp;gems to your Gemfile and do a bundle install. You'll want to make sure you have ImageMagick installed (instructions can be found in the gem's documentation linked above) to make this work.

The next step is to get paperclip running. Per the documentation, we'll add our attachment to our `User`&nbsp;model and create a migration to add the columns we will need:

```
# user.rb

class User < ApplicationRecord
  has_attached_file :profile_image
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\z/
end

# migration

class AddProfileImageToUsers < ActiveRecord::Migration[5.1]
  def up
    add_attachment :users, :profile_image
  end

  def down
    remove_attachment :users, :profile_image
  end
end
```

Don't forget to run your migrations. This will add some functionality to our `User`&nbsp;model that will allow us to upload an image, interact with it, and validate it's format. Now we can update our GraphQL schema to allow us to return this image by adding a field to our `UserType`:

```
field :profileImageUrl, types.String do
  resolve ->(user, _args, _ctx) {
    user.profile_image.url
  }
end
```

And now we can get to the mutation where we can upload an image!&nbsp;Some people recommend having a separate endpoint that you use for this and just skipping GraphQL altogether, but I want to do all the things in GraphQL, so that's what we're going to do. Now, one of the things I learned about paperclip that's not really documented (or at least not very well), is that it can accept a base64 encoded image for uploading. Since we don't really have the ability to handle image uploads quite the same way in GraphQL as we would REST, we are just going to accept a string argument that contains the base64 encoded version of the image we are attempting to upload. So let's return to our `updateUser`&nbsp;mutation and add some new arguments so it looks like this:

```
field :updateUser, Types::UserType, 'Update a user profile by id' do
  argument :id, !types.ID, 'The id for the user to update'

  argument :profileImageBase64, as: :profile_image do
    type types.String
    description 'The base64 encoded version of the profile image to upload.'
  end

  argument :profileImageName, types.String, as: :profile_image_file_name, default_value: 'profile-image.jpg'

  resolve ->(_obj, args, _ctx) {
    u = User.find(args[:id])
    u.update(args.to_h)
    u
  }
end
```

We've got 2 new arguments that we can pass in now, `profileImageBase64`&nbsp;which will be our base64 encoded image and points to the `profile_image`&nbsp;property on our `User`, and `profileImageName`, which is going to be an image name for our image which defaults to "profile-image.jpg". This second one is important because by default paperclip will just name it "data" with no extension, making it difficult to actually use. In a production environment you would probably want to do some validation on the image name or even set this automatically rather than exposing it to the client, but I'll leave either of those as an exercise if you want to do it.

Let's see what we've got here! Make sure you have a user in your database that you can play with, and then go generate a base64 encoded string. I use&nbsp;[https://www.base64-image.de/](https://www.base64-image.de/)&nbsp;for this because it's so simple - you just upload a file, click the "copy image" button, and presto! You've got a base64 encoded image copied to your clipboard. Now we can run our mutation:

```
mutation {
  updateUser(id: 1, profileImageBase64: "[paste your base64 encoded image here]") {
    id
    profileImageUrl
  }
}
```

And we should get something like this back:

```
{
  "data": {
    "updateUser": {
    "id": "1",
    "profileImageUrl": "/system/users/profile_images/000/000/001/original/profile-image.jpg?1504992676"
  }
}
```

So our upload works! If we want, we can go to our project folder and drill down starting in /public to the location defined in our URL above and we should see the image. We're getting pretty close, but this still isn't quite what we want - we need these images to get pushed up to S3. Before we get started on that, make sure that you have the following ready:

- An AWS account
- An S3 bucket for your project
- The name of your bucket
- Your access key ID
- Your secret access key
- The region that your bucket is in

_NOTE: For purposes of this blog post, we'll be doing this locally. If you're doing this for a production app, make sure that you use `production.rb`&nbsp;for these settings rather than `development.rb`._

In order to make paperclip upload to S3, we're going to need to set some configuration details. Open up `config/environments/development.rb`&nbsp;and add the following:

```
config.paperclip_defaults = {
    storage: :s3,
    path: '/:class/:attachment/:id_partition/:style/:filename',
    s3_protocol: 'https',
    s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        s3_region: ENV['AWS_REGION']
    }
}
```

Set your environment variables accordingly. There are multiple ways to do this, but I prefer to use&nbsp;[dotenv](https://github.com/bkeepers/dotenv)&nbsp;which is a gem for managing your environment variables by allowing you to place them in a `.env`&nbsp;file in your root directory.&nbsp; **If you go this route, make sure you add `.env`&nbsp;to your `.gitignore`****.&nbsp;**If you don't do this, your credentials could be compromised.

Restart your server and try running your mutation again. It should be successful, and you should see it return a URL for your image that points to it in your S3 bucket. Now you can upload images through your GraphQL API, and all your client has to know how to do is base64 encode the image (there are lots of libraries for this). At this point, you're done! Congratulations, you can now upload files to S3 through GraphQL in rails! If you get stuck or would like to browse through the code, it's available on my GitHub [here](https://github.com/mengledowl/graphql-image-uploads).

