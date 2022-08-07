---
layout: post
title: A $300 Billion Question
date: 2018-09-16 04:46:49.000000000 -05:00
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
  _thumbnail_id: '503'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/09/16/a-300-billion-question/"
---
![]({{ site.baseurl }}/assets/images/2018/09/pepi-stojanovski-509192-unsplash-1024x640.jpg)

Earlier this week, I was at API World in San Jose to give a talk about [how GraphQL can help solve the problem of enterprise sprawl](http://sched.co/FO9H), based somewhat loosely on [this blog post](https://graphqlme.com/2018/02/17/how-graphql-solves-the-problem-of-sprawling-architecture-for-the-enterprise/) from a while back. It was a really great experience and I loved getting the opportunity to share my thoughts on the subject through a different medium than my blog - I found out that speaking can be really fun!

My favorite part was that I got lots of really great questions from people afterwards. It's so much fun to hear the ideas people have and be able to help them come to a better understanding of how GraphQL works!

Anyway, there was one question in particular that really stuck with me.

One of the main points of my talk was that by moving to an architecture where you're using GraphQL as a gateway, it can allow you to start addressing technical debt more quickly and in a much more manageable way, while hiding much (or all) of the existing mess behind the extra layer of abstraction that GraphQL can provide.

So towards the end of the Q&A portion, this guy commented on the technical debt thing with something like this (paraphrased):

> It seems like this would just add more technical debt and be a lot of work to implement.

I think my response was important enough to share publicly. Here's what I tried to convey to him, and to the rest of the audience who was listening.

Yes, there will be a certain amount of technical debt that this may add while you're adopting this pattern for your architecture. There's going to be a period of time while you're implementing where you've still got some of your old architecture and some of the new.

There will be a lot of work ahead of you.

It's going to take a lot of effort and time to do this.

**But it's a necessity.**

Did you read the report stripe just released? They conducted a survey which concluded that companies are cumulatively [losing $300 billion dollars a year](https://stripe.com/reports/developer-coefficient-2018) in productivity due to technical debt.

This isn't just a problem -&nbsp; **it's a monster**.

Whether you like it or not, you have to deal with your tech debt. And really, you have two options:

1. Just keep paying on the interest.
2. Try to actually pay down your debt.

With option #1, you are basically able to keep operating your business and maintain it, but you'll always be drowning in debt. And the worst thing is, if all you ever budget is enough to pay back the interest, what happens when an emergency comes up and there's something more important that you have to put your money (developer hours) towards? Or when you need to take on a bit more debt in order to implement something that you need yesterday?

That's right - more debt. Those interest payments just got bigger just to stay in maintenance mode. I believe this is actually what many companies are doing right now, and it's just exacerbating the problem.

#2 is certainly a more painful option at the start, especially if you don't have your priorities straight. But do you know what happens to people that don't manage their debt and find a way to pay it down to where it's not threatening their livelihood?

**They file for bankruptcy.**

There's a reason why we call it technical “debt”. Putting it in monetary terms can help communicate just how severe the problem is, especially to the business side which may have a harder time understanding the cost of technical debt.

If you choose to go the route of #2 and start actively trying to pay that debt down, you're going to be able to move much more quickly later on. Yes it will be more work at first - but nothing good comes easy or for free. Contrary to what people may want to hear, debt doesn't just go away. You have to pay it back or suffer the consequences.

So whether or not you want to, you're going to have to take on more debt for one reason or another. You're going to have to make payments on that debt. And if you don't actively campaign against it rather than just making the minimum monthly payments, you're going to sink further and further in and fall further and further behind as a company.

My suggestion is just one possible solution. I think it's a great way to give you extra abstraction that gives you enough space to start addressing the debt in a more manageable way. But whether you decide to go that route or use a different tactic, you have to do something.

Nothing is not an option.

Nothing leads to bankruptcy.

And just making the minimum payments?

That's nothing.

On the other hand, if you really dig in and start to address the problem and pay that debt down, you're freeing up resources later on down the road. You can reduce the (on average) 13.5 hours per week that developers say they are wasting on technical debt ([source](https://stripe.com/files/reports/the-developer-coefficient.pdf)[pdf]) and have them put that time to better use providing value rather than just trying to save a sinking ship. In personal finance, you might call it "financial freedom". I think we need a similar term for this:&nbsp; **technical freedom**.

So yes, there's going to be a lot of work involved. Yes, you're going to have to invest a lot of time, energy, and probably money into this. But it's a path toward technical freedom - those that choose to walk on that path will be rewarded 10 fold. Those that don't?

Well, that's the opposite of freedom.

And personally?

I choose to be free.

