---
layout: post
title: 'Guide: Convince Your Boss/Team To Use GraphQL'
date: 2017-11-25 18:36:40.000000000 -06:00
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
  _thumbnail_id: '252'
  _aioseop_description: Do you want to start using GraphQL at your day job, but just
    aren't sure how to get the buy-in from your boss, co-workers, and/or team? Here
    are some tips.
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2017/11/25/guide-convince-your-bossteam-to-use-graphql/"
---
![]({{ site.baseurl }}/assets/images/2017/11/rawpixel-com-250087-1024x699.jpg)

Do you want to start using GraphQL at your day job, but just aren't sure how to get the buy-in from your boss, co-workers, and/or team? I helped start a movement towards GraphQL at my job that eventually lead to GraphQL becoming the standard for all new projects. Along the way, I learned some things that might help you in your journey to bring the joy of GraphQL to your organization.

Now before I get into the details, I will say that there are certain things about my situation that made this easier for me to accomplish. One of our values is **Be Fearless** , which coupled with another value - **A Little Better All The Time** - created a good environment for trying new things and actually following through on it in a production environment. In addition to that, I had the full support of my manager from day one (he actually recommended that we look into it) and was given an opportunity to build something new from the ground up, which laid the groundwork for what ended up happening. While these things may have done a lot to help, I strongly believe that with hard work and perseverance, along with a sprinkling of good people skills, you can get buy-in to start using GraphQL in production at your day job, too.

One more quick note: I just mentioned people skills. **You can have all the grit, data, and logic in the world to back up your reasoning for using GraphQL, but it's not going to get you anywhere if people think you're a jerk.** Many of the suggestions below are directly related to people skills, and every last one of them will require some level of people skills in order to be most effective. If you want to learn more about people and relational skills, I highly recommend reading Dale Carnegie's book [How To Win Friends And Influence People](http://amzn.to/2h5BblC). This is by far one of my favorite books of all time and I firmly believe that anyone who wants to be truly successful in life (not just in their careers!) should read it.

Now to the meat of this discussion! How can you get your organization to adopt GraphQL?

### **Start With Relationships**

Start by cultivating relationships with your co-workers and your supervisor(s). The degree to which the people around you really feel like they know you, trust you, and believe in you directly correlates to how likely you are to get buy-in from them. This may seem obvious, but it's a "groundwork" piece of the equation, without which you probably won't get very far.&nbsp;Again, if people think you're a jerk, it doesn't matter how good you are and how much sense you're making, they aren't going to feel very motivated to support your endeavors.

### **Avoid Criticism**

As you begin to introduce the idea of using a new technology, it can be easy to fall into a mode of criticism of the "old way" of doing things, or to at least come off that way. GraphQL tries to solve many of the problems that REST faces, and it's fine to address this, but the last thing you want to do is make people feel that anything is directed at them. Avoid talking about things like the way that Bob and Jan's REST API makes you want to cry. Don't try to tell your boss that he made a terrible mistake by not choosing GraphQL for the new build. These types of comments do nothing but breed resentment and will keep you from ever getting anywhere with people. Dale Carnegie puts it best in his book [How To Win Friends And Influence People](http://amzn.to/2h5BblC):

> “Criticism is futile because it puts a person on the defensive and usually makes them strive to justify themselves. Criticism is dangerous, because it wounds a person’s precious pride, hurts their sense of importance, and arouses resentment.”

Instead, make statements that focus on building people up and on the positive improvements that can be made rather than on the negative side of things or on anyone's faults.

### **Talk About Challenges It Could Solve**

“Problem” is such a negative word. It implies that something is wrong, and oftentimes gives off the sentiment that the thing in question can’t be solved. It can lead to people feeling demotivated, because it tends to make people feel like the "thing" at hand is unsolvable, or at least far too difficult to make them want to get started.

“Challenge” on the other hand gives people a reason to rise to the task. A challenge feels solvable. It communicates a certain level of difficulty without seeming insurmountable. Search for the challenges that your team is facing today that GraphQL has the ability to solve, and communicate that in the best way you can. It may even help to record these somewhere so that you can come back to this for some of the later suggestions in this post.

### **Give A Presentation**

I love to share the things that I learn. Our team has a bi-weekly dev meeting where developers can sign up to give talks, and I have taken advantage of that opportunity many times in the last year or so to give talks about Elasticsearch, concurrency in elixir, and most recently, a couple of talks about GraphQL. This is a chance to show your team what it is that you like so much about GraphQL - talk about the benefits you’ve seen/experienced, the challenges from above that you believe it could help solve, and show a demo project so that your fellow teammates can get a taste. Fire up GraphiQL and throw it up on the screen to demonstrate in a live-action setting how you’re able to drill down into the docs, construct queries, and get back only the data that you want. **This is your time to shine - show it off and watch their eyes light up as they realize what you’ve been talking about!**

### **Build Out A Small POC**

This can be combined with the previous two: look back at your list of challenges from above, and pick one that’s relatively contained or that you could easily build out a very small MVP-style proof-of-concept for. Build it out, and then present it to your team. This is a very powerful way to show the benefits of GraphQL and help get people excited because they can see in a very tangible way that it can provide solutions to the challenges that you face as a team/organization. It can also help drive adoption because at this point, you’ve already done the work of getting started and getting it to a point where some value can be realized. You also get the added benefit of showing a lot of initiative to jump in and tackle things without being asked.

### **Build Support At The Individual Level**

No revolution starts out with a mob of people - it starts out when one person talks to another person about their vision for a better world. Things aren’t going to change overnight, and the only way to get the support of your team is start with one person at a time. Invest time in talking to people directly - let them feel heard, be understanding of their struggles and concerns, and help them discover the value of what you’re promoting. Notice that I said discover - **the more that you can give your team the space and ability to figure things out for themselves, the more strongly they will end up advocating for your cause**. If you try to force a belief in GraphQL on them, it will almost certainly backfire on you.

### **Address People's Fears Outright**

People are going to have concerns. There is a lot of hype out there, and no one wants to be caught holding the stick when the dust settles and things didn’t go how they thought they would. This can be one of the greatest barriers that you will face when attempting to enact change on your organization and get them to adopt something new. Don’t shy away from the fears people have - face them head-on; bring them up before other people have a chance, if you can. Read over [the fears](/2017/09/09/are-you-afraid/) that tend to [hold people back](/2017/10/28/fud-facebook-and-graphql/) from adopting GraphQL and have an answer ready, even if it amounts to “this isn’t a solved problem yet, but there are a lot of powerful forces propelling the GraphQL community towards an answer”.

### **Be A Supporter, Not A Savior**

Realize that you can’t do this alone - you need the support of your team and your supervisor(s) to make this happen. Arrogance won’t get you anywhere - people can smell that from a mile away, and if you act like you are the Great One will bring your organization out of the dark ages of REST, then no one is going to want to support you. Allow people to have ownership over bringing GraphQL to your work, and they will be powerful advocates for you. Try to take all the glory for yourself, and you’ll be met with brick walls.

* * *

I hope you are able to implement these strategies to successfully drive adoption of GraphQL in your workplace! If you found this article helpful, please share it so more people can get their organization using GraphQL.

Have a success story? Finding it difficult to get GraphQL on the roadmap at your organization? Drop your thoughts in the comments!

