---
layout: post
title: Secure By Default
date: 2018-04-29 05:01:08.000000000 -05:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Best Practices
- Opinion
tags: []
meta:
  _edit_last: '1'
  _wpcom_is_markdown: '1'
  _thumbnail_id: '407'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/04/29/secure-by-default/"
---
![]({{ site.baseurl }}/assets/images/2018/04/rishabh-varshney-138805-unsplash-1024x683.jpg)

How long has it been since the last "biggest security breach in history" that "affected millions of users"? It seems like every other week another company is making headlines with this kind of stuff. Everyone talks about "security", but it seems like very few pieces of software are actually "secure". How many times have you heard a PR message from a company on the heels of a breach that sounds something like this:

> Security is a top priority at BigCorp. We value our customer's data and are working to fix the issue.

Now, I believe that there are lots of factors that play into this. Obviously one of them is that security must be pretty lax at a lot of these companies. For example, there's simply no excuse for the recent breach at Panera Bread. To have&nbsp; customer data accessible to anyone on the internet, logged in or not, betrays extreme negligence at the company level - are you really going to tell me that no one had the thought "hmm, we should probably make people log in before they can hit this endpoint that has sensitive customer data"? For that to have gone uncaught (and then unaddressed for _months_ after it was first reported) shows that they really _don't care about security at all_.

Moving on from that rant, some other contributing factors are:

- Developers aren't trained to think about security
- Developers believe the myth of "security through obscurity"
- Developer tools aren't built to help mitigate security problems

I want to zero in on that last one, because I think it's an important and often missed piece of this discussion.

I feel that in many ways, the tools that we use - the frameworks, libraries, services, etc - to build software have failed us. These are tools that are used by countless developers, and the vast majority of them these days are open source and supported by a vibrant community. So many people work on these things, especially popular frameworks and libraries, that it is easy to have highly specialized work being done on each piece of the system by people who are experts in their niche. There is great potential here to have&nbsp; **unimaginably far-reaching impact** on countless systems in production when contributing to these tools.

Everyone knows that security is a huge concern these days. So why aren't more of these tools built to be&nbsp; **secure by default**?

For example, if I'm working on a web framework and I know that CSRF is a very common attack vector for web apps, why shouldn't I not only build protection in by default, but&nbsp;_turn it on by default_? I would say that not only is this an important thing to be thinking about, talking about, and working on, but in fact, it's somewhat of an obligation at this point. How many of these kinds of problems could be mitigated by taking this attitude when building tools for developers? Sure, I may not always need CSRF protection, but the more we can put developers into a situation where they have to&nbsp;_disable_ a security feature as opposed to actively needing to think about&nbsp;_enabling_ one, the less likely it will be that things will be missed.

Let's be real too - while it's important to teach security fundamentals to developers, **you shouldn't have to become a security expert to build a secure piece of software**.

I know that not everyone agrees with the philosophy of convention over configuration, and while I'm unapologetically on the side of convention, I also understand and appreciate that there are those who disagree and have valid reasons for that. But can't we all at least agree that there is always a default, and that&nbsp; **insecure by default is a terrible default****?**

And yet, so many tools work this way.

Lately this has been bothering me a lot when I think about the new tools that are coming out for GraphQL. The ecosystem is starting to grow at an incredible pace, and I believe that this trend will continue as more and more people start to use it. I'm all for this growth - I love seeing the things that people come up with and the incredible power and flexibility that GraphQL can offer! Certainly, the tools that are coming out for GraphQL are one of the best things about it, no question.

However, I want to take this opportunity to urge anyone who is working on these new tools:

**Please, prioritize security and do your part to make the tools and libraries you contribute to secure by default.**

Obviously I understand that there's no silver bullet - it's not possible to build a library that can't be used in an insecure fashion. This isn't what I'm asking for.

What I&nbsp;_am_ asking for is some extra diligence. When you build something, ask what the more secure way is to use that thing, and try to steer the developer in that direction as much as you can. For example, if you're building a library to generate a GraphQL API based off of an ORM, don't make it expose&nbsp;_anything_ by default! Require the developer to specify precisely which things he/she wants to expose. It should not be possible for me to use your library and accidentally expose `AdminPermission`&nbsp;with a `create`&nbsp;mutation to boot, simply by creating an `AdminPermission`&nbsp;class within my ORM.

That's a shitty default.

It's a _dangerous_ default.

Bake security into your tools and encourage secure practices as much as possible, avoiding situations wherever possible that would lead to the default being insecure. I think this is an important step towards creating a more secure future in software development, and I would love to see security treated like a first class citizen in the GraphQL community (and of course in the greater developer community in general).

