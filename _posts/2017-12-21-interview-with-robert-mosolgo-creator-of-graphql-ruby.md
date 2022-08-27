---
layout: post
title: Interview with Robert Mosolgo - Creator of graphql-ruby
date: 2017-12-21 13:24:33.000000000 -06:00
categories:
- Interviews
tags: []
author: Matt Engledowl
permalink: "/2017/12/21/interview-with-robert-mosolgo-creator-of-graphql-ruby/"
---
Recently, I got the opportunity to sit down with Robert Mosolgo and interview him. For those of you that don't know, Robert is the creator of the graphql-ruby gem, and he also works at GitHub on the team that works on their GraphQL API (among several other things). This is something I've been looking forward to doing for a while now, and I'm very pleased with how it turned out!

We talked about a wide array of things such as:

- What it's like to work on GraphQL at GitHub
- GraphQL subscriptions in the gem and using them with ActionCable in Rails
- Future plans for the gem, including an all-new class-based API (currently in pre-release)
- Does GraphQL scale? How has scaling looked at GitHub for GraphQL?
- Best practices in GraphQL
- Lots more!

Have a listen, and let me know what you thought and if you'd like to see more of this kind of thing!

_Note: if you'd prefer to read rather than watch/listen, there is a full transcription of the interview below the show notes._

