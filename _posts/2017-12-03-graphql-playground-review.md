---
layout: post
title: GraphQL Playground Review
date: 2017-12-03 03:01:14.000000000 -06:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Opinion
- Reviews
tags: []
meta:
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _thumbnail_id: '229'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2017/12/03/graphql-playground-review/"
---
_These opinions are based on my experience with certain features of GraphQL Playground running v1.0.2-rc.1 and v1.1.1. Please keep that in mind as you read, since a new release could completely nullify anything I say here._

Most people who have used GraphQL for any amount of time would agree that the king of GraphQL tooling is the [GraphiQL “ide”](https://github.com/graphql/graphiql). It brings GraphQL to life with an editor that allows you to construct queries, send them to your server, and view the response. It also layers on nice features like auto-completion/prediction, syntax error highlighting, and a docs tab that utilizes introspection to allow you to browse the API. You can even drill straight into a field's documentation from the editor window, or see a brief tooltip style description. There's a history tab, a section for query variables, and many GraphQL libraries have a plug-in to allow you to directly serve it from your server if you don't want to use the desktop client.

This thing is pretty incredible to use, and really makes GraphQL come to life. It's an easy way to see the power and benefits of GraphQL, especially if you are a newcomer.

While GraphiQL is the champion in this arena, a new contender has emerged to battle for it's kingship. Another editor that could take it's place.

### GraphQL Playground

For those that haven't heard, this is the editor that Graphcool uses for their product. They open sourced it a while back and you can download it for free from the [GitHub repo](https://github.com/graphcool/graphql-playground). I've been using this for a few weeks now so I thought it might be good to record some of my thoughts on it.

**How is it different than GraphiQL?**

There are a few different things that set GraphQL Playground apart from from GraphiQL.

- Tabs
- Support for subscriptions
- Better schema/docs navigation
- Dark theme
- Automatic schema reloads
- Vim mode
- Ability to share your queries (sort of like jsfiddle or something)
- Code generation for your query
- Superior history functionality
- Ability to download the JSON response

### Using GraphQL Playground Locally

When you first open it up, it will ask for a URL.

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.13.39-PM-1024x529.png)

Once you click "open", you should be able to see your schema. A "gotcha" to watch out for is that if you are passing auth headers in order to have access to the API, your first introspection query will fail because it will not properly send the query with your http headers (see discussion on GH). To fix it, just reload your schema again. Your subsequent requests should correctly include the headers you set.

At this point, you should be able to query your API just like you would with GraphiQL.

### The Good

The first thing to note is that GraphQL Playground looks nice - quite a bit nicer than GraphiQL in my opinion. Both themes (light and dark) look great to me, though I tend to be partial to dark themes in general.

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.33.34-PM-1024x712.png)

_I mean seriously, so much nicer than GraphiQL_

Auto-reloading is pretty cool if you're actively modifying the schema itself - otherwise it can get pretty annoying because of how much it pollutes your logs (it works by polling the server with an introspection query every few seconds).

I also love how accessible the settings are:

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.08.50-PM.png)

I find that navigating the schema is a much nicer experience too, as the schema expands to cover more of the screen as you dive further into the fields. You can also navigate the schema using the arrow keys.

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.22.56-PM-1024x640.png)

Tabs are really nice. I can have multiple things going on at once without having to either comment out queries or search back through my history or open multiple windows. They also automatically get named based on the query you're running, and you even get different icons and colors to distinguish between queries and mutations (and I would imagine subscriptions as well).

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.08.16-PM-1024x252.png)

The fact that it has support for subscriptions is also very compelling, but unfortunately I can't speak to that since I haven't really messed with it yet. (I'd love to hear your thoughts on this if you have!)

### The Bad

There are a few things that bug me - mostly these are fairly minor annoyances, but they are annoyances nonetheless.

**There's no feedback when you reload the schema.**

I find myself checking the logs a lot to make sure the introspection query executed. Even when there's an error that causes the server to blow up (during introspection/schema-reloading specifically - running queries does show errors), there's no way to tell directly from the playground - I'm forced to turn to the logs.

**The HTTP headers button down at the bottom of the screen is floating over the query section.**

This means that it covers up parts of your query if you have a long enough query. This may not sound so bad, but it's actually very obnoxious to me. It gets in my way quite a bit, and there's no setting to hide it or change that. I'd much rather have the button&nbsp;_not_ be floating. Just anchor it to something. Hell, hide it somewhere in a menu if you have to - it's not something I imagine most people change a lot. I typically set an auth header or something and then forget about it from then on.

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-5.56.10-PM.png)

_Why_

**Autocomplete in the query variables is way to optimistic.**

It will complete the typing for me without me asking it to like you'd expect, so invariably I end up having to backspace because I ended up with something like `“example”: truerue`. To be fair, GraphiQL does the same thing, and I'm not entirely sure why either of them does this.

**The idea of sharing is cool, but dangerous.**

I mentioned above that you can share your queries - it actually goes further than this. It basically allows you to share the entirety of your session - all tabs, the endpoint you're hitting, query variables, history, and http headers. You're supposed to be able to disable things and have it only share certain things, but when I tried to disable everything, it still shared my http headers, which is where people generally stick their auth tokens. This might not be so bad if you're sharing something you're working on locally, but if you've got your playground pointed at a production app, this can be pretty bad.

To make matters worse, even if turning them off actually worked, the fact that they're shared by default is unsettling. I can imagine someone accidentally sharing something with production credentials and never realizing it. Which brings up another good point - from what I can tell, there's currently no way to delete what you've shared, so if you make a mistake like this or accidentally included something you shouldn't have in the query itself, you're SOL.

I don't dislike this feature entirely, but I would strongly caution people who want to use it due to these issues.

![]({{ site.baseurl }}/assets/images/2017/12/Screen-Shot-2017-11-04-at-6.01.51-PM.png)

**I really wish that they had keyboard shortcuts for showing/hiding the schema.**

I find myself getting annoyed when I have to reach for my track pad when I need to see the schema. Same for reloading the schema manually, switching tabs, and showing/hiding the history. There's a chance at least some of these keyboard shortcuts exist, but no amount of googling or searching their repo on GitHub was turning up a list.

### Conclusion

I have really enjoyed using GraphQL Playground - I don't want my criticisms to be taken the wrong way. In fact, I've barely touched GraphiQL since downloading the playground. I also understand that it hasn't been very long since it was released and so there will be plenty of kinks for them to work out. If they can improve the negatives, then I personally think it stands a really good chance of overthrowing GraphiQL.

What are your thoughts? Have you used GraphQL Playground? How do you feel about it so far?&nbsp;

