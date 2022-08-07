---
layout: post
title: Stop Doing Hash Resolution By Hand
date: 2017-11-19 00:16:25.000000000 -06:00
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
  _thumbnail_id: '216'
author: Matt Engledowl
permalink: "/2017/11/19/stop-doing-hash-resolution-by-hand/"
---
![]({{ site.baseurl }}/assets/images/2017/11/felix-russell-saw-102515-1024x683.jpg)

By default, the ruby gem for GraphQL will allow you to define your fields without a resolver so long as the object being resolved by the parent field for that type has a method with the name of the field in question. For example, if you had a `Weather`&nbsp;GraphQL type with a field defined like this:

```
field :temperature, types.Int, 'The temperature outside in degrees'
```

so long as the object resolved for your `Weather`&nbsp;type responds to `temperature`&nbsp;(eg. `weather.temperature`), it will automatically resolve the field for you using that method. What happens when your object is a hash, though? Well, the gem has a nifty little helper which allows you to specify that it should use hash notation rather than attempting to call a method:

```
field :temperature, types.Int, 'The temperature outside in degrees', hash_key: :temperature
```

This will resolve by calling `weather[:temperature]`&nbsp;rather than trying to call the method. This is nice and all, but wouldn't it be even nicer if the code was smart enough to just know that the object is a hash and handle it? I don't want to have to think about this - plus, what happens if I have a situation where my type could be resolved as&nbsp;either an object&nbsp;_or_ a hash? It would be a pain to have to go through and define resolvers for each field to handle this sort of scenario.

Well, this may not be built into the gem, but today we're going to discuss how we can handle this using field instrumentation!

### What Is Field Instrumentation?

If you're not familiar with the term "instrumentation" in programming, I would define it as a way to hook into the lifecycle of some piece of code in order to perform some kind of work at that point. For example, instrumentation is commonly used to provide logging around a certain piece of code. In the graphql-ruby gem, field instrumentation allows us to hook into the definition of fields, which we're going to use today in order to change the default resolve functionality.

When using field instrumentation, we need to create a class that responds to `instrument`&nbsp;and accepts two parameters: `type`&nbsp;and `field`. We can then plug this field into our schema, and when our schema is first generated, each field will be passed down to our `instrument`&nbsp;method (along with the `type`), and we can access properties on the field, allowing us to change it's definition.

### Building The Instrument

![]({{ site.baseurl }}/assets/images/2017/11/fireskystudios-com-2236-1024x622.jpg)

Let's take an example here. Say we need to expose the weather in our API, so we have a `Weather`&nbsp;type that looks something like this:

```
Types::Weather = GraphQL::ObjectType.define do
  name 'Weather'
  description 'Information regarding the weather'

  field :temperature, types.Int, 'The temperature outside in degrees'
  field :scale, types.String, 'The scale that the temperature is being measured in, eg. fahrenheit'
  field :description, types.String, 'A description of the weather, such as details about it being partly cloudy'
  field :windSpeed, types.Int, 'The speed of the wind in MPH', property: :wind_speed
end
```

And then in our `QueryType`:

```
field :weather, Types::Weather do
  description 'Retrieve current weather information'

  resolve ->(_obj, args, _ctx) {
    {
        temperature: 70,
        scale: 'F',
        description: 'Partly cloudy with a chance of rain in the afternoon',
        wind_speed: 5
    }
  }
end
```

We're just directly resolving a static hash here for simplicity - this would obviously go and hit some kind of service in real life. We'll start with the hash and then later show how it won't care if it's a hash or some other kind of object by the time we're done.

We'll start by creating our new instrumentation object:

```
# instruments/object_or_hash_instrumentation.rb

class Instruments::ObjectOrHashInstrumentation
  def instrument(_type, field)
    if field.resolve_proc.is_a?(GraphQL::Field::Resolve::BuiltInResolve)
      field.redefine do
        resolve ->(obj, _args, _ctx) {
          property = (field.property || field.name)&.to_sym

          if obj.is_a?(Hash)
            obj[property]
          else
            obj.public_send(property)
          end
        }
      end
    else
      field
    end
  end
end
```

Feeling like this is a lot to digest? I agree that it can look a bit scary at first, so let's break it down.

```
if field.resolve_proc.is_a?(GraphQL::Field::Resolve::BuiltInResolve)
  # code to redefine the field
else
  field
end
```

The `field`&nbsp;being passed in here is the definition of a field. In the case of our `Weather`&nbsp;type from above, the `instrument`&nbsp;method would be called for each field we defined, so the first one would be the object defining the `temperature`&nbsp;field. One of the methods we have access to is the `resolve_proc`, which in the case of our `temperature`&nbsp;field is going to be the default resolve that is built-in to graphql-ruby. Since every field in our schema gets passed through this instrument, we have to be aware of this and account for it. We also want to be sure that we don't overwrite resolvers that we have explicitly defined in our types. In the library, when no `resolve`&nbsp;is specified for a field, it is given an instance of `GraphQL::Field::Resolve::BuiltInResolve`, so we know we can safely alter the resolve proc if `resolve_proc.is_a?(GraphQL::Field::Resolve::BuiltInResolve)`. If it's not a `BuiltInResolve`, then we just return field as-is with no modifications.