Direct link to video:&nbsp;[https://www.youtube.com/watch?v=6l6SqXDVZ\_4](https://www.youtube.com/watch?v=6l6SqXDVZ_4)

**Show Notes**

View the gem here: [https://github.com/rmosolgo/graphql-ruby](https://github.com/rmosolgo/graphql-ruby)

Documentation and getting started guides: [http://graphql-ruby.org/](http://graphql-ruby.org/)

Subscriptions documentation:&nbsp;[http://graphql-ruby.org/guides#Subscriptions](http://graphql-ruby.org/guides#Subscriptions)

How To GraphQL: [https://www.howtographql.com/](https://www.howtographql.com/)

GraphQL at Shopify talk:&nbsp;[https://www.youtube.com/watch?v=Wlu\_PWCjc6Y](https://www.youtube.com/watch?v=Wlu_PWCjc6Y)

GraphQL Slack: [https://graphql-slack.herokuapp.com/](https://graphql-slack.herokuapp.com/) (join us in #ruby!)

graphql-ruby Newsletter: [https://tinyletter.com/graphql-ruby](https://tinyletter.com/graphql-ruby)

Facebook TAO: [https://www.usenix.org/node/174510](https://www.usenix.org/node/174510)

Facebook TAO Paper (pdf):&nbsp;[https://www.usenix.org/system/files/conference/atc13/atc13-bronson.pdf](https://www.usenix.org/system/files/conference/atc13/atc13-bronson.pdf)

graphql-schema\_comparator:&nbsp;[https://github.com/xuorig/graphql-schema\_comparator](https://github.com/xuorig/graphql-schema_comparator)

graphql-batch: [https://github.com/Shopify/graphql-batch](https://github.com/Shopify/graphql-batch)

### Full Transcription

**Matt** : All right. Here we go. Hey everyone! This is Matt Engledowl from GraphQLme.com. I’m super excited today. We’ve got a little bit different format for you all than what I normally do with my blog posts. So today I’ve got Robert Mosolgo, I hope I’m pronouncing that right, on the line with us. For those of you who don’t know, Robert is the creator and primary maintainer of graphql-ruby the gem. He has agreed to hang out with us for a little while today and talk about the gem, his job at GitHub where he works on their GraphQL API, as well as just GraphQL in general. Like I said, I’m super excited about this. Thank you, Robert, for agreeing to do this. Welcome.

**Robert** : Yeah, thanks for having me. I’m looking forward to it.

**Matt** : Sweet. All right, let’s jump into it. Why don’t you just start out with a little bit of a brief introduction to who Robert is and kind of your background.

**Robert** : Yeah. My name is Robert Mosolgo. I live in Virginia. I work from home here for GitHub since May and been working from home for almost two years. Gosh, ruby is – I think it’s my first programming language, maybe SQL if that counts. I’ve been here for a little over, I did, you know, websites for a long time. Ruby is just going over five years. I’m a big Rails fan. I’ve been doing Rails development professionally for I guess 4 ½ years, ever since I did RailsTutorial.org. That was the beginning of my years. Yeah, I think that’s it for me. Like you mentioned, I work at GitHub. I’m part of the Ecosystem API team. We are responsible for REST APIs, Webhook, Payloads and the GraphQL API.

**Matt** : Oh wow.

**Robert** : It’s big, a lot to take care of.

**Matt** : Yeah.

**Robert** : It’s very fun.

**Matt** : Awesome. That’s more than I realized you were doing. I thought you were just doing the GraphQL API. That’s interesting you guys are handling the REST and like everything it seems, everything API wise.

**Robert** : Yeah. I definitely, my specialty is GraphQL, so I’m still good there, but as a team we take care of all those different things. They have some overlap, as I’m sure we’ll get to later.

**Matt** : Yeah. Cool. I mean, so what has it been like for you so far working at GitHub? It’s been since May, so not a super long time yet, but interested to hear how that’s going.

**Robert** : I would say getting started at GitHub I would call it a worthy challenge. Joining a big old system, “old” being 10 years. It is hard. The system is already complex. It already does a lot of things. There’s already a lot of history. So trying to absorb it all has been hard. But at the same time legacy systems get a bad rap, but for a system to become a legacy system is a badge of honor. It means it’s successful. I really enjoy learning the history of the application and the history of the teams that created it.

Then when it comes to maintaining and adding new features, you know, it’s harder than if you just typed Rails new and did whatever you wanted. It also has a much bigger impact, so I get a kick out of that too, working on that. Besides that, I mean the folks on my team are great. I’m a big fan of working from home. I feel like I’m productive and happy and get to be around my family.

**Matt** : The whole concept of a legacy system is kind of interesting to me. Kind of the industry I work in there’s not a whole lot of legacy in what I’m doing day to day, but I’ve had some experience in legacy systems. It seems like to me – so GitHub is what, 10 years old? Is that about right?

**Robert** : It was Rails 0.8 or 0.9.

**Matt** : Oh my gosh, that’s so early on. Yeah, so I mean it’s just kind of interesting to me because I’ve seen in my job prior to the one I’m at now, we had a lot of legacy systems and like stuff on the mainframes and stuff like that. So it’s kind of interesting to me to see the difference there between that and something like GitHub where even though it is legacy you’re still building on top of that with these newer technologies like GraphQL. GraphQL was announced a little over two years ago now, so not that old. I guess to me that’s just really cool to see that even though GitHub does have legacy systems there, there’s still this push to keep pushing the bar and keep moving forward and continuing to improve on it.

**Robert** : Yeah, it’s pretty typical for all the different teams at GitHub, whether it’s really back end database stuff or front end stuff to accept the fact the code base is old and you have to keep doing what it’s already doing but also looking for these places where you can incrementally and, what’s the word, like additively improve the system. Maintain compatibility and transition things over. It’s a fun challenge, just like you said.

**Matt** : Yeah. This is bringing up another interesting thing. I’m curious then what it has been like trying to put GraphQL on top of all this stuff. Like we said, it is legacy, so has it been a pretty big challenge or has it been relatively painless? I’m just kind of curious to hear about that.

**Robert** : For background, GitHub was using GraphQL for almost a year before I joined the team. So I wasn’t there for the initial setup. Like I said, I’ve been learning a lot of the history and their decisions and their advantages. I would say it was not easy. The reality of GraphQL is it’s easier for clients and harder for the server developers. There have been a few – I would say the biggest concepts that didn’t port easily, they have to do with the fact the team I’m on we did REST API plumbing for a long time before I was there. Now we do GraphQL API stuff. So we have a lot of concepts to carry over.

The biggest ones that are always on my mind is fetching data from the database efficiently and correctly and performing authorization correctly. If you think about GitHub.com, all the different ways that you can have access to different data, it’s a complicated system. Trying to take the code paths that we have from the REST API and apply all of that institutional knowledge to GraphQL has been an interesting challenge. It’s worked, which is nice, but it has been hard. I hope it’s easier for clients. That’s the good news.

**Matt** : Yeah. I would imagine it is. I know the front end guys on our teams have just loved GraphQL. I’m sure that people are much happier with GraphQL.

All right, so let’s talk a little bit about how you got into GraphQL. Can you tell us the story on that?

**Robert** : Sure. So it’s flashback to January 2015 I think was the first React Conf in Facebook headquarters. I went with a few of my teammates. I was so excited to be there. React was so hot, up and coming. We had all finally realized what a great idea it was. It was just one talk there called “Data Fetching at Facebook.” There were a few – it was a lot about the lifecycle of data as it comes from the server into the UI and just an offhand mention of GraphQL.

If you go back and watch the talk it’s really interesting because the syntax of the original language is very different from the current syntax. There’s a talk at the GraphQL Summit about that. When I saw what he was talking about, what they were talking about, and at the time I was doing full stack Rails. So we had react front end, a bunch of custom endpoints to the server, and then a lot of custom serializers on the back end. So he was talking about this flexible language that you could setup the whole system and then clients could query what they need. I thought, oh, this is what I want with custom endpoints. The issue for me is that I’d build custom endpoints and forget to ever remove them and so I end up with code that I can’t delete. That’s hard.

So I felt like I had a eureka moment there. That really caught my interest. It was about six months between that initial talk and release of the spec. I didn’t wait for the release to start coding on the gem. That night I went home and pushed an empty gem to the name GraphQL and I decided I was going to give it a shot. That was the beginning.

**Matt** : Nice. That’s awesome. When you think back to those first days, you jumped into it pretty hard it sounds like. For most people I feel like when they hear about GraphQL it’s like, “Oh yeah, I’d like to use that.” Then for you it was like, “Yeah, I’m going to create the gem for it.” That’s interesting to me. So what was it like when you were first starting to get into it? I mean you were really jumping into the thick of it there. What would you say were some of the most confusing things to start to grasp and understand so you could do that?

**Robert** : I think there’s really two things that were hard at that time. One of them didn’t have anything to do with GraphQL. It was just how to setup a ruby gem. A lot of the language related stuff, like building a parser. It was a lot of trial and error and just tweaking things until it actually works. The other thing is since that example language from the first slide was different it was also much harder to parse and execute. But then the other question, which is still a big one, which is the efficient and correct data fetching. That, you know, it sounds great to have this dynamic data language, but how do you do that in a way that’s not expensive and slow? Those were definitely the earliest challenges.

**Matt** : Okay, interesting. So when you say data fetching, I’m guessing you’re talking about the idea of batching requests and that sort of thing.

**Robert** : Yeah. It’s funny, because we sell GraphQL as like a solution to data fetching, but actually GraphQL also needs a solution to data fetching. It’s usually SQL queries, especially for Rails, but then there’s other stuff too. At GitHub it’s elasticsearch sometimes and we’re creating git back ends for data and files, contents, things like that. It’s especially SQL databases and a range of things.

**Matt** : I would say that’s one of my favorite things about GraphQL is that it’s not – a lot of people when they come into it seems like they’re really confused on that point. They think GraphQL is like a direct line into your database or something like that. In REST if I wanted to get this other thing from something other than a SQL database I would do this. How do I do that in GraphQL? But really GraphQL doesn’t care at all what your data layer looks like. It is just, it’s an API in the strictest form that it can be in that it’s just a way to communicate with your server to say ‘I want this information.’

**Robert** : Yeah. It’s new for us, especially from a Rails background. It requires a shift of your mindset.

**Matt** : Definitely agree with that. So what was it that kind of inspired you to actually write the gem? I know we talked about going to React Conf and seeing that, so I guess maybe that’s probably a big part of it.

**Robert** : Yeah, there was that, the kind of excitement and the very real understanding of what the problem is and how this could be a solution. The other thing was kind of more personal. Before React Conf our company must have been one of the biggest users of this JavaScript framework called batman.js. It is lost to history now, but it was kind of Shopify’s offering in the earliest days of Ember and Backbone. We invested in that a lot, but ultimately the project didn’t make it. We ripped off the Band-Aid and rewrote our front ends to react. I had really made an investment in learning and understanding and maintaining batman.js. So now I had all this technical excitement to direct somewhere else. GraphQL was there at the right time.

**Matt** : Okay, gotcha. That’s cool. I’ve never really been in on the ground floor of something like that. I’m sure that was interesting, especially at the very start of GraphQL.

**Robert** : Yeah, it was nice that in the earliest days of the gem nobody was really using it, so I had a lot of time to try it out.

**Matt** : Yeah. So do you have any statistics on when the first time you noticed someone was using it was?

**Robert** : That’s such a good question. Especially in those first few months, I guess I still do this, when you get an issue from someone knew or a good question, I always wonder who do they work for or what’s their use case. I guess it was really just over maybe a year and a half ago was when Shopify and GitHub both started showing interest. For me it was very scary and exciting. It worked okay, which is great, but it was really when it picked up.

**Matt** : That sounds like it would be pretty crazy to be doing your own kind of thing, working on something, and all of a sudden there’s these two huge tech companies like, ‘Hey, we want to use this.’

**Robert** : It was very exciting too, just whenever someone looks at the project and thinks, “Should I build this myself or use the one that’s already here?” I felt proud that someone decided that it wasn’t so bad that they should build their own, and instead – improvements.

**Matt** : Yeah, that’s really cool man. That’s really cool. So I know we kind of talked about this before today, one of the things we really wanted to talk about was subscriptions. I know that’s a pretty hot topic right now in the GraphQL world. A lot of people are talking about what subscriptions are, what they look like and all that. I know – I believe it was just within the last couple of months the graphql-ruby gem got support for subscriptions. I mean I’d love to talk about that. That’s really interesting to me. I was really excited when I saw that it dropped. Unfortunately I haven’t had a chance to do anything with it yet. I’d just like to get your thoughts on that and, you know, how everything kind of works right now.

**Robert** : Yeah, that would be fun to talk about. I’m really excited about it getting released, too. It was a lot of work and yet another kind of – I had to really wrap my head around it. I think the thing that was most interesting about building a subscription system is that it’s out of the Rails comfort zone. The best situation for Ruby on Rails is a database full of data, the beginning of an http request, do something with the database, give a response, and then you’re done. It’s a stateless system in that way that you don’t have to keep track of who’s using it and what they’re doing.

With subscriptions, you have to keep a state of who is waiting on what data. That was something the first implementation I released was built on Action Cable, a Rails 5 Websocket framework. That was a really great fit because Action Cable takes care of a lot of that client state stuff. From the browser they open up a Websocket connection. We can use the in-memory connection object to store the data we need to push updates. If the connection is lost, for example the client loses connection, or you restart your servers, what will happen is the client will actively try to reconnect. So whenever they reconnect it creates a new subscription and they get their data back.

That was a big win. I think before GraphQL when we needed a push update the way we would do it was basically an after-save hook on Rails models. So whenever it saves we would call to\_json and push it out to whatever clients needed it. That has all the same problems as a REST API. You get too much data or you don’t get enough data. It’s kind of a waste of time and energy on both sides. I’ll be looking forward to how subscriptions shape up, all their different ways to solve those problems.

**Matt** : Yeah, it’s interesting, we’re still so early in subscriptions in general, even as a community. I’ve listened to a few other people talk about subscriptions in GraphQL in general. It still seems like there’s a lot in flux in terms of like how people think it should be done.

Personally, I’m really interested in the idea of it being just as, again, kind of like we what we were talking about earlier with GraphQL in general, just being as agnostic as possible. Like I said, I haven’t really gotten a chance to look at the implementation in the ruby gem too much yet. I spent maybe 15 minutes on it one day. That’s not really enough time to implement anything. Is it something where it’s pretty agnostic where it doesn’t care if you’re using something like Action Cable or something other than that like redis or some other kind of back end, or is it currently more tightly coupled with Action Cable or something like that?

**Robert** : Good question. I think it does fill your dreams, so I think you’ll be happy.

**Matt** : Awesome.

**Robert** : From that point of view, subscriptions, it’s really a contract between client and server and then how those promises get fulfilled is up to you, which is a blessing and a curse, right? Because what that means is for every application and every deployment environment and every budget, there’s going to be different solutions that work.

At the last GraphQL summit there was a little bit of history from Facebook’s first implementation of this which was super interesting. They said before we had subscriptions over Pub/Sub channel, the way we did it was like this. On the client they had a query that whenever something changed they needed to refresh the data. What they did is they just had a like when an event happened on the server, the server would send a ping to the client and say, ‘hey, such and such event happened.’ The client could take the query that it already knew it cared about and poll for a new response. So it was essentially a little bit optimized version of polling, that whenever these events happened the client knew it needed to refresh its data.

The fact that that’s the history I think shows the flexibility of the concept. You can implement subscriptions in a way that doesn’t really – I guess it does have two way communications with how this works, but you could even implement subscriptions over a polling-only environment where the server is just – or the client is just asking, “Did my event happen? Did my event happen?” So I built it on Action Cable because if you just want to experiment you can do Rails new and give it a try.

Recently as part of GraphQL::Pro, a kind of paid add-on to graphql-ruby, trying to make it more sustainable there, I did an implementation with a redis backend with transport over Pusher. In the past I’ve used Pusher a ton and it’s a rock solid third-party Pub/Sub channel that you don’t have to mess with your Rails deployment to get that interaction. I’m looking forward to seeing more experimentation in that space. At GitHub in particular one of the ways we integrate with other software is through Webhooks. The reality is you could implement GraphQL subscriptions via Webhooks, which would be very cool.

**Matt** : Interesting.

**Robert** : Your, you know, Travis CI. You could give us, you could say, hey, I want to subscribe to this data whenever someone pushes a repository, send us this response. Usually we talk about doing that over a Websocket, but we could also do it over a Webhook. There’s no long-lasting connection there, but we just update them with the data they want. So I hope that it’ll be fun to see how that pans out. It’s something I’m really excited about.

**Matt** : Yeah, that’s really interesting. I never thought about the idea of doing something like that with a Webhook. Normally when I’m thinking about it I’m thinking about Websockets and I think that’s what most people probably think about is Websockets. And maybe people think about polling, too. But this idea of a Webhook, that’s really interesting.

I mean, and again, that’s what I love about GraphQL, one of the things anyway, just it really doesn’t care how you do it. I’m hoping that can kind of lend itself to the longevity of GraphQL in general. I would start to get really concerned if I saw GraphQL trying to say, ‘Oh yeah, we’re going to use this really specific things and put it in the spec,’ and all this, because at that point there is a big danger that GraphQL will die with those other things if they come to an end, which that’s one of the few things we can be certain of in software is that eventually just about everything is going to die. It’s going to happen. That’s a really interesting concept.

Is that something that you all at GitHub have spent much time actually trying out, or is it kind of just like a thing that’s in the back of your mind like, ‘Oh, this is something maybe we’ll try?’

**Robert** : I would say we haven’t tried to implement it, but we’ve sketched out what the system could look like, what are the advantages and disadvantages, how could we implement it. We have a few other things that are on our list first, so we’re taking care of that first. But I’d say, I hope this time next year we’d have something like that. Sorry to my team who I just committed. That was a non [inaudible] but it’s definitely on our radar.

**Matt** : Awesome. All right, looking forward to seeing it next year then. Kidding. Just kidding. For the listeners, that was not a commitment, again. That’s really cool. I just love hearing these different ideas that people have about what different things that we can do with these really high level concepts that GraphQL gives us. That’s really cool. Have you seen anyone using subscriptions in the ruby gem yet, or is that something that’s – maybe you’re not sure, I don’t know.

**Robert** : I laugh because the only way I know if something is being used is if I get a bug report about it. There have been bug reports about subscriptions, which means people are using it.

**Matt** : There you go.

**Robert** : It’s a challenge because it’s built with some technologies that I’m not as familiar with. So there are some improvements to the Action Cable side of things and some improvements to the JavaScript Client. That’s – my JavaScript was good in like 2015. My skills have not improved dramatically since then. There’s – some people have offered suggestions there, which is great.

**Matt** : There you go. Yeah. I can’t say anything. I’m not much of a JavaScript guy. It’s not something I’ve spent a ton of time with. I can get around just fine, but you know, I’ve spent most of my time up until now in the last few years anyway, focusing on ruby.

**Robert** : Yeah, I always think back to my friend who said the best way to get a good answer on the internet is to provide a wrong answer. Somebody will definitely – that approach has worked okay.

**Matt** : That’s awesome. I love that. I’m going to have to remember that. That’s interesting for me, too, because I’ve been blogging a lot. Sometimes I don’t know what the hell I’m saying, I’m just putting my thoughts out there. A lot of what I’m trying to do is get myself and other people to a place where, what’s the correct answer for this and what’s the right way to do this kind of stuff. I don’t always know what that is. I like that. Cool. So what would you say was the hardest part about creating the gem?

**Robert** : That’s an interesting question. I’m going to extend the question to include maintaining the gem, because the creation is ongoing.

**Matt** : Right.

**Robert** : I would say, I think for me there’s been a big learning process in how, let’s say you have a system and you know how it should behave and you need to create a ruby API for other developers. That’s been the biggest learning process for me because, especially getting started and really until now, the ruby APIs for GraphQL have been built for me, the person creating them, testing them, and consuming them as a power user in the sense that I’m very familiar with all the internals. I’m familiar with my own preferences. That worked great when the visibility of GraphQL was very small and the user base was very small.

But I think as people – as the spotlight turns toward GraphQL more, some of the bad choices in the first round of API development are – they’re not welcoming to new people. Instead of being something very familiar, something you can get started with quickly, they’re, I think power users, people who have been using it for a long time, to them it makes sense. To them they appreciate the freedom. But I’d like to do a better job of like a Rails style kind of 0 to 60, getting started, good defaults.

It’s been hard trying to find that right spot. One of the great things about working at GitHub is that since the whole team is working on this, and there’s a lot more people at GitHub who consume the ruby API, I have a lot of great support from them in terms of improving it. It’s been the hardest thing, but it’s also something I’m looking forward to improving.

**Matt** : Gotcha. Yeah. I mean I can kind of seen that. I’ve never built a gem. I can imagine I would put a lot of things in there that don’t necessarily make sense from a Ruby or Rails defaults sense, if that makes sense.

**Robert** : There’s things that can really be quantitatively improved. Like if a benchmark is bad, there’s just some steps you can follow to improve the benchmark. But what if when people come to the home page it doesn’t click. Like I don’t know how to fix that. Probably somebody knows. You can find me on GitHub and open me an issue. I’d appreciate that.

**Matt** : There you go. You know, it’s interesting, too, because I think a lot of this, there’s two aspects to it. Right? There’s the part that you’re talking about which is getting started with the gem itself. Then there’s also, for newcomers to GraphQL in general, there’s a lot of very different concepts and mindsets that you have to have that are just, it’s just so different from REST. You take some of those ideas with you, like the idea of a GET or a POST request or whatever.

But there’s all this other stuff that GraphQL has on top of it that makes it – it’s just different. It takes some time to kind of get there. I think that it’s interesting to me to see how those two things kind of play together and intermingle because part of it is that we need to have a way for people – or have a library that makes sense to people but also just helping people understand the basic concepts of GraphQL in general.

**Robert** : Bridge that and cater to both, that’s the challenge.

**Matt** : Right.

**Robert** : Maybe I can say this time next year I hope the story’s a lot better.

**Matt** : There you go. Yeah. I’m hoping to see the GraphQL community in general get better with some of that. I think there have been a lot of good steps towards that recently. Like I know the “How to GraphQL” website, that’s fairly new. Just a lot of stuff like that. There’s still a lot of work to be done, though. Super grateful to those people out there that are doing that kind of stuff and people like you who are jumping on the leading edge of this to create the libraries and the tooling and all of that stuff that goes along with this and try to like – this is a hard task to make anything really as simple as possible for people to use, especially when you’ve got a wide array of people.

I think we kind of touched on this already, but is there anything about the gem that kind of gives you heartburn, where you wish, oh, I should’ve done this just a little bit different. Is there anything like specific?

**Robert** : Yeah, there’s a lot. If you ever look at any code that you wrote six months ago you think, oh, I was so into doing that then. Now I know better. There’s just two and a half years of that. The good news is that it works. That’s also the bad news, it’s hard to replace because it already works and people don’t mind. So I think, you know, there’s the usability issue that we were just talking about. Gosh, besides that, I mean, there’s the relay support and some of the language oriented tooling. That’s some of the oldest stuff that I haven’t revisited. I guess it only gives me heartburn because it was my past self.

**Matt** : Yeah, definitely understand that. Are there any things you specifically are planning to kind of change there and improve?

**Robert** : I think one mindset that I want to leverage more is using classes in ruby. In my earliest versions of the ruby gem until now, I thought of GraphQL in a way that classes didn’t seem like a good choice. But I realized that it’s a good way to make things more familiar is to use classes and use methods.

Another advantage besides making it more familiar is that people can use familiar techniques to customize the behavior and to build tooling and libraries on top. When it comes to defining a schema for example, actually there’s 1.8.0-pre was just released last week that you can define a schema using ruby class definitions instead.

**Matt** :&nbsp;Oh, wow.

**Robert** : Yeah, we just on Friday released a few, converted a few definitions from the old way to the new way and deployed it to GitHub.com. It hasn’t crashed, which is great. Maybe I should - let’s see. Just kidding. And hoping to replace a few more for APIs that way. Because one thing, I chat with people from Shopify a lot. They’ve had a lot of success building on top of – someone or some people there identified early the APIs that graphql-ruby exposed were not going to work well for their team. So they built some other stuff on top.

When it comes to things I want to change, I basically ask Shopify, a few friends who work there, “What has worked well for you? Is there anything we can borrow?” That’s been really successful. Using classes to define the schema from Shopify’s first talk about using graphql-ruby, something they introduced. It’s nice to be moving those changes into the mainstream.

**Matt** : Yeah, that’s interesting. I know I’ve heard – I don’t remember if I watched that talk or not, but I know I’ve at least seen people talking about that idea in the slack channel. I’m kind of curious, though, and this might be a little bit too technical without being able to look at code, but I’m really curious how this new concept is going to differ from using something like the GraphQL::Function idea that’s in the gem currently. Is there – how does that work differently than that?

**Robert** : I would say it’s similar. GraphQL::Function is a class that when you want to have reusable result behavior you can extend this class and define the types that it returns and the actual execution behavior. I think it was a step in the right direction from the perspective of using classes and allowing people to use inheritance to share code. But there is a design flaw in GraphQL::Function, from my perspective, that the lifetime of the object was very long. When the application started the function was initialized. It was expected to be this stateless object that took input, performed some calculation and returned outputs. But it was made in such a way because there’s an object instance, people wanted to assign instance variables. That’s not stateless. So while the application was running state could leak from one request to the other.

Now when I think about the API, I realized it was a foot gut. In the ruby world there are a few classes that work like that. For example, Rack middleware and Rack applications, they start at the beginning, they start during the boot, and they live for the entire life of the application. But there are more examples, especially in Rails, of short lived objects, like a controller where a request came in. It’s time to do some calculations. We’re going to do it. Then we throw away that controller. One thing I’m trying to do with this new API is make the object life cycle more predictable and less dangerous. One of the differences.

**Matt** : Okay. Gotcha. Yeah. I’ll have to take a look at how in terms of the code itself, how that’s different. That sounds really interesting to me. I know that, I mean I just recently refactored some of the code that I had to use to utilize those function objects a lot more. Even just doing that, I mean even stuff I’m not reusing I’m using those for that. I don’t know if maybe that’s a bad idea or not, but it made my schema definition look much nicer to just pull all that stuff. You know, I don’t have a massive schema, but it was already starting to get kind of gross. Even with pulling just the resolve function out to its own resolver, like I still had all this extra stuff in there. I just want to be able to look through this and see the different fields that I have at this level and just to be able to pull that out was really nice. I’m really curious how all that looks with this new class architecture.

**Robert** : Yeah, sure. Really take a look, because I’m definitely supporting all of the old stuff for a long time, but I hope that the new things can be good enough that people will be excited about migrating.

**Matt** : Yeah, that sounds cool. So it’s already in a pre-release, right?

**Robert** : Yeah. It’s RubyGems feature that you can have this if you put letters at the end of your version it’s not downloaded by default. You have to opt-in “dash-dash-pre.”

**Matt** : Okay. Gotcha.

**Robert** : So I did that so that I could be testing stuff out inside GitHub. Probably in the next couple of weeks we’ll have 1.8.0 that the feature will be there for people who choose to use it. Yeah, a few more friends at different companies who are trying it on their APIs, just gotta make sure it still works.

**Matt** : Yeah. That’s cool man. I’m really looking forward to that. That’ll be neat to look into. So we kind of talked about what gives you heartburn about the gem. So what would you say you’re most proud of in regards to the gem?

**Robert** : Oh, definitely like the community, I guess. It’s been fun to be right at the center of these different people coming from different sort of different business problems and different stages of their career, and different interests and different styles, big companies and small companies. To watch people kind of chew on these ideas and give different opinions. I always tease that it’s the first time I’ve had internet friends. Even with us, we’ve been chatting for a long time. The folks I work with at GitHub now, that’s how I met them first. That’s just been really fun.

It’s – I feel kind of blessed to be right at the beginning of it where all these different people are coming in and sharing ideas. That’s definitely been the most fun. When you see – it’s fun to see someone who wrote a blog post about using a project that you work on, but you didn’t know who that person was or that they were using it. It’s very rewarding.

**Matt** : Yeah. I’ve really enjoyed the community as well. Yeah. It is really neat, like you said, just seeing all these different ways that people are using something that you just never would have thought of ever. So that’s been really cool.

So like where, for people that are listening that are maybe not really involved with the community at all, what kind of places would you say there are for the community?

**Robert** : Definitely there’s a GraphQL Slack that you can join, and there’s a #ruby channel. That’s where I am all the time. In the early days I could keep up with everything. Now I can’t. Also, there are a lot of people who have had a lot of success with GraphQL in there. It’s beautiful to see a question come and I don’t answer it and someone else does and they give a better answer than I would have anyways. Slack is a great resource.

In terms of keeping up with feature development and bugs, it’s all done on GitHub. Even if I’m making changes myself, I open a pull request and merge it just for visibility. I’m a big user of the GitHub notifications page. I love doing stuff that way. There are a lot of like these questions that I know they are an issue and I don’t know how to solve it, I open an issue there and hope someone will come save me. And sometimes it works.

**Matt** : That’s interesting. So you kind of use the issue system as a cry for help.

**Robert** : The last thing too is I keep a newsletter. When I do, it’s almost exclusively gem releases, but when there’s a new version, that’s where I announce it. If you want a low number of interruptions, that’s the best place for that.

**Matt** : Awesome. I’ll make sure I include links to the things we just discussed in the description below the video. I know I definitely hang out in the Slack channel more than anything else. I don’t even think I hang out anywhere else. I don’t know if they’ve got like an IRC or anything like that. Do people still do that?

**Robert** : Personally, I got on Slack because the GraphQL folks made a slack. IRC has some advantages, like it gets logged everywhere. It’s free forever. There are a lot of different clients. But Slack is good for now.

**Matt** : I mean, I didn’t mean that as like a stab at IRC. I just haven’t used it in a while. I’m not real – I haven’t kept up with how much of the community and programming community is still using IRC just because a lot of stuff has cropped up on Slack and it’s easier for me to have Slack open than Slack and IRC because we use Slack at work. It’s just easier. That’s an interesting dynamic there. So what kind of cool things are in the pipeline for the gem?

**Robert** : There are a few problems to solve at GitHub that I’m looking forward to solving and upstreaming the solutions. One of them is that we have a GraphQL schema that people are using, but we know in the future that there are breaking changes we have to make.

For example, we modeled things in such a way that it’s not quite right for our data and we’re going to need to change that a little bit. There’s two ways to solve that problem. One, just don’t break it. You can think of a new name. You can always make additive changes to the schema. That’s great. Maybe that’s what we’ll do. Another solution that’s really interesting to me is – and we’ll see if this works, but providing some kind of like time based versioning. This would be stealing a page out of Stripe’s book. Their REST API, I think the way it works is you send a header that says, “Here’s a request, treat it like the API is on such and such a date.” So as they change their API they also this kind of pipeline of changes that depending on how the request comes in, they say, “Oh, we need to use this version of the API.”

I think there’s some really interesting possibilities there for GraphQL. For example, let’s say you have a field that returns an object, but in reality you need to change that to become a union. Sometimes it’s the object it previously was. Other times it’s something else. In order to maintain compatibility there the change is static in the sense that you can take the incoming query string, apply a transformation and the output is a valid query string. I don’t know if we’ll end up building that or not, but I’m personally so interested in it. It’s something I’m going to look at.

Another big one for us is a lot of the views on GitHub.com are built from static queries. They’re hardcoded in the application. Actually a lot of the views, the top of it, is a GraphQL query for the data view. So we know what a lot of these queries are, but we spend a lot of run time, energy, preparing that query, not parsing it. We parse it ahead of time. But we still have to do some preparation to execute it.

One of the items on my list is to build a better system for prepared queries, where we frontload as much of the work as we can to reduce the overhead of repeatedly executing it. HackerOne is another company I know for their REST API they use hardcoded queries to build the payload and then deliver it. I think there’s a good use case for that. Let’s see, besides that, when the class API thing settles down a little bit, I’m looking forward to defining a class for custom directives.

**Matt** : Okay.

**Robert** : We’re chatting with people who, for example, for internal use at GitHub we have a directive called Recurse. That’s for when the data is retrieved that can be infinitely nested. In the GraphQL spec that’s forbidden, but we want it anyways. So execution code right now is monkey patched to deliver this when the time is right. It would be great to provide first class API for that. There are a lot of interesting things that can be prototyped that way if we have the right support for it. That one’s on my short list. I have some ideas, so hopefully soon.

**Matt** : Cool. I know I’ve seen a lot of people in the #ruby channel ask about custom directives. I’m sure there’s a lot of people who would be really excited about that in particular. That’s really cool, man. Looking forward to that. I haven’t really – I guess I don’t think about directives that much because I’m on the backend. It’s just not something I think about. I know we – there are some places I’ve seen our front end guys using that. I’m sure that they would be really interested in being able to have a custom directive. There’s even a few things I can think of off the top of my head that they might be able to use that for. That’ll be exciting.

So what kind of things do you tend to see people struggle the most with when they first get into GraphQL?

**Robert** : I think, gosh, some of it is stuff we talked about before. Especially for people who have done Rails for a while and we know the techniques to efficiently load data from the database and they see this new thing, that’s the first thing. There’s going to be n+1 queries. There’s going to be [inaudible] of database. That’s the thing you struggle with at the beginning and continue to struggle with through the whole time.

There’s a short paper from Facebook from a couple years ago about their backend architecture called TAO. It’s really eye opening to give that a little read because it describes basically why data fetching is not a problem for GraphQL. In fact, the development for them went the other way. First they developed this really scalable kind of, what do I want to call it? Distributed, cacheable data layer. GraphQL is built on top of that. In my mind it’s like we need a better data layer underneath GraphQL to be used on Rails. That doesn’t exist yet.

Another one I think catches people is the authorization question. They see incoming requests for data with all this flexibility. They want to know, you know, coming from a REST resourced-based background, we say we have User A and Object B. We’re going to check to see if they’re allowed to see it. That’s it. But with all of these different objects, all of these different fields, you really have to change your unit of works so that inside a query each object and maybe each field is being checked for the given user. It’s a much more complicated setup. I think it takes some getting used to.

**Matt** : Yeah, it’s definitely a lot. So in my mind there’s definitely pros and cons there. It’s a lot more granular, which is both a headache and really nice, because it means, like you said, you have to think of these things in much smaller units, but you can think about them in much smaller units. Especially if you’ve got a couple of really small things that it’s like, okay, it’s going to change depending on who’s logged in whether or not they can see this piece of data. That makes it easier to distinguish between those two things, like the authorization for them.

But, you know, it is an interesting mind shift because there’s a lot more that can go into it. If you’ve got a really basic authorization scheme, like hey, people that are logged in can see everything. Or we’ve got like two user roles, that tends to be pretty straight forward. With something like GitHub I can imagine that the authorization there gets a lot more sticky and crazy and twisted all up inside of each other, and stuff like that.

**Robert** : Yeah. Although the other thing is that it’s the kind of structure that it provided made it possible to migrate. We had all this authorization for the REST API that said, “Can User A see Object B?” What we did is extract each of those operations into a separate method as it is and instead of – it used to be that for each request. We make an authorization check once. Now while the query runs for each object that we get, we call this and make sure it still works. It’s kind of cool finding a way to fit those together. It’s surprisingly possible.

**Matt** : Yeah. Yep. So what – a lot of what I’m really interested in right now is best practices in GraphQL because I feel like we’re still early on enough in the scope of GraphQL that there aren’t a lot of resources out there for people when they first come in that say like, “Here’s some of the best practices.” If you go to GraphQL.org they’ve got a section on it. I think it has two or three things in it. It’s not real long.

I remember when I first started getting into it, that’s one of the first things I did was, “Oh, let me go look at this before I start building stuff.” It’s – to be honest, I was a little bit disappointed. One of the things I’m always trying to think about is what are those best practices? Does GitHub have any kind of best practices that they’ve put in place for using GraphQL, or maybe you yourself just best practices that you adhere to that you would like to share?

**Robert** : Yeah, that’s a good question. I think, especially for people from a Rails background where best practice is so baked into how we work, that’s something that we really miss when it comes to GraphQL. There, one of the cool things about GitHub’s system is that they make a lot of use of linters. Not just Rubocop making sure the white space is okay, but a lot of things that make sure such and such a method is powerful but is also easy to misuse.

So we search for usages in the project and make sure it’s being used properly. We have a few things like that to enforce like type and field names are consistent, to some things like if a field is boolean you want it to be like, “is such and such” or “can such and such” or “has such and such.” Kind of phrased that way, predicate I guess.

Another one that we use is, we kind of monkey patch into Rails’ association loading and keep an eye on when associations are actually loaded from the database. The reason we do that is we want to make sure things are properly batched. That data is only loaded while GraphQL batch is running. That one’s been a little bit tricky, but it helps us sleep better at night knowing that more or less as expected.

There are a few things that are like being developed and merged as we speak that I’m looking forward to publishing more about. One is deprecation. So we have parts of the GraphQL schema that are going to go away. There’s been a lot of thinking about how to deprecate it and the work is getting done now, too. Building enough ruby system to keep track of what we’re going to deprecate and then also building a kind of way to notify clients. “Hey, June 1st is coming. These fields are going to be deprecated. Here’s where you can learn more about how to update your code.” That will be a really big one.

Another one is just good practice for mutations. As much as, when it comes to authorizing a query, it’s straightforward. You just check each thing. For mutations, so many objects are loaded into that execution behavior, and then some important work is done and an object is returned. But you really need the authorization to be during the execution of the mutation. So we’re trying to take a better look at how we authorize those things. Then when errors go wrong, how do we tell those to the client in a way that’s accurate and useful. Those are more in progress, but looking forward to figuring those out, how to make schema work better. And personally interested in upstreaming those to the ruby gem also so that people who look for a best practice in that area have something they can find. That would be really nice.

**Matt** : Yeah, that would definitely be awesome to be able to have some of these best practices, at least in some manner, baked in for people to see. I’m really interested in the error handling thing. Do you guys have any – have you actually outlined anything on that, or is it something that’s still pretty early on, like in an early draft phase or something like that?

**Robert** : We have a plan that sounds good on paper and we’re starting to apply it to specific mutations one at a time. But basically the idea is if you’ve ever used like, I think Rails to\_json does this or something where you make a request and the data you provided was invalid and you get back like a list of errors with a field name and the text of the error.

Basically we’re trying to give a similar experience with GraphQL that for every mutation there is a field called “client errors” that could contain the input field where the data was not sufficient and then an error message for why it wasn’t good. “Name is already taken.” Or, “Exceeds the maximum value.” Whatever is required. So we would put that field on every error.

Now the problem that we heard from I think Shopify does this same thing already. They had this problem, that people would submit a mutation and it wouldn’t work, but it wouldn’t raise an error. They would get a success response. They said, “Why is this going on?” It turned out that as a client, you have to remember to ask for the errors. One thing we’re thinking about is how can we help people to use it right in that way. That part is not done yet. Working on it.

**Matt** : That’s really interesting. I’m glad this came up because I know it’s something that I’ve been really interested in lately. I’ve seen a lot of discussion about this exact problem. Even just in the last few days I think the GraphQL #ruby channel. What you just talked about, that whole mutation not working correctly but the client doesn’t see that because they didn’t ask for the errors thing, that’s even something that I’ve seen in our team internally where there’s been a few times where I’ve had one of the front end guys come to me and say, “Hey, I did this mutation but it doesn’t seem like it took. It’s returning this data to me it seems like.” I have to remind them, “Yeah, you’ll have to check the errors field on the mutation and make sure there weren’t any errors.”

So yeah, I – this is something that I still struggle with because you’re right. It shouldn’t necessarily all be on the client to remember to do things, but at the same time it makes more sense, at least in my mind, to have those errors be on the thing they occurred on. Kind of like in ActiveRecord when you try to save something to the database that’s incorrect and it fails the validation it’s going to stick some errors on the object itself. So it’s definitely an interesting problem. I’m going to be following the developments on all of that very closely. It’s a problem I’ve seen personally as well.

**Robert** : Yeah, good to know. I should say it’s not something that I’ve worked on personally, but it’s a great part of being on this team that before I got there a few of them had ideas on how to do it better. Just recently, it’s a teammate named Christian who is also on the Slack room and worked at Shopify before this. He’s been really leading the charge on implementing this. It’s exciting to see what they come up with and what I applaud as it happens. I hope we can, like I said, upstream it. Right now the only way to build a mutation is with a relay mutation class. It’s okay, I mean it’s one of the oldest parts of the gem at this point. It would be nice to build a new mutation system with these ideas in mind. Looking forward to that as well.

**Matt** : Yeah, that would be cool. So I mean you talked about some of these methods that you all have for checking to see if a naming conventions are followed and that sort of stuff. Are you using any kind of tools that are already out there for that, like maybe other ruby gems for that or is it a lot of stuff that has been built internally? If so, is that something that you plan on releasing?

**Robert** : Definitely hoping to share more of this. It’s tough because the degree to which it’s application specific is sometimes hard to tease it apart. So in some cases there are like RuboCop cops for this. I’m not a RuboCop expert, but it’s one of my teammates, Garrin, who’s like – he knows it really well and for him it’s a really productive tool. So it’s awesome he’s working on that.

Another, this is similar but different, there’s a ruby gem called graphql-schema\_comparator. That’s a teammate of ours, Mark Andre, who built that six months ago or something. We use it when someone is making a change to the GraphQL Schema as part of CI is to compare the old schema with the new one and make sure that there aren’t any breaking changes. If there are, we have to jump through some hoops to whitelist them just to prevent accidentally breaking things. That’s definitely one that’s already off the shelf, or available. Then some of the linters it’s regular expressions, which is a very powerful hammer. Good.

**Matt** : Awesome. I know I’ve heard of the schema comparator. I’ve kind of looked at it. It looks really nice and really helpful, especially if you’ve got a larger team all kind of working together so you’re not stepping on each other’s toes. I’ll leave a link to that as well. That’s a really cool one. I haven’t gotten a chance to implement it yet, but it’s something that’s kind of on my mind for future development for the team I’m on for sure.

So you talked about from GitHub’s perspective what kind of best practices and things like that you’ve got, what about you personally? Like what – when you see newer developers coming into GraphQL, what kind of practices would you encourage them to adopt?

**Robert** : I think one thing that’s very tempting is to make GraphQL a very fat part of your stack. You can code your authorization logic in there and you can code your business logic in there. But that’s – a couple of years ago we would say you don’t want fat controllers. A controller should be a pretty small bunch of code and then the real business logic should live somewhere else. Nobody told us where else it’s supposed to live.

Domain driven design is starting to get on – getting some press. I hope it takes off. But I think the same thing really applies to GraphQL. If your mutation contains a lot of business logic, it’s going to be hard to test and it’s going to be hard to maintain. So as much of that as you can unit test separately and treat GraphQL more like a blanket of snow on top of your application – that’s not very good. No. It’s main responsibility is to call out to other kind of, what do you call it, units of business logic. Whatever you call that, classes and modules and methods. Make life easier.

**Matt** : Yeah. Yeah. I think the major call out there if I were to put it in my own words is it’s an API. It’s not the actual operator on the data. I mean that’s something that I try to do a lot as well, is make sure, again, that’s part of why I moved to use the GraphQL::Function and that sort of thing, just to kind of keep that layer as thin as possible. It’s more about directing the requests. Okay, you want this piece of data? Not here is how you get it, but here is the thing that knows how to get it kind of thing. And keep as much logic out of that as possible.

I think a lot of it goes back to the SOLID design principles in general anyway. You know, trying to keep things small and separated out from each other. I definitely agree with that. I see a lot of people when they first come in kind of being confused as to like where do I put this. I think that’s a question we may still have to answer for people, but I think we’re getting there for sure.

So kind of along that same vein of thought, what kind of anti-patterns, or bad practices have you seen in GraphQL that you would kind of warn people away from, if you have seen anything like that.

**Robert** : You know, I don’t think there’s a lot - that there’s too much new to say there. I think in terms of keeping the layer thin it’s hard to be – it’s easy to take a shortcut there and just add things to the GraphQL layer. I think we’ll be happier a year from now if we can avoid it. Besides that, I mean there are a lot of things that aren’t quite anti-patterns, but GraphQL has a lot of room for trade-offs. For example, at GitHub we use graphql-batch to keep our database queries in line more or less. I know a lot of people who don’t use it and they accept the tradeoff of n+1 queries sometimes or something like that.

**Matt** : Interesting.

**Robert** : The other thing is authorization. You can build a big authorization system or you can if your system is small and you can manage the complexity, you can write it in-line. I don’t know, there’s some things that they don’t quite qualify as anti-pattern, but it’s almost nice to see you have this - you can start small and grow out from there. I don’t have a ton to say on that one.

**Matt** : Cool. Yeah, I mean, we are still pretty early on in GraphQL, so it’s – yeah. I don’t know if we’ve had enough time for that kind of stuff to come out anyway. Yeah, so, what about scale? I know a lot of people when they first start to look at GraphQL one of the very first questions I hear most people ask is, well, does it scale? Being at GitHub which is, I’d say you’ve got some pretty decent scale there. Have you all seen any kind of scale problems in GraphQL at all?

**Robert** : Let me think about the problems we had. I would say – I think in terms of scale, there’s nothing that’s super scale related. That’s not quite true. Here are some example problems. One was that the runtime overhead of running a GraphQL query is expensive. The more queries you run, the more you pay that cost. So since starting that was one of the first things I got to work on was in the application and in the ruby gem trying to find places that we could be more efficient. That was super fun. That cost is true no matter who you are, and it’s a tradeoff that weighs differently depending on how much time you can spend on it and how much it’s costing you. So that was one.

Another interesting thing has just been, I guess we have all of this authorization logic that’s from the resource-oriented API. Since you only made a call once or twice during the transaction it wasn’t the most important thing that that was super-efficient. But in GraphQL, now maybe you’re making 5, 10 or 100 of these checks. It’s much more important to think carefully about the database queries they’re running kind of data that it’s creating and using. That’s been a challenge I guess. Again, it’s not a show stopper, or a big drawback. In a sense, it’s more exposing some tradeoffs that we made in the past we can’t afford to keep making. Stuff like that.

**Matt** : Yeah, it’s kind of cool to me to see that GraphQL is something that people have been able to implement slowly and just kind of, you know, it’s not something where there’s enough of a performance problem immediately that you have to solve all of them all at once. You can kind of take them in bits and chunks. Correct me if I’m wrong, but it sounds like that’s what GitHub has been doing thus far is just kind of working on that incrementally.

**Robert** : Yeah, exactly. I totally agree that that’s one of the advantages. A cool thing reading about Facebook data layer Tao is that it brings into focus another advantage of a GraphQL API, that basically for the clients consuming the API, the number of possible database queries is finite. It’s large, but for every relation and every object, there’s only so many combinations of inputs that might order and filter the set of data. So you can really find those and optimize them, which is cool. Like the number of indexes you need is finite.

In the case of TAO, the Facebook data layer, the associations that you can query, they’re just tables in the database. So it can be prepared for the queries that are coming in. Sorry, why was I saying that? Oh, that’s an example of like once you can really focus you know what queries can be executed and you get to focus on making those fast. It’s fun to do that bit by bit as we go.

**Matt** : Yeah, definitely. I was, when I hear about these different architectures that people have, it’s cool to hear about the architectures, but every time I hear about it I’m like man, I want to see what the actual code implementation looks like. It’s really interesting to me. I think it’d be pretty cool to see Facebook’s data layer just to see kind of exactly what that implementation looks like.

So we’re getting to the end here. It looks like we’re starting to run out of time a little bit. I just wanted to get to one last question here that I’m really curious about. Is there something that is really interesting or unique about the way that GraphQL is implemented at GitHub?

**Robert** : There are probably a lot of interesting things. One that stands out to me is the way GraphQL has changed the rest of the application. So I mentioned before that a lot, not a lot, but a bunch of the pages on GitHub.com and more and more every day and week are the data fetching goes through GraphQL.

So what that means is code that used to be executed on a resource-based transaction unit of work, now it’s getting called in GraphQL where the techniques for fetching that data is different. Since we use graphql-batch it uses the promises in ruby, which is a big JavaScript thing and not a big ruby thing. It’s been interesting to see how the rest of the application is changing to accommodate that.

An interesting example, I wasn’t here when it happened, but I read some of the code. If you think about issues or like a pull request message on GitHub, as the user you type a bunch of markdown and you click save and there are a lot of things that GitHub converts into a hyperlink. For example, if you typed pound and some numbers, it’ll link to the issue or pull request that matches that number. So there’s a pipeline that renders that HTML that was converted to using promises so that when we serve that stuff through GraphQL it can be way more efficient.

**Matt** : Oh wow. That’s interesting.

**Robert** : Yeah, interesting, it’s weird. It’s weird at first and it takes some getting used to to see the logic expressed that way, but at the same time it’s one of those things where you used to get away not thinking about that, and now you have to think about it. So things are changing. It’s still something we are trying to work on. I think it’s hard to get right and it’s so unfamiliar that it can get in the way of getting work done sometimes, but at the same time it’s so powerful and so efficient that we have to find some way to make them both work. That’s been a really interesting one, and pretty unique for us as far as I know.

**Matt** : Yeah that’s – when I first started looking at the graphql-batch gem, I was really surprised to see promises. I mean, it makes sense once you understand kind of how that works and how it has to work if you want to be able to batch these queries together and avoid n+1 queries, but it’s definitely like – if you’re in JavaScript land, like that, I mean, we have a lot of JavaScript devs where I work. They’re really good at JavaScript. Every time I look at their code it’s just like promises everywhere, callbacks and promises, that sort of thing. It’s so common there. But we’re not really used to it in ruby land at all. It’s not really that much of a thing. It’s just never been a consideration.

Yeah, I agree it’s really interesting to see how that need in GraphQL is kind of forcing the ruby community to look at this stuff now and say, okay, we have to solve this problem. This is a good way to solve it. So it sounds like, if I understand correctly, you all are using it outside of even things that are GraphQL specific now?

**Robert** : I think that’s right. Because even for pages that don’t render with GraphQL, they may call some of the asynchronous style code and then like synchronize it themselves. It’s used in a lot of different places.

**Matt** : That’s cool. That’s really neat to see. Well, it looks like we’re out of time. I think we actually went a little bit over how long I said we were going to go, so I apologize for that.

**Robert** : Nice to talk. I appreciate it.

**Matt** : Like I said, I really appreciate you taking the time to do this. This has been a lot of fun for me. Hopefully my viewers will enjoy it as well. Thank you again. This has been great. Like I said before, I’m going to drop links to all this stuff we kind of talked about in the description below. I look forward to talking to you more in the GraphQL channel, GraphQL Slack. I’ll see you around.

**Robert** : Cool, yeah. Well, thank you for setting it up. It’s always fun for me to talk GraphQL.

**Matt** : All right. See you, everybody.

