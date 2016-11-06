---
layout: post
title:  "Jumper: A Simple Slack Clone In Phoenix And Elixir"
date:   2016-11-05
categories: elixir phoenix
---
**I love Ruby**. It's an incredibly elegant language and I've been smitten with it since the first moment I laid eyes on it. I came upon it after being burnt out on writing Java for the enterprise and boy was it a sight for sore eyes. There is a lot to love about ruby and about Rails, but there is one area where it struggles: speed. Naturally then, when I heard about Elixir and the Phoenix framework, I was intruiged. Here was a language and a framework that reminded me very much of the elegence of ruby and built on top of many of the ideas put forth by Rails, but without sacrificing speed.

Not to mention *concurrency*.

Oh God. I had to taste.

So here we are! I am tired of the tutorials, so I'm building something myself. I wanted it to be something that makes sense for Phoenix - your typical projects don't really take advantage of the main benefits of Elixir and Phoenix. I mean why the hell do I need concurency or websockets for in a blog? Or a todo app? Do I really need realtime functionality in those? This is what I'm so interested in about Phoenix!

So I've decided to build a Slack clone that I'm calling "Jumper". I'm not sure how far I'll take it, but for now, I'm diving into it with the goal of making a functional IRC style web app with channels and user accounts.

The first goal is registration and authentication.

I want to really learn the ins and outs here, so while I could have used a library, I chose to roll it by hand. To get me started, I started following a tutorial on it and filled in the blanks by writing tests, but I came up against an interesting problem.

You can see here a helper method used to grab the current user from the session store:

{% highlight elixir %}
def current_user(conn) do
	id = Plug.Conn.get_session(conn, :current_user)
	if id, do: Jumper.Repo.get(User, id)
end
{% endhighlight %}

Now, this is all fine and dandy, but I'm not really a big fan of this little bit: `if id, do: Jumper.Repo.get(User, id)`. What this means is that any time we hit this helper method, we're also going to hit the database with a query. This isn't a very efficient thing to do - once we've got the user during the request, we don't need to hit the database over and over again for it.

In ruby this would be simple. I would write this as something like:

{% highlight elixir %}
def current_user
	[...]
	@current_user ||= User.find(id)
	[...]
end
{% endhighlight %}

This is referred to as **memoization**, which basically says "if we haven't set this `@current_user` variable yet, then we want to execute this code to set it". The next time we hit this method, we don't have to hit the database again.

Elixir, however, is a *functional* language where ruby is object-oriented. This means we don't have objects or a concept of state in elixir, which makes for an interesting dilemma when attempting to save the results of this query for future requests. If elixir has no concept of state, then how do we cache the result of this function call to avoid unecessary repeat queries during the request cycle?

Well, it turns out that there is something called an `Agent` in elixir that may be just what we need. It's a way of storing and accessing state across processes or within a single process.

*Perfect.*

Now let's see what we can do.