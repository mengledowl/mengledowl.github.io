---
layout: post
title: 'Interview: GraphQL at Shopify with Evan Huus'
date: 2018-01-28 03:02:45.000000000 -06:00
categories:
- Interviews
tags: []
author: Matt Engledowl
permalink: "/2018/01/28/interview-graphql-at-shopify-with-evan-huus/"
---
Hey everyone!

I'm back with another interview, and this time I got an opportunity to sit down with Evan Huus, the developer lead on the API Patterns team at Shopify. Evan's team is responsible for the GraphQL API at Shopify. We got to talk about a range of different topics such as:

- The success story of Shopify's adoption of GraphQL and how that came about
- What benefits he has seen from adopting GraphQL on the server-side
- Shopify's ~6,000 word API design tutorial that guides their best practices for GraphQL/API design
- The shortcomings of the way mutations are currently handled in GraphQL
- Shopify's role in the new class-based API for graphql-ruby
- Lot's more!

Check out the video, and the full transcription, below!

(In case you missed it, last time I [interviewed Robert Mosolgo](/2017/12/21/interview-with-robert-mosolgo-creator-of-graphql-ruby/), creator of the graphql-ruby gem, and you should definitely check it out too!)

Direct link to video:&nbsp;[https://www.youtube.com/watch?v=kx27KM7ad6o](https://www.youtube.com/watch?v=kx27KM7ad6o)

**Show Notes**

Shopify: [https://www.shopify.com/](https://www.shopify.com/)

graphql-ruby gem: [https://github.com/rmosolgo/graphql-ruby](https://github.com/rmosolgo/graphql-ruby)

### Full Transcription

**Matt** : Hey everyone! Matt Engledowl here with GraphQLMe.com. I’ve got another interview for you all today. Last time we were [talking with Robert Mosolgo](/2017/12/21/interview-with-robert-mosolgo-creator-of-graphql-ruby/), who is the creator of the GraphQL-Ruby Gem. He also works at GitHub on their GraphQL API. If you haven’t watched that video yet, you should definitely go check it out. I thought it went really well. I really enjoyed that. I’ll probably leave a link somewhere to that so you can go check it out.

Today, like I said, I’ve got another one for you. Today we have Evan Huus from Shopify. He works on their GraphQL API. I don’t want to say too much, because he’s going to kind of give an introduction to himself. Welcome, Evan, and thank you for agreeing to do this.

**Evan** : Thanks for having me. It sounds really interesting. I’m looking forward to it.

**Matt** : Awesome. All right, so why don’t you just give us a little bit of a brief description of kind of who you are and what your background is.

**Evan** : I’m born and raised and living in Ottawa, which is the capital of Canada up here. I work at Shopify. I studied computer science. I’ve been with Shopify for a couple of years now. Right now I’m the developer lead on what we call our API Patterns Team, which is for all intents and purposes, our kind of GraphQL team right now.

**Matt** : Okay. So does that team just strictly GraphQL, or do you have other kind of responsibilities there?

**Evan** : We have some other responsibilities. GraphQL is kind of our main one. The API patterns as a phrase is extremely vague, obviously. But effectively kind of our primary task is GraphQL right now at Shopify.

**Matt** : Awesome. So why don’t you, for people who maybe don’t know much about Shopify, why don’t you give a little bit of a description of what Shopify is, what they do, and what it’s been like for you – what your experience has been like working there.

**Evan** : My experience working there has been fantastic. It’s a great company. So Shopify does software as a service e-commerce basically. You can sign-up with us and for a couple, I don’t know the prices right off the top of my head, but for some dollars per month you can set up an online store that we will host. You can use us to sell on other channels, on Facebook, or with a point of sale device. We kind of are the center of that business managing inventory, managing all that sort of thing.

**Matt** : Cool. So then what’s the story about Shopify making the decision to adopt GraphQL and kind of what’s the story behind that?

**Evan** : It’s an interesting one actually. We were kind of not looking specifically for APIs. We were not thinking about that as much. We were actually looking to rewrite our mobile apps. We had existing mobile apps that we weren’t entirely happy with and we were looking to rewrite those on top of a better tech stack and with some new kind of product requirements in mind. So we did a bunch of exploration of new technologies that might help us do that, including things like React Native and GraphQL, and some of those stuck and some of them didn’t. One of the ones that stuck was GraphQL.

So we did our mobile rewrite. We launched the new versions of our mobile apps last year on top of GraphQL. That kind of proved the technology for us. It was fantastic. A great experience. So it’s kind of just grown from there.

**Matt** : Okay. So you were basically just trying to rewrite your apps and GraphQL was almost, sounds like more, maybe not accidental, but that wasn’t quite the intention when you started out.

**Evan** : Yeah, it was definitely – it was solving a specific problem we had in terms of being able to build our mobile apps effectively. Obviously when we looked at it we saw that there were other possibilities to it, but we didn’t really embrace those wholeheartedly until we started building the mobile apps and realized how fantastic this was for any client kind of situation.

**Matt** : Okay. I’m curious what kind of problems you were trying to solve that ended up leading you to looking at GraphQL in the first place there.

**Evan** : A lot of it is that Shopify is a software as a service. Like we have a web admin interface and that’s been kind of our primary interface for a long time. We have both, like the web admin interface, then we have our iOS app and our Android app. All three of those, between the three of them, there’s a lot of duplication of logic, because we have to implement kind of the same business interface, the same business logic in all three.

We were looking at a way to kind of avoid that duplication basically, which is why I mentioned React Native, that’s one of the other things we explored earlier. React Native, you write kind of one app and it’ll run on both iOS and Android which was appealing to us for the same reason. GraphQL ended up kind of solving that problem for us in the sense that it lets you put a lot more business logic on the server. The business logic all lives in one place behind the API. Now iOS, Android and our web interface can all share in that so it only has to be implemented once instead of three times.

**Matt** : Yeah, that’s definitely nice to be able to do that. I know that’s one of the things you see pretty commonly with an API where you’ve got multiple different things. It’s always painful trying to figure out how can I not have to rewrite the same thing several times in all these different places. GraphQL obviously has solved that for you. So that’s really cool. So how long has it been since you all did that? I think you said a year, right?

**Evan** : Yeah, the rewritten versions of the mobile apps launched last October, so just over a year now.

**Matt** : Okay. Kind of pretty positive experience, or?

**Evan** : Yeah, absolutely. The whole – we rewrote the entire mobile app kind of from the time we settled on our tech stack, which included GraphQL, to the time we launched was only eight or nine months.

**Matt** : Oh, wow.

**Evan** : We reached complete parity basically with how that existed before for however many years. GraphQL has been a huge accelerating factor in that.

**Matt** : That’s awesome. I’m curious then, so, you know, when you started looking at using GraphQL, was it kind of something where someone on the team or several people on the team already had experience with it, or was it just, you know, no one had really looked at it before beyond maybe hearing about it and so you guys were just kind of jumping in head first?

**Evan** : It was an experiment, for sure. It was an experiment that was kind of - I’ve mentioned React Native twice now, so I’ll go for three times. It was an experiment that kind of came along with React Native. We were looking at a bunch of ways, I mean even at that point specifically to share between iOS and Android. We were looking at like Java to Objective C transpilers and React Native was one of the things that we signed off on our list of things to try. So we tried that. That is obviously in React very closely tied to GraphQL. So, yeah, we didn’t have any prior GraphQL experience to that. We eventually did not end up using React Native, but we liked kind of the pattern so much that we stopped with GraphQL.

**Matt** : That’s awesome. All right. So switching gears just a little bit here, when – kind of when you think back to the first, you know, when you were first starting to get into GraphQL and learning about it and implementing it, what was kind of the hardest part do you think to figure out?

**Evan** : Probably the design principles. The technology itself is, I don’t want to say self-explanatory, but reasonably straightforward. It’s very well documented. The spec is very clear. There’s a lot of good resources there around that. But, like, it’s also fairly flexible. It’s a spec, not a style guide. So you can write a lot of different approaches to APIs in GraphQL. Some of this today has kind of settled out.

There’s a lot if you go into the GraphQL Slack channel there’s a lot of people who will give good style advice on how your API should be laid out and sort of stylistic choices there. When we started a while ago, that was much less mature and it was a process for us to figure out. Like you shouldn’t put foreign ID references in your objects. You should just put object references because that’s kind of the power of GraphQL. Right? Things like that. It took us a while to build up a kind of a good understanding of the right way to build GraphQL APIs.

**Matt** : Okay, so is that something you kind of discovered as you were going along building the API? So going through maybe multiple production iterations? Or is it something that you figured out more in an exploratory phase before anything went out into production? Just out of curiosity.

**Evan** : It was something we figured out as we built, mostly before we hit production. But definitely there was a lot of iteration as we were building out various parts of the mobile app. So that team that was doing that had mobile developers and it had a couple of backend developers because we were building the API in parallel, so it was really great to be able to sit together and collaborate really closely with what the mobile developers needed, what the web server could provide, what GraphQL could provide and iterate extremely quickly on kind of both sides of that equation.

**Matt** : Yeah. It’s interesting, too, to me, you talk about collaborating with the mobile developers and that sort of thing. I have noticed, at least for myself, that there’s a difference between how I interact with – so I do backend mostly, working on APIs and stuff like that. I’ve noticed there’s a difference between how I interact with the front end developers, mobile developers, on REST APIs versus like now working with GraphQL. I’m curious if you’ve noticed any of that as well.

**Evan** : Yeah. Absolutely. It’s – because GraphQL is more flexible and more – like you can add a field and there’s no kind of cost, just hubbing a bunch of fields, like our – there’s a lot more. I guess there’s a lot more back and forth I would say. On our REST API, because the previous version of our mobile apps were powered by REST APIs. If the mobile app needed a particular transform, a particular piece of data, they would kind of do the work themselves usually of looking around trying to find like, “Is there an API I can get that data from? Do I have to make an extra call? Do I have to do a little math? Calculate it myself on the client,” whatever. Whereas now with GraphQL the first instinct of the mobile developer is always like, “Can you add a field for that please?” Usually that’s, it’s worked. It saves everybody a bunch of time. It’s been fantastic.

**Matt** : Another thing I’ve noticed, too, for me personally is like, a lot of times I would get the front end developers coming to me and asking, “Hey, how do I get this information?” and that sort of stuff. Especially because documentation is painful. What ends up happening is the documentation doesn’t get maintained that well. But with GraphQL the frontend developers tend to just live in graphiql and stuff like that. So when they’re trying to figure out where something is, they can just kind of drill in through that and figure everything out.

Would you say that, and I guess we kind of touched on this, would you say that the GraphQL implementation has been successful? Meaning has it accomplished what you were hoping to accomplish with it so far?

**Evan** : Yes, absolutely. It’s been fantastic. Our mobile app has – the development on our mobile app has been accelerated, which is kind of what we were looking for. We’ve been able to build a web – like our web admin, our iOS app, our android app without a significant amount of duplication. It’s done exactly what we’ve needed it to.

**Matt** : So, I guess I was about to ask what success looks like, but that’s basically what you just said. So what would you say – so I know we talk a lot about in the GraphQL community, especially when we’re pitching it, we talk about the benefits that you get on the front end. We even just talked about some of them - accelerating mobile development, that sort of thing. I’m curious what kind of benefits that you’ve seen from this transition on the server side, especially. And we can talk about both, I guess, but I’m really interested in seeing what kind of benefits you’ve seen there on backend.

**Evan** : Yeah. I think it – there’ve definitely been benefits on the backend. I think it’s kind of a mirror of the benefits that you see on the front end in a lot of ways. The fact that it is strongly typed, that things like nullability are kind of enforced at the schema level has forced us to think about our data models on the server more. It’s uncovered a bunch of places where maybe the data in our database was not as well formed as we thought it was. Like there were places that had nulls that we didn’t realize had nulls and bad column order, or things like that.

**Matt** : Okay. So looks like, did I lose you there for a second?

**Evan** : Sorry. It’s held us to a kind of a higher standard on the server side.

**Matt** : Okay, gotcha. Yeah. I think I lost you there for just a split second there. So you mentioned that it’s exposed a lot of places where your data maybe hasn’t been quite up to snuff. Can you expand on that any? Like what …

**Evan** : [Inaudible]

**Matt** : Are we having connectivity problems?

**Evan** : Yeah, let me drop my bandwidth a little bit. Sorry. Let’s try that again. What was your question?

**Matt** : Sure. So you mentioned that this kind of helped you discover that maybe some of your data wasn’t quite up to snuff, wasn’t quite as good as you would like it to be. So do you have any examples of maybe what you mean by that?

**Evan** : Yeah, sure. So we have, I don’t have a specific example, but we have a couple of fields that were, like we built them into our GraphQL API and we made them non-null, because from a business perspective they should not ever be null. Then we started getting exceptions internally because it turns out we had fields in our database for those rows, for a few rows, you know, not common, but that were null.

And our REST API, those had just been going out as null and it had always been the client’s responsibility to reconcile that with the fact that really there’s no reason for them to be null. But GraphQL kind of let us discover that those existed and forced us to figure out how to handle that properly internally. Which again, has kind of been a – makes it – we handle it once on the server now, and instead of handling it three times on the web, iOS and Android.

**Matt** : Right. Exactly. That’s really cool that just the way the type system and GraphQL can kind of lend itself to discovering that sort of stuff. I’m interested, too, so is there anything kind of interesting or unique about the implementation of the GraphQL API at Shopify?

**Evan** : A little bit in the short term. I mean we use the same GraphQL – we’re a ruby shop. So we use the same graphql-ruby gem that GitHub does, that Robert maintains. That’s been fantastic for us. But we do have our own definition layer on top of its API that we built internally, which actually is kind of making its way upstream right now, if anybody’s looked at the 1.8 pre-release branch for the graphql-ruby gem, the new class-based API that Robert has introduced is basically the internal layer that we have right now.

We spent some time kind of playing around with different approaches to that because we weren’t super happy with what the gem had by default. This is what we settled on. We’ve been talking with Robert. He’s a fan as well. So it’s kind of making its way upstream. That’s kind of the biggest difference, I guess, from the vanilla release version of the gem right now. Otherwise it’s pretty standard.

**Matt** : Cool. So, I mean, yeah, I talked to Robert on the last interview I did. We got to talk about that 1.8 release coming up. Hopefully I get that video released actually before it’s no longer in pre-release. Yeah, so that’s really interesting and really cool to me the way that Shopify and GitHub are kind of collaborating on that piece. Do you – is it pretty much exactly the way that you all do it what’s going into the 1.8 or is there – are there some differences?

**Evan** : There are some differences. I mean it’s not – like we didn’t hand them the code, because it’s also, it’s kind of tied in – our implementation is kind of tied into the rest of our Rails stack, which would be a little difficult to just extract and hand in a module upstream. But we definitely like it – we’ve been involved in the design discussions. Honestly there’s some things the 1.8 release will do a little better that just we’ve never had an opportunity to fix because it would’ve been work and it wasn’t worth it for us at the time. Yeah. It’s close but not exactly the same.

**Matt** : Yeah. Yeah. I mean it’s really cool, too. I finally got a chance to kind of pull down the pre-release and start playing around with it a little bit last week. I mean I like both ways of doing it, but I definitely think there’s a strong benefit to the new class-based API. It allows you to use a lot of the patterns that in ruby we’re used to being able to use with classes and objects and all that sort of stuff.

**Evan** : Yeah.

**Matt** : So with it not being exactly the same implementation, is the plan at Shopify to kind of move over to that implementation once it gets released, or are you planning to stay kind of with your custom layer on top of it?

**Evan** : We’ll migrate. I’m not entirely sure what that process is going to look like right now. I think kind of the first step is just rip out three-quarters of our custom layer and let the remaining quarter and then we’ll see what’s left in that remaining quarter that we actually needed to not have to rewrite every file.

We definitely, one of the benefits for us, absolutely, of moving this upstream was that we don’t have to maintain this custom layer to the same extent which is – I mean, it’s a lot of code. It’s nice to have it up in the public eye where it can benefit from all the powers of open source and all of that.

**Matt** : Right. Exactly. So one of the things I’m always really interested in is what kinds of things people do to keep their code clean and their APIs clean and usable and all of that. At Shopify have you all started to kind of center around any particular patterns for doing that?

**Evan** : Yeah. We’ve, I mean that’s kind of the job of my team. Right? The API Patterns Team, that’s our purpose of being right now is to kind of figure out what these patterns should be and spread them around and make sure our APIs are consistent, they’re clean and kind of well designed. So we have a ton of stuff.

We have about 6,000 words of a design tutorial document that’s kind of, this is not code at all. This is just how you design a good GraphQL API. Like the things I talked about earlier, not using actual IDs and using like object references - like everything from that to very high level kind of design principles that we kind of figure are helpful for people to make good APIs. Yeah. So we have – I’m not sure kind of what detail you’re looking for here, but there’s a ton of stuff that we do that’s kind of to drive that.

**Matt** : Yeah. Cool. I mean that’s really cool to me that you all have that document. I wish I could get my eyes on it. I’m sure that’s probably not something that you can really share publicly, but …

**Evan** : It’s pretty tied to some Shopify internal business domain stuff right now. A lot of the principles could probably be extracted into something public, but we haven’t done that yet. It’s something we should probably do at some point.

**Matt** : I know I at least would be really interested in kind of being able to take a look at that kind of information. Obviously the non-Shopify-specific pieces of it, but that’s like … One of the things I’m always really interested in and curious about are kind of the best practices and standards that people are starting to move towards with GraphQL specifically.

Because I know – and I talked about this in the last video as well with Robert. There’s not a lot of – or at least it doesn’t seem like there’s a lot of best practices out there just yet for GraphQL because it is still fairly new. So when I first started looking at GraphQL I went and looked at the best practices that they have on GraphQL.org. It’s just – there’s not a lot there yet.

One of the things I really am interested in trying to do is kind of as a community start to talk more about what best practices we think we should have and that sort of stuff. So do you have like any specific examples that you might be able to give from that? I know you can’t like really share the whole document, but…

**Evan** : Yeah. Actually, I want to touch on one thing first which is, I’ve been really quite impressed hanging around the GraphQL Slack channels, kind of how much natural convergence there has been. So often somebody will come along and say, “Hey, I’m building GraphQL. I’m looking for a best practice around X.” Three or four different people will all start typing and all of them will say, “Well, this isn’t really a best practice, this is just what we do. But we do thing,” and they all do the same thing. They’ve all kind of converged naturally on like the right answer to this question. I think there’s a lot of kind of informal best practices right now that you just need somebody to sit down and put them in a blog post and somebody to have a place to refer them all.

Internally, specifically at Shopify, we have, yes, we have that design document which kind of walks you through building an API for a specific part of Shopify. But it also extracts out into a bunch of rules at the end in order.

We’ve got things like our rule number ten is use enums for fields which can only take a specific set of values. It’s pretty standard stuff if you know kind of GraphQL has enums and that’s what you should use them for. It’s also, if you’re coming from a REST background which does not have the enums it’s important piece of knowledge to know. Some of our stuff is very specific. Some of it is basic like that.

Some of it is more – like we have a rule the API should provide business logic, not just data. Complex calculations should be done on the server in one place, not on the client in many places. I mean we’ve talked about that already. That was one of the key drivers for us to pick up GraphQL, being able to share that business logic on the server rather than on iOS and Android and the web and all of these different places. It also affects your design. It’s not just a philosophical principle that may not work. It affects the way you design your APIs, so it’s important we kind of spread that philosophy.

**Matt** : Yeah, definitely. I had a follow up question on that and I just totally lost it. Right out the window. So one of the things I see a lot of people, a lot of people that are not in the GraphQL world that are maybe just starting to look at it or have seen a little bit of information about it. Maybe they’ve played with it a little bit, maybe they haven’t. But just people that are kind of expressing concerns about using GraphQL, one of the things I see them bring up a lot is the fact you can’t really – because of the nature of GraphQL, you can’t really do the same kind of HTTP level caching that you can do with REST APIs.

I know that’s even something that kind of came up when I first started talking about it at my current job. It wasn’t like, oh we shouldn’t use this. It was like, well, this is something we get for free with REST, is there some way we can overcome this? So I’m curious, though, if just for those listening that maybe have that same kind of concern, is that something that has been a problem at Shopify, or just in general really have there been any performance bottlenecks that maybe you all have run into with GraphQL that are different from what you might run into with REST?

**Evan** : So specifically about caching, we haven’t had any problems with that. We’re in a bit of a unique situation maybe with our business domain, which is our APIs tend to be fairly live. We don’t have a lot of caching to begin with just because a lot of our stuff deals with money and you can’t cache a credit card transaction, stuff like that doesn’t fly.

**Matt** : Right.

**Evan** : So it’s not, even our REST APIs do not tend to have a lot of caching in front of them. In terms of performance, generally, obviously like there’s a performance penalty to doing the parsing and kind of having the complexity of GraphQL in front. But it results in reducing the number of requests and being able to be more precise about the data that you load when you’re resolving a request, usually. In the super early days we had some performance issues with parsing the actual GraphQL. This was back with the ruby gem had like a custom handwritten parser of some sort. But now it’s on [inaudible]I think, some sort of parsing framework that generates that kind of efficient parsing code and so that’s not a problem anymore for us.

**Matt** : Okay, cool. That’s interesting to me. I didn’t know that the gem had its own custom parsing logic at any point.

**Evan** : I think it did. I honestly, this was like two years ago. I know we went from the gem’s default. We wrote a C library, C bindings for a brief point because there was a very good C parser that Facebook published. Then we switched back to the upstream when that became more efficient.

**Matt** : Cool. So kind of along that same vein, how has – and I know we kind of talked about this before and there’s not a whole lot you can say about some of this probably, but I’m curious how scaling has looked in terms of both number of requests coming through your GraphQL API as well as what it has looked like in terms of scaling team-wise. Like the usage of GraphQL within the company.

**Evan** : Yeah, so, I mean tech-wise, I really can’t disclose a lot other to say it’s handling all of our mobile app traffic without any problems. That’s sort of hasn’t – scaling hasn’t been a problem for us. More kind of organizationally it’s been very interesting. So like we started with mobile. We launched our mobile app. Kind of that proved it out for us, and very quickly. So we had kind of, it became known in the company through various channels this was a technology, this was a great technology that we were very excited about. There was some buy-in from some of our senior executives, which really helped. So it was very organic.

There was a point where we were thinking maybe should we do some internal evangelism kind of try and spread the word a little bit, get more people using it. But for all practical purposes, we’ve had enough trouble keeping up with people who want to use it organically that we haven’t had to kind of go tell people about it. It’s just spread on its own.

**Matt** : Okay, that’s kind of cool. I was actually going to ask you about that, what it’s been like trying to get people to move into GraphQL. But it sounds like you’re not even having to really worry about that and you’re just getting people that are just really excited to be able to use it and so you don’t have to – I mean, have you had to bring people on that maybe don’t know a lot about GraphQL and kind of train them up, or has it been kind of people that are coming both with the thirst of I want to do GraphQL and I already have knowledge of GraphQL?

**Evan** : It’s mostly been – it’s been a lot of training. It’s been a lot of, we’re starting Project X and we need to do an API for it. I hear about – “I heard that GraphQL is really neat and should we use that?” So people come to us and say, “Here’s our problem space. Should we be using GraphQL?” The answer is usually, “Probably. Every situation is a little different, but here are the advantages. Here’s the value proposition for it.”

They come back, “Okay, that sounds great. Let’s do GraphQL.” How? Then we have more documentation. We send them to the GraphQL.org tutorial site, or whatever it is. We have some internal documentation. We send them our design guide I mentioned earlier. And kind of get them started that way.

**Matt** : Okay. So switching gears just a little bit here. If there was one thing that you could change about GraphQL, what would it be?

**Evan** : Mutations. I think that’s kind of maybe a standard answer in the community at this point. I know what’s in there for mutations right now is – it’s okay. It doesn’t have any major glaring fires in it. It’s also quite simple.

I think maybe as a function of Facebook is not a mutation-heavy company. Things you do with your Facebook API is you comment, you like and you post. That’s it. So they did not have a strong need for a more powerful mutation framework. So kind of the one in the spec has been straightforward. It works. It’s fine. It’s quite usable. It’s just when you get into a company like our API that has several dozen mutations already for everything from order manipulation, product manipulation, product collections, discounts. Like we have a huge swath of mutations already. It’s getting to be a bit hard to manage.

**Matt** : Okay. So I’m curious then if you have any kind of thoughts or ideas on what would be a more ideal way to do mutations.

**Evan** : That’s…

**Matt** : Sorry to put you on the spot there.

**Evan** : It’s something I’ve thought about. It’s a hard problem. It’s not – there isn’t an obvious answer necessarily. Like the one – the easy win, the only easy win is to provide a way for grouping them. To provide a way for saying these mutations go together and these – like namespaces basically. Right now the single global flat list is just a bit of a mess. But, I mean, there’s room for a lot more improvements than just namespacing, but they become a lot more complicated in terms of like we have a bunch of mutations that specifically deal with one type, with a product, for example.

We have a bunch of mutations specifically to deal with products. Should those kind of hang off the product type in our API? Is that, like, is there more room to kind of move the query side and the mutation side together potentially? It would be more discoverable that way for people kind of working with products. But there’s a bunch of technical questions around that as well. Namespaces, like if I had to waive my magic wand and add one thing to the spec it would be mutation namespaces. But everything else, there’s a lot of other room there, but I don’t know what that looks like in the end.

**Matt** : Yeah. I know one thing I’ve kind of run into as well with mutations that was like I still haven’t quite figured out is like mutations that have I guess nested arguments or nested objects. I mean, you can just kind of pass nested arguments for that. But I’m curious if you guys have seen that kind of problem and maybe what you have kind of decided on at least for now with mutations being somewhat limited to handle that. Hopefully that makes sense.

**Evan** : I’m not quite sure what problem you’re looking at. Is the nesting on return values or on inputs?

**Matt** : So specifically like – let me think of an example here. So let’s say that you had a user that has many products or something like that. You want to be able to update – this is a bad example. But essentially – or here we go. So one of the things that I’ve run into, a specific example, was polls where you could create a poll that had like questions in the poll and questions had potential like answers. So there’s like kind of this nested object structure.

So kind of what I ended up doing was just having nested input arguments that you send over in the mutation which worked alright, but I guess something about it still kind of felt clunky to me. So I don’t know if you guys have seen anything like that with what you are doing, if maybe you have a better solution than that or maybe I’m just being overly ambitious in how I want things to be able to happen with that. Just kind of curious about that.

**Evan** : Yeah, I mean, so – we do have some mutations that look like that as well. So for example like in Shopify products can have variants. Like your t-shirt can come in multiple sizes for example. When you’re creating your product, then the variants of that product are just a nested input that you can provide in exactly kind of the way you’re talking about. Yeah, I guess you’re right. It feels a little bit clunky sometimes. We haven’t really given it too much thought. I know kind of for broader things we’ve been trying to make our mutations fairly tight, fairly kind of single-purpose. Like when you create a product you can create it with variants.

But we also have a mutation specifically for editing a variant. You cannot edit a variant by editing the product. You have to edit the variant specifically with its own mutation. Part of the reason for that was to provide a little bit more breakdown because otherwise if you kind of did everything through nesting, what we found was that you ended up with only two or three top level objects that held all of your mutations. Basically everything happened through a product or an order. So like the mutation that we used for creating refunds is a refundCreate mutation. It’s not like a mutation on the order. It’s a mutation on the refund. Otherwise everything goes and ends up on order or ends up on product basically.

**Matt** : Yeah, I definitely agree. I see where that’s coming from. I know that I kind of noticed that as well if I wanted to make everything all just nested, like it was going to cause that kind of problem, that gets really painful, like especially if you’ve got something nested several levels deep that you want to change, having to build this hugely nested input argument to just send it is just a pain.

**Evan** : Yeah. I mean sometimes if you, atomicity is one of the other things, kind of transactions sort of that we’ve been looking at through mutations. Because right now you can’t really do that across multiple mutations. So if you want something, you want a change to be atomic, you need to do it all in kind of one large nested mutation. But outside of that use case we’ve been trying to do small flat mutations rather than big nested ones.

**Matt** : Yeah, definitely. I mean that’s interesting you bring up the atomic transactions. That’s something I know I’ve seen. It’s not something I’ve had to worry about yet, but I have thought about it and I have seen other people in the GraphQL Slack kind of bring that up. It’s just kind of an interesting problem, right, because, you know, there might be certain mutations that you only want them to stick if all of them occur at the same time, or sorry, occur correctly, successfully.

You’re right, like, in order to do that now you’d have to kind of have this nested input and stuff like that. I kind of wonder, just thinking through it right now if something like custom directives would potentially be able to be used for something like that. I’m not sure because I haven’t looked at it.

**Evan** : There are some options there that we’ve kind of thought about in abstract. We also considered like a start transaction mutation and an end transaction mutation. Because the mutations in your payload are guaranteed by the spec that they get run in order. So you run your start transaction mutation and you run all the mutations you want, and then you run your end of transaction mutation. But again, there’s a bunch of complications there. You end up kind of breaking the spec if one of the intermediate mutations fails. It’s not something that’s very well supported.

Again, I think it’s just a function of Facebook does not have a lot of these problems. They built it to solve their problems and they don’t have these problems, so it’s not something they ever put a lot of time into.

**Matt** : Yeah. I think it’ll be interesting to see kind of where the GraphQL community ends up taking things in the future kind of trying to solve these problems. Because they are coming up more and more frequently. Even other things like handling errors. We’ve seen a lot of people talking about that lately. So I think it’ll be interesting just seeing what ends up happening with that. I kind of wonder if something will be added to the spec to handle some of this kind of stuff at some point.

**Evan** : Errors specifically I think it was discussed at the last working group meeting. So, yeah, I imagine they’re looking at that for sure.

**Matt** : Yeah, definitely. So what is your favorite GraphQL resource, product, or library, etcetera?

**Evan** : The graphql-ruby gem. Robert’s been doing a fantastic job. It’s only going to get better when 1.8 comes out. Yeah, it powers – like we’re a ruby shop, so everything we do basically is ruby. It’s been a fantastic resource for us.

**Matt** : Awesome. Yeah, props to Robert. We’ve been using it as well. It’s been fantastic. I’m really looking forward to the 1.8 release. That’s been something I’ve been really excited about. I even kind of talk to my wife about it. She’s like, “I don’t know what you’re talking about.” But yeah, it’s super great library.

For those watching if you haven’t checked it out, if you’re curious about GraphQL and want to try it out and you are a ruby dev, even if you’re not, I guess, I would highly recommend checking out the ruby gem and I’ll leave the link to that.

So imagine that there’s a developer working at a company and this developer wants to start using GraphQL at their day job. What would be your advice to that person on how to bring that about?

**Evan** : My advice would be to understand the value proposition. I mean, GraphQL is, it solves a ton of problems that you have with REST. It solves a ton of problems that you have with other techs, too. It’s, I mean it’s, it solves specific problems. If you have those problems, then that’s your value proposition. You can go to your manager, or you can go to your executive or you can go to whoever is making the decision. You can say like, here are the problems we have, and here is why GraphQL solves those problems. Here is why GraphQL is great.

As we found with Shopify, that’s enough. The value proposition is pretty obvious. It’s pretty easy to understand, even if you’re not that technical really. So if you can get the buy-in from the right people, then all of that becomes really easy. I mean not that it is a silver bullet. There are situations where GraphQL is, you’re dealing with problems that GraphQL doesn’t solve or that are kind of tangential, in which case maybe it’s not the right choice. But for a lot of things it’s proven pretty useful for us so far.

**Matt** : Yeah, so along that same vein, you just mentioned that basically it’s not a silver bullet. There are situations where maybe it’s not the best option. So are there any situations where you would still choose to pick up REST as opposed to GraphQL?

**Evan** : Occasionally. Picking up REST specifically instead of GraphQL is not super common. We have a few places right now where we have – it’s almost not an API at this point. It’s like a server and a client that need to talk to each other. But they are only ever talking to each other. It’s not something that’s going to be public or used by anybody else.

There’s a very specific like single action that they need to provide, in which case a single REST POST is sufficient and enough. All of the value that GraphQL adds on top of &nbsp;- you know typing and flexibility and all of this stuff really starts to look more like complexity and less like benefit, so for kind of those specific one-off cases we still use REST and will for the foreseeable future.

In cases where it’s the competition is not REST, it’s a much different story. So like we have some stuff internally that does like RPC between some of our infrastructure services that uses, gees, what’s that? Avro? It’s not Avro. One of those kind of wire formats that’s used like to replace JSON basically.

**Matt** : Oh, gotcha.

**Evan** : So like potentially we could use GraphQL for those services as well, but it’s not quite the same level. It’s not as direct a competitor, so it’s not really – we talked about it, but it doesn’t mean being the right choice for those situations. It’s still sort of an API, but it’s not, not the same kind of API. It’s not a business logic API anymore, if that makes sense.

**Matt** : Yeah, yeah, definitely. GraphQL tends to make a lot more sense for business logic and places where you have data that it makes sense to model it as a graph and to request things that way. Yeah so, I mean, I would most of the time probably still lean for GraphQL over REST, but I agree there are some situations where it’s just such a small thing that it’s maybe not worth the additional overhead of GraphQL.

Even just not too long ago I had a client that I was freelancing for and actually integrating something, integrating their Shopify with another system that they had. I could’ve used GraphQL for that, but I only needed like two or three endpoints. It was like really basic, basically just take information from what happens in Shopify and stick it over here as well. It’s like, there would be no real – the benefits aren’t really there I guess is what I’m trying to say.

**Evan** : Yeah, exactly.

**Matt** : So, I think this will be my last question. What message would you have for someone who is kind of considering GraphQL but they just aren’t sure whether or not they should pull the trigger and whether or not it’s mature enough or if it’s going to have the longevity. When I’m picking up a new technology, it’s one thing to kind of mess around with it, play with it on weekend projects or things like that, but it’s, you know, if I’m going to be using something in production I want to feel fairly confident that in a couple of years when I’m still having to maintain this thing that the community’s still going to be there, the code is going to be maintained, that sort of stuff.

**Evan** : I mean, GraphQL is in an interesting spot from that regard because it’s only been public for a couple of years now. But kind of from a technical perspective, it was used internally at Facebook for like six or seven years prior to them kind of publishing it. I’m not entirely sure what the exact time line was there. But I mean, so yeah, it’s technically very mature already.

The community is a little younger. But that said, you’ve seen a huge amount of uptake. It’s being used already. It’s being used by IBM. It’s being used by Walmart. It’s being used by Shopify and GitHub and Facebook obviously. A lot of fairly substantial companies. It seems pretty safe. It seems like a pretty safe bet to me from that perspective. These are not companies that invest in technologies lightly. So if they put their money there, then it’s pretty safe for you to put your money there, too.

**Matt** : Yeah, I definitely agree with that. I said that was going to be my last question. I have one more that just kind of popped into my head. I’m curious if Shopify has done anything with subscriptions in GraphQL or not?

**Evan** : No. It’s definitely, it’s caught our eye. We’ve kind of done some really, really basic exploration of what that might mean. But we have no current kind of technology built around subscriptions. It’s – no. I can’t say anything about the future, but right now there’s nothing there.

**Matt** : Okay.

**Evan** : It’s something we’re interested in, but we have enough other work right now.

**Matt** : Yeah, definitely understand that. Yeah, I just know subscriptions are a pretty hot topic right now. I think most people are kind of where you’re at, where Shopify is at right now, or at least it sounds like anyway where it’s kind of more exploratory. This is really cool. This could be really useful but, not quite to the point of implementing yet, which is to be expected because it’s still fairly new.

**Evan** : Yeah, it’s the youngest, kind of the least mature part of the spec. It’s also, I mean I haven’t done a huge deal of research on this, but it’s not as clear to me what the value proposition is for subscriptions over Webhooks or other kind of more constructor things like Kafka also does kind of a pub/sub sort of style. Like I’m sure there are differences they wouldn’t just duplicate like that. It’s not as – GraphQL is really easy to sell in that respect. Like it’s really obvious that these are huge problems that it solves. Subscriptions, not as obvious.

**Matt** : Yeah. It’s interesting, too, talking to people in the community about it because there’s still so much that’s in flux with all of that anyway. I think that the primary thing that I’ve heard that is kind of the reason for subscriptions is like basically taking what you get from GraphQL like queries, being able to ask for exactly what you want and kind of taking that over into a live setting, so to speak. So, and everyone has different ideas about how that would happen.

Interesting that you brought up Webhooks. Me and – when I was talking with Robert in the last video, that actually came up. He was talking about GitHub looking at potentially using subscriptions in conjunction with Webhooks, which was like a really interesting idea. It’s something I’d never even considered. Yeah, really, really interesting.

**Evan** : Yeah. There’s definitely lots of room to explore here. It’s kind of – it is a much younger part of the ecosystem still. I’m sure in a year or two it’ll settle down. It’ll be a little clearer what it’s good for and what it’s not and kind of how to go about accomplishing that.

**Matt** : Yeah, definitely. All right, well, it looks like we are about out of time. Evan, thank you, man, for agreeing to do this. I really appreciate it. It’s been fun for me. I really, I just love being able to hang out and talk about GraphQL. Yeah, thank you for doing this.

**Evan** : Thank you for having me. Yeah, it’s a really exciting technology. It’s kind of fantastic to be able to work on it. I’m kind of happy to help spread the word as it were.

**Matt** : Yeah, definitely. Definitely with you on that one. Yeah, so thank you again. I’ll see you around.

**Evan** : Absolutely.

**Matt** : All right. See ya.