```
field.redefine do ... end
```

Assuming we get into the if block above due to this being a field that we haven't defined a custom resolver for, we hit this line, which is simply a way to open up the field and redefine it. This is where we can change the resolver for the field.

```
resolve ->(obj, _args, _ctx) {
  property = (field.property || field.name)&.to_sym

  if obj.is_a?(Hash)
    obj[property]
  else
    obj.public_send(property)
  end
 }
```

And here's our new `resolve`&nbsp;proc! This part is pretty straightforward. We grab the property, and then check to see if it's a hash. If so, use hash notation, otherwise send the method name to the object being resolved on.

One thing that I wanted to dive into a bit more here is this line, as it may seem a bit strange:

```
property = (field.property || field.name)&.to_sym
```

What we're looking for here is the value that should be used to resolve the field. Normally, this will be the name of the field, so in the case of `field :temperature # ...`&nbsp;this would be `:temperature`. However, this is not always the correct value.

Why not?

Well, we just so happen to have an example of when this will be the case in our type definition from above! Take a look back at this line:

```
field :windSpeed, types.Int, 'The speed of the wind in MPH', property: :wind_speed
```

There's something unique here: the use of `property`. If you've not seen it before, it allows us to specify a different method name to resolve on than the one passed directly into `field`. We do this here so that the field can be used using the correct casing on the client-side (`windSpeed`), but we can still use snake\_case on the server-side to keep with conventions on both ends. In the case of our resolver though, this means that in this situation, we want to use `property`&nbsp;and not `name`, which is why our code is checking `property`&nbsp;first for the correct name to resolve on.

There's one last thing we need to do before we can test this out. Back in our schema, we need to tell the schema to use this new instrument that we've created:

```
MySchema = GraphQL::Schema.define do
  instrument(:field, Instruments::ObjectOrHashInstrumentation.new)

  query(Types::QueryType)
end
```

This is pretty straightforward as well - we just call `instrument`&nbsp;and pass in what we're instrumenting on (in this case `:field`&nbsp;- the implication being that you can instrument on more than just the field level), followed by a new instance of the correct instrument. The next time our schema is loaded, it will run all the fields in our schema through our new instrument and redefine fields as necessary.

### Play That Instrument!

![]({{ site.baseurl }}/assets/images/2017/11/kelly-sikkema-287520-1024x678.jpg)

Now you should be able to kick off your server and try it out! First with no modifications:

```
{
  weather {
   temperature
   description
   scale
   windSpeed
  }
}
```

All of the data you specified in your resolver should come back correctly!

And now, make a quick change to your resolver:

```
field :weather, Types::Weather do
  description 'Retrieve current weather information'

  resolve ->(_obj, args, _ctx) {
    OpenStruct.new({
                       temperature: 70,
                       scale: 'F',
                       description: 'Partly cloudy with a chance of rain in the afternoon',
                       wind_speed: 5
                   })

  }
end
```

So now rather than just returning a hash, we're returning an object that needs to have it's fields accessed using the `.`&nbsp;notation, eg. `weather.temperature`. Give it another try - this should also work just fine!

_Note: I know that you can access an `OpenStruct`'s properties using the hash notation still, so if you don't believe me then feel free to create a class and drop everything in there to verify. I didn't feel like taking the time. You can also set a breakpoint in the resolver we created in `ObjectOrHashInstrumentation`&nbsp;and step through to verify._

Okay, we have one more scenario to test - what happens when you define a custom resolve proc? Let's give that shot too. Update your `Weather`&nbsp;type to something like this:

```
Types::Weather = GraphQL::ObjectType.define do
  name 'Weather'
  description 'Information regarding the weather'

  field :temperature, types.Int, 'The temperature outside in degrees' do
    resolve ->(_obj, _args, _ctx) {
      103
    }
  end
  field :scale, types.String, 'The scale that the temperature is being measured in, eg. fahrenheit'
  field :description, types.String, 'A description of the weather, such as details about it being partly cloudy'
  field :windSpeed, types.Int, 'The speed of the wind in MPH', property: :wind_speed
end
```

Notice that we're resolving temperature by hand here to always be 103. Run that query again and you should see 103 come back for the `temperature`!

_Note: if you're not seeing the changes, you may need to restart your server._

### Take A Bow

This is one of my favorite features in the graphql-ruby gem. Once you wrap your head around the concept, it can open up some pretty cool posibilities. A word of caution though: instrumentation can be abused - make sure that if you're doing this, it's pretty clear what you're doing and doesn't do something that people might not expect. It's one of those things that can cause unintended side-effects if you're not careful, and lead to spending a lot of time scratching your head if you're not aware that someone wrote some instrumentation to modify something, especially if there's an edge-case that wasn't accounted for (eg. if we hadn't accounted for the whole `property`&nbsp;thing above).

Instrumentation allows us to do some pretty powerful things - feel free to play around and see what else you could do with it!

