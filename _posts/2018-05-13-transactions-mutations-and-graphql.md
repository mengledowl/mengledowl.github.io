---
layout: post
title: Transactions, Mutations, and GraphQL
date: 2018-05-13 04:16:36.000000000 -05:00
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
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  _aioseop_description: Ever wondered how you can execute a group of GraphQL mutations
    within a transaction? So have I. Then I realized that there's a better solution.
  _thumbnail_id: '424'
  _wpas_done_all: '1'
author: Matt Engledowl
permalink: "/2018/05/13/transactions-mutations-and-graphql/"
---
![]({{ site.baseurl }}/assets/images/2018/05/rawpixel-589076-unsplash-1024x639.jpg)

The other day I found myself reflecting on mutations, and one of the common complaints about them: there's no way to run multiple mutations inside a transaction.&nbsp;To begin, let me outline the problem.

Most people eventually run into a situation where you're performing multiple actions that should either all succeed or all fail. The classic example of this is crediting an account and debiting another. If you take $10 out of Joe's account and put that $10 in Jan's, you want to make sure that both operations were successful, otherwise it shouldn't save either operation. You wouldn't want to just take money out of Joe's account and then not put it in Jan's, and you also wouldn't want Jan's account to receive $10 without the same amount having come out of Joe's.

At the database level, this is handled using _transactions_. You wrap both operations in a transaction, which basically just says “only commit (save) the changes I made during the transaction if everything inside of it executes successfully.”

When it comes to GraphQL, this leaves many asking “well, how can I do this with my mutations?” Imagine the same example with your GraphQL API - you submit two mutations in a single request but you want everything to roll back if one of them fails. How do you do it?

Currently, there's nothing in the spec about this. It's not a concept that is baked into GraphQL. It was bothering me, and I thought I had a couple of ideas about how I could hack some code together to get something working - just as a prototype.

I spent a couple of hours hacking on it. Everything I tried wasn't working, and I was growing more and more frustrated.

Finally I threw up my hands.

“This is stupid” I thought. “It's probably not a good idea anyway.”

At first the sentiment was sarcastic. I was annoyed that I couldn't figure it out.

But soon after I realized that **I had just discovered a deeper insight into mutation and schema design**. I always say that your schema should abstract the database (or rather, the data later) away, and abstract any lower level logic out so that the client doesn't need to know about anything that it doesn't absolutely need to. The more abstracted away those details can be, the better.

**This is the same thing.**

Transactions are a database level abstraction. Why should the client need to understand that? Not to mention that it gets into business logic as well, which is another area for your server to take care of for the client (wherever possible, business logic should live on the server to remove the need to implement it multiple times).

Going back to our previous example, the original mutations might have been structured like this:

```
type Mutation {
  debitAccount(accountId: ID!, amount: Float): Account
  creditAccount(accountId: ID!, amount: Float): Account
}
```

In this design, there's no way to wrap those mutations in a transaction.

Iwould like to propose the following idea:

**If you find yourself asking how to bundle up multiple mutations and execute them within a transaction, your schema likely has a design flaw.**

Put another way: go back to the drawing board because your schema is not done and needs some reworking.

In this situation, we can pretty easily further abstract these mutations to push the responsibility for the transaction logic onto the server. Instead of two mutations, we can reduce it into one mutation that is much more clear about what it is that we are trying to accomplish:

```
type Mutation {
  transfer(from: ID!, to: ID!, amount: Float): TransferDetails!
}
```

Not only does this make it possible to just wrap our resolve logic in a transaction on the server and remove that concern entirely for the client, but I would argue that this is much better schema design than the other version. _This schema tells a story about what you can do with it_ where the previous version really didn't.

So if you find yourself asking how to run a group of mutations in a transaction, it might be time to take another look at how you've designed your mutations, and see if you might benefit from reworking things a bit.

