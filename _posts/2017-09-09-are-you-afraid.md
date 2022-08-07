---
layout: post
title: Are You Afraid?
date: 2017-09-09 18:59:00.000000000 -05:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories: []
tags: []
meta:
  _edit_last: '1'
  _wpcom_is_markdown: '1'
  _wpas_done_all: '1'
  _thumbnail_id: '74'
author: Matt Engledowl
permalink: "/2017/09/09/are-you-afraid/"
---
![]({{ site.baseurl }}/assets/images/2017/09/pexels-photo-326642-300x200.jpeg)

When introducing others to GraphQL, I've noticed that there seems to be a lot of excitement around what it promises and the gaps it intends to fill from REST APIs. I've also sensed something else - something that holds people back from diving in and giving it a go for their next project or as an experiment on an existing codebase. Something that keeps people using their same comfortable patterns.

At first I thought maybe people didn't really care, but I quickly saw that people loved the idea. Then for a while I thought maybe people thought the tech was too new and hadn't been battle tested, but this was just too hard to reconcile with the types of companies that are using it in production (it's hard to argue that Facebook's API technology isn't capable enough). But I believe that I may have finally landed on the primary reason that we sometimes see this behavior around GraphQL (and plenty of other things too).

## Fear.

Those of us who use GraphQL regularly may think “What? Fear? What is there to be afraid of?” I have a few theories. Many of these are things that the GraphQL community needs to be willing to address and take steps to mitigate if we want to see wide adoption take place.

### Fear Of The Unknown

It’s human nature to fear things we don’t understand - it’s a mechanism we developed as a species in order to survive dangerous situations. GraphQL is still new to most people who encounter it. They’re used to years of REST doing the job for them, and that’s a comfortable pattern to follow. GraphQL is unfamiliar territory, and it’s not widespread, so they don’t hear a lot of the nitty-gritty details around it, and this makes them nervous.

_“What happens if I start implementing this on my next project at work and then it doesn’t pan out because of some important factor that I didn’t know about? Better just keep it safe and stick with creating some REST endpoints...”_

### Fear Of Betting On The Wrong Thing

We see a lot of this in our industry. There’s so many new things around every corner that it’s impossible to even keep up with their _names_, much less actually invest the time necessary to learn them all to future-proof ourselves perfectly. I think every software developer experiences this to some degree, and who could possibly blame them? Most of us end up picking a handful of technologies and languages and investing a good amount of time learning them so we can be effective with them. That fear is always there though.

_“What happens if I spend all of this time and energy learning GraphQL and building APIs with it and then in two years, no one cares and people are looking at this stuff I built and going ‘what idiot built this?’ Better give it a little longer and see whether or not it starts getting big…”_

### Fear Of The “QL”

I think this one gets a lot of people. When we see anything ending in “QL”, our minds generally jump to SQL. There’s a _lot_ of baggage that comes with that:

- SQL is **hard**
- SQL is **verbose**
- SQL has a **high learning curve**
- SQL is that thing that my ORM/DBA/mommy is supposed to save me from

Many developers see that QL, hear that you have to write “queries”, and then all of that baggage hits them like a ton of bricks. Who wants to learn SQL 2.0? (And let’s be honest, who wanted to learn SQL to begin with?)

_“Whoa, that sounds super complex. Better just create a few simple endpoints…”_

### Fear Of Time Lost

This kind of builds on some of the other fears, but I think a lot of people are worried that the time they invest in GraphQL could end up being wasted.

_“What if it’s super complex and I spend three weeks on it and can’t figure it out? What if it ends up flopping and no one uses it? Better just invest my time in something I know will be time well-spent…”_

### Fear Of An Immature Spec/Library/Ecosystem

When I get into a project, especially one for work or that will see “production” usage, I want to feel confident that the technologies that I’m using are stable, that I’ve got solid support available to me, and that it’s still going to be being maintained in several years. If I get into something and it turns out the library sucks and no one is taking care of it and there’s not good tooling to solve some of the common problems that I run into with it or it’s hard to find information, I’m not going to be real happy. It’s good to have a healthy amount of skepticism around this kind of stuff when you’re choosing a central technology for a production-grade project, and I think a lot of people are worried that what’s available to them with GraphQL won’t cover all the things that could come up.

_“What if I run into a big problem that could destroy my product and the GraphQL community hasn’t solved it? Better just stick with something that I know has good work built up around it…”_

## Looking Toward The Solution

All of these fear categories add up when it comes time to place a bet on a technology for a production app. In the end, many people will choose to pick up the thing they know works when faced with these uncertainties rather than risk failing, and so we continue to see people get excited by this new technology while continuing to use the old.

I'm not satisfied to sit here and just ponder or bemoan the problem however. What can we _do_ about it? What has the potential to change this so that more people invest in GraphQL?

### Fight Fear With Fear

On the flip side of the fear of betting on the wrong thing (or maybe it’s just another side of the same coin) is the **fear of being left behind**. If enough people have this fear around GraphQL, and it outweighs their other fears, it will create a snowball of people using GraphQL. **This “solution” is shit though.** It’s such a negative way to drive adoption, and smells like a scam or a marketing ploy meant to scare you into doing something you’re not sure you want to do. I only include it here because it’s a valid reason that people have for adopting something new.

### Education

Most fear has to do with uncertainties and unknowns, and many of the fears listed above are unwarranted (or at least, I believe they are). By educating people and producing a lot of good, quality content, documentation, and examples for people to learn from, it will increase their confidence in choosing GraphQL for their next project.

### Solve The Hard Problems REST _Doesn’t_ Have

When you switch from REST to GraphQL, things change. You have to think about things differently - database queries aren’t quite so straightforward to optimize, N+1 queries can sneak in more easily, there are different attack vectors (eg. constructing a very large query and submitting it to the server), etc. REST may have _similar_ problems, but they’re not the same, and these problems can be some of the most daunting to approach when you get into GraphQL. The more that the community can mitigate these with libraries, documentation, and examples, the more people will feel comfortable.

### Build In The Open

This can point back to education in a sense as well, but mostly what I mean by this is that I think a key contributor to successful, widespread adoption of GraphQL will come from having an open and transparent approach to building GraphQL APIs. This can include things like building open source projects with it, sharing publicly via blog posts about experiences using GraphQL in real products, and contributing to the development of the community, spec, libraries, ecosystem, etc. in whatever ways possible. This I think will lend itself to trust from the developer community as a whole as well as enabling GraphQL to grow and mature more quickly and effectively.

### Standards And Conventions

Some people may shy away from this, but I think it’s _incredibly_ _important_. Currently one of the pain-points that I see in GraphQL is that there are no clearly defined naming conventions or standard ways of doing things. Sure, there are certain things that we have decided on such as how to do pagination, but what about naming fields? Should my mutations follow a format of “verbNoun” (eg. createUser), “nounVerb”, or something else entirely? What should my class/directory structure look like (I’m thinking about the ruby gem specifically here)? We don’t have to be prescriptive here and _force_ people into doing things a certain way, but true to my rails background, I believe in convention over configuration, and it would help to at least have some opinions about how these things should look. I’ve got a lot of reasons for this and hope to expand on it in a future post, but the most relevant for this conversation is simply that it gives people a starting place. The less of these things people have to sit and think about, the more easily they can pick it up and get going.

## Wrapping It Up

We've still got a lot of work to do around some of this stuff, and I'm excited to see the community continue to grow and thrive. I believe that these problems will be solved and that GraphQL will become the lingua franca of APIs. Let’s make it happen!

What do you think? Is there anything I missed? Do you think I'm dead wrong? What reasons do _you_ have for not adopting GraphQL? Drop your thoughts on the comments!

