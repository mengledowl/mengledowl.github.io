---
layout: post
title: Production Ready GraphQL with Marc-André Giroux
date: 2020-07-15 14:32:31.000000000 -05:00
excerpt_separator: <!--more-->
categories:
- Interviews
tags: []
author: Matt Engledowl
permalink: "/2020/07/15/production-ready-graphql-with-marc-andre-giroux/"
---

![]({{ site.baseurl }}/assets/images/2020/07/production-ready-graphql-700x957.png)

There aren't many great resources for learning about GraphQL API design or running a GraphQL server. Most of what I've learned on both of those fronts has come from experience and talking with other people with lots of experience building and maintaining GraphQL APIs. Naturally, when I see someone putting out good content on these topics, I perk up and pay attention.

One of those people is **Marc-André Giroux**.

<!--more-->

Marc-André is a software engineer, author, and speaker with experience working on the GraphQL APIs at both [Shopify](https://www.shopify.com/) and [GitHub](https://github.com/). This puts him in the unique position of having worked on two of the largest, most well-known GraphQL APIs currently in existence.

I've been following his writing for quite some time now, and it's always thorough, well-thought-out, and _fascinating_. The things he has to say come not just from theory, but _extensive, real-world experience_.

His new book **"Production Ready GraphQL"** came out in March. This is an important and exciting development in the GraphQL community because from what I've seen, there's nothing else like it out there. It's a high-quality, extensive, and balanced look at everything that goes into designing and building GraphQL APIs, and after reading it, I can say that it is without a doubt, the single best resource currently available on these topics.

I reached out to him hoping to ask him a few questions, which he graciously agreed to. So, let's jump right in!
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### For those unfamiliar with the book, can you explain it briefly in your own words?

<!-- /wp:heading -->

<!-- wp:paragraph -->
In 2018 I started writing a book I called back then "The Little Book of Schema Design". It was all about designing great GraphQL APIs. As I was writing it, I realized I had more to say about GraphQL and it turned into a book on building GraphQL APIs in general! Production Ready GraphQL is basically a full journey into what problems one encounters when building GraphQL APIs at scale, and how to solve them. From an introduction to GraphQL, to security, to schema design, to performance and even documentation, it tries to cover it all! The book is langage agnostic, in the sense that it doesn't focus on a particular library or programming language. Instead it focuses on concepts and best practices that can be used across all ecosystems.
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### What inspired you to write it?

<!-- /wp:heading -->

<!-- wp:paragraph -->
I had been writing about GraphQL for a while and was surprised about how little content there was out there on building GraphQL **servers.** GraphQL is loved by client-side developers and you hear a lot about it from that perspective. However, I felt like there was a gap in content about building GraphQL servers and how to maintain them at scale.
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Who is this book for?

<!-- /wp:heading -->

<!-- wp:paragraph -->
The book is for anyone interested in learning about the challenges of building GraphQL **servers**. It does help if you've tried building one in the past, but it is not required. If you're a front end developer using GraphQL, the book will let you understand GraphQL in a deeper way as well. In general, if you're working on GraphQL at your company I think you'll get a lot out of it!
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Writing books is a tough process in general - what was the toughest part of writing about GraphQL specifically?

<!-- /wp:heading -->

<!-- wp:paragraph -->
The toughest part is that GraphQL is continuously evolving, and also that is used in a variety of contexts. That makes it quite hard to come up with recommendations since they can be different based on the context GraphQL is used in. I tried my best to highlight these nuances when they came up.
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### If a reader only took one thing away from your book, what would you want it to be?

<!-- /wp:heading -->

<!-- wp:paragraph -->
I think it would be that GraphQL is really amazing, but that it comes with a ton of challenges on the server side. Don't get me wrong, they're all solvable, and they're fun to work on. However GraphQL doesn't come for free, and it's definitely not easy to support and evolve a large GraphQL platform at scale.
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### One thing I don’t think you talked about in the book was subscriptions. How do you feel about them, and was there a specific reason you didn’t discuss them, particularly from a schema design perspective?

<!-- /wp:heading -->

<!-- wp:paragraph -->
That's right, the book doesn't cover subscriptions at all.

<!-- /wp:paragraph -->

<!-- wp:list {"ordered":true} -->

1. I'm not as familiar with subscriptions, my work with them is limited so I didn't necessarily feel I would bring as much value in that area.
2. I've always felt like the hard part about subscriptions is implementing what powers them on the backend rather than the GraphQL part itself. Building a scalable pub/sub and websocket system capable of handling a ton of connections could be a book all of itself, and I find that's truly the challenge with subscriptions for most people out there. I didn't really want to get into that in this book!

<!-- /wp:list -->

<!-- wp:heading {"level":3} -->

### Is there anything that you had to leave out that you wish you could have included?

<!-- /wp:heading -->

<!-- wp:paragraph -->
I had to leave out a lot of implementation-specific content because I didn't want the book to be about "GraphQL in JavaScript" or "GraphQL in Ruby". So the implementation chapter had to stay fairly general. I'm working on something (probably a video course) that will be entirely implementation specific, so stay tuned 🙂
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### You spend a lot of time in the book talking about schema design - why is it so important from your perspective?

<!-- /wp:heading -->

<!-- wp:paragraph -->
At the most basic level we write APIs to let clients **achieve something.** Whether that's done through REST, GraphQL, gRPC, clients want to be able to do something with your product in the first place. Good API design is what makes achieving these use cases intuitive and easy! On the API provider side of things, API evolution is one of the hardest things there is. We can't predict the future but thoughtful schema design can help minimize the need for breaking changes.

In general, the number of tools blindly converting database schemas to GraphQL APIs made me think we weren't talking about API design enough in the GraphQL community!
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### What sub-topic from the book are you most passionate about, or did you most enjoy writing about (eg. schema design, security, workflow, etc), and why?

<!-- /wp:heading -->

<!-- wp:paragraph -->
You can probably guess it was schema design which is by far the biggest chapter. I have a ton of things to say about it and it's fun to try and write about something so nuanced. Coming up with advice that is general enough to fit most use cases is challenging and fun. In general coming up with a design you like is such a satisfying feeling (even though you might be totally wrong 2 years later 🙊)
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### In my experience working with enterprise clients who are looking into GraphQL, they inevitably ask if they can just use their existing OpenAPI/Swagger docs to generate a schema. You talk about this approach a bit in the book (eg.&nbsp;`openapi-to-graphql`), but what are the downsides to it, and do you think these tools are worth using?

<!-- /wp:heading -->

<!-- wp:paragraph -->
It's definitely tempting to go this route. I've been vocal about being careful of these tools but recently I've softened my opinion on them because I do think they can be useful in a pragmatic way. The reason I'm not the biggest fan of these tools is that what makes a great endpoint-based API and what makes a great GraphQL API is not always exactly the same. Blindly translating OpenAPI operations to GraphQL fields may work most of the time, but it's definitely not a perfect solution.

Now I do think you can acknowledge it's not going to give the best design and still use the tool to get started quickly, or to help with a migration. Often providing a GraphQL API is a good opportunity to design things differently so I would definitely think about the tradeoffs before using tools like `openapi-to-graphql`.
<!-- /wp:paragraph -->

<!-- wp:heading {"level":3} -->

### Where can people find you?

<!-- /wp:heading -->

<!-- wp:paragraph -->
Blog: [https://productionreadygraphql.com/](https://productionreadygraphql.com/)

Book: [https://book.productionreadygraphql.com/](https://book.productionreadygraphql.com/)

Twitter: [https://twitter.com/\_\_xuorig\_\_](https://twitter.com/__xuorig__ )

_A huge thanks to Marc-André for agreeing to do this! If you haven't done it yet, go [pick up his book](https://book.productionreadygraphql.com/#get-the-book) and give it a read. I would highly recommend spending a little extra money for the "Complete Package", which comes with 3 extra guides, 4 interviews with engineers from Shopify, GitHub, Airbnb, and Paypal, and access to a private slack channel._
<!-- /wp:paragraph -->

