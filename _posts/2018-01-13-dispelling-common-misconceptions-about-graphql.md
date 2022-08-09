---
layout: post
title: Dispelling Common Misconceptions About GraphQL
date: 2018-01-13 22:14:15.000000000 -06:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Opinion
tags: []
meta:
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _thumbnail_id: '306'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/01/13/dispelling-common-misconceptions-about-graphql/"
---
![]({{ site.baseurl }}/assets/images/2018/01/evan-dennis-75563-1024x683.jpg)

There seem to be a lot of misconceptions about GraphQL out there. Let's take a look at a few of them and I'll do my best to address them.

## Misconception #1: GraphQL exposes my whole database!

### Reality: GraphQL gives you fine-grained control over what data you expose

This is probably the most common misconception that I've encountered. It comes in various forms - anything from "it seems really insecure to allow anyone to execute queries against my database" to "how do I keep people from accessing secure information if they can just ask for whatever they want?"

If you have this concern, then rest assured: not only does GraphQL not expose your whole database, but it transcends databases entirely. GraphQL is a specification that defines a method of asking for and receiving information - nothing more, nothing less. In the same way that you, the back-end developer get to decide what information a specific user can retrieve from your JSON/RESTful API, you can have complete control over what information a user can have access to. If your GraphQL API is fed by a SQL database, you write the queries and check the user permissions before returning data. If you are connecting to third party APIs to provide data, then you get to specify which information GraphQL actually returns to the user.

_(Edited to add)_

One project that I'd like to call out here that looks really neat is [Prisma](https://www.prismagraphql.com/). When I first looked at it, I actually thought it was simply exposing your database externally, but after further investigation, it turns out that I was wrong. Instead, it _utilizes a layered architecture_ which allows you to **query your database using GraphQL syntax from your backend** rather than SQL or the like, and then specify what and how that data should be exposed externally to the client. This is a really cool concept that I hope to be able to explore soon because it means that **you can essentially use GraphQL as an ORM** of sorts while still maintaining full control over what gets exposed. _This is distinctly different from the idea of simply exposing the entirety of your database in GraphQL to the outside world_.

## Misconception #2: GraphQL queries are complex like SQL

### Reality: GraphQL queries are very simple

Another way that people tend to express this misconception is something like "GraphQL makes you write&nbsp;_queries_? That sounds complicated."

This is understandable - after all, the name "GraphQL" is very reminiscent of "SQL", and it also has "queries" just like SQL does. It's only natural that people might make the connection between the two, and associate the difficulty of writing a SQL query with that of writing a GraphQL query.

Writing a query in GraphQL feels a lot more like writing JSON, though. In fact, if you imagine a JSON structure with keys and values, just take out the values (leaving only the keys), and you basically have a GraphQL query. For example, imagine you want to ask for a list of users, with each user's name and email. Here's how that query might look:

```
{
  users {
    name
    email
  }
}
```

Isn't that just so much simpler than SQL?

## Misconception #3: GraphQL doesn’t scale

### Reality: Lots of large companies use GraphQL

The best argument I have against this is the amount of large companies who have been using GraphQL in production successfully without any scale problems. To start off with, GraphQL came from Facebook. In fact, by the time they announced GraphQL, they had been using it in production for the native apps and the web app for several years. I don't think that Facebook would be using a technology that can't scale. Here are just a few other large companies using GraphQL in production:

- GitHub (if you're interested in what they're doing, I [interviewed Robert Mosolgo](/2017/12/21/interview-with-robert-mosolgo-creator-of-graphql-ruby/) of GitHub about GraphQL at GitHub)
- IBM
- Shopify
- Pintrest
- Twitter
- Yelp

That being said, there are some different issues that you may encounter than what you would see in REST such as increased difficulty in [mitigating N+1 queries](/2017/12/09/n1-queries-no-more/), but these are solved problems.

## Misconception #4: GraphQL is just hype

### Reality: GraphQL is one of the most likely "new" things in programming right now to have logevity

The first thing I'd like you to do is take a look back at that list in Misconception #3. Hype tends to result in lots of startups using the technology - it's not often that it ends up being used by large-scale companies if it's really just hype.

The fact that it has the support of such large companies, it is open-source, that it's a spec, and that it solves a very real and painful problem for developers puts it in a good position to outlast the hype-cycle. This isn't something that can be guaranteed, obviously - if I could see into the future to know with 100% certainty which things are just hype and which things aren't, I can promise you that I wouldn't still be a developer - but it's about as close as we can get in tech to being confident that it's going to last.

## Misconception #5: You have to use a graph database to use GraphQL

### Reality: The "graph" in GraphQL refers to the way the data is represented, not the underlying data-storage mechanism

It's not uncommon for people to assume that GraphQL requires you to use a graph database. This is another one of those things that happens because of the name: GraphQL has "graph" in the name and requires writing queries, therefore it seems intuitive to assume that it is a query language for graph databases.

The truth is that GraphQL is what I like to refer to as&nbsp; **data-layer agnostic**. What this means is that GraphQL really doesn't care at all what your data-layer looks like - you could be pulling information from a graph database, a SQL database, a series of text files, some third party APIs, or that proprietary technology that your company developed internally that no one else has ever heard of. All GraphQL cares about is that you've told it how you want your data to look, and where to go to get a particular piece of data. Graph databases accepted, but certainly not required (and I would argue, a less common use-case!)

## Conclusion

There are many more misconceptions about GraphQL out there that I could address, but I've limited this post to the 5 most common ones that I've heard. Hopefully this helps clear some things up for you or for someone you know!

