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

## The Memoization Problem

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

```
[info] GET /
[debug] Processing by Jumper.PageController.index/2
  Parameters: %{}
  Pipelines: [:browser]
[debug] QUERY OK source="users" db=0.2ms
SELECT u0."id", u0."email", u0."encrypted_password", u0."inserted_at", u0."updated_at" FROM "users" AS u0 WHERE (u0."id" = $1) [2]
[debug] QUERY OK source="users" db=0.1ms
SELECT u0."id", u0."email", u0."encrypted_password", u0."inserted_at", u0."updated_at" FROM "users" AS u0 WHERE (u0."id" = $1) [2]
[info] Sent 200 in 1ms
```

Notice the same select query on `users` being done twice? That's because I'm calling `current_user/0` twice. That is a problem.

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

## Introducting: `Plug` and `assigns`

After talking to some folks in the Elixir Slack, I realized this is best done using `Plug` to run the query once and store the result in `assigns`. What are these exactly?

To quote the Plug repository on github:

> Plug is:
>
> 1. A specification for composable modules between web applications
> 2. Connection adapters for different web servers in the Erlang VM

More simply put, for our purposes it allows us to intercept the request and set a value on the connection that can be accessed from anywhere *without having to run the query again*.

In practice, here's how that looks.

First we need to define a custom `Plug`:

{% highlight elixir %}
# web/plugs/assign_user.ex

defmodule Jumper.AssignUser do
	import Plug.Conn

	def init(_opts) do
		nil
	end

	def call(conn, _opts) do
		id = get_session(conn, :user_id)
		current_user = id && Jumper.Repo.get(Jumper.User, id)
		assign(conn, :current_user, current_user)
	end
end
{% endhighlight %}

Plugs require two methods: `init/1` and `call/2`. We don't need to do anything on init so we just return `nil`. Inside `call/2` you'll see some familiar code with a couple slight modifications that gets the user, and then the magical line `assign(conn, :current_user, current_user)`. This line sets the `:current_user` assign value on the `conn` to the `current_user` value we found in the line prior. Now we can access this cached value via `conn.assigns.current_user`.

Let's add this plug to the end of our pipeline so we hit it during the request cycle.

{% hightlight elixir %}
# web/route.ex

pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Jumper.AssignUser
  end
{% endhighlight }

Next we need to modify `Session.logged_in?` to check the `assigns` value:

{% highlight elixir %}
# web/models/session.ex

def logged_in?(conn), do: !!conn.assigns[:current_user]
{% endhighlight }

We need to be able to access our `logged_in?/1` method from the view, so we should import it in `web/web.ex`. In `view/0` under the `quote` block, we add `import Jumper.Session, only: [logged_in?: 1]`.

Now we should be able to use our newly stored `current_user` in the template, so lets use it to set up the navbar.

{% highlight elixir %}
# web/templates/layout/app.html.eex

[...]
<ul class="nav nav-pills pull-right">
<%= if logged_in?(@conn) do %>
  <li><%= assigns.current_user.email %></li>
  <li><%= link "Logout", to: session_path(@conn, :delete), method: :delete %></li>
<% else %>
  <li><%= link "Login", to: session_path(@conn, :new) %></li>
  <li><%= link "Register", to: registration_path(@conn, :new) %></li>
<% end %>
</ul>
[...]
{% endhighlight %}

Now when we reload the homepage, we should only see that query execute once. Let's give it a go:

```
[info] GET /
[debug] QUERY OK source="users" db=0.9ms
SELECT u0."id", u0."email", u0."encrypted_password", u0."inserted_at", u0."updated_at" FROM "users" AS u0 WHERE (u0."id" = $1) [1]
[debug] Processing by Jumper.PageController.index/2
  Parameters: %{}
  Pipelines: [:browser]
[info] Sent 200 in 1ms
```

Awesome! Only one select query gets run now.

Now there's one thing that is still bothering me - I don't like that every time I want to use the current user, I have to access it through `assigns.current_user`. It feels dirty. So let's go back to our `Session` module and repurpose our `current_user/1` function:

{% highlight elixir %}
# web/models/session.ex

def current_user(conn) do
	conn.assigns[:current_user]
end
{% endhighlight %}

Add this method in `web.ex`:

{% highlight elixir %}
# web/web.ex

import Jumper.Session, only: [logged_in?: 1, current_user: 1]
{% end %}

And then change our references to point to our new function:

{% highlight elixir %}
# web/models/session.ex

def logged_in?(conn), do: !!current_user(conn)
{% endhighlight %}

{% highlight elixir %}
# web/templates/layout/app.html.eex

<ul class="nav nav-pills pull-right">
<%= if logged_in?(@conn) do %>
  <li><%= current_user(@conn).email %></li>
  <li><%= link "Logout", to: session_path(@conn, :delete), method: :delete %></li>
<% else %>
  <li><%= link "Login", to: session_path(@conn, :new) %></li>
  <li><%= link "Register", to: registration_path(@conn, :new) %></li>
<% end %>
</ul>
{% endhighlight %}

Boom. The query only runs once no matter how many times we need to have access to the current user, and we have some nice helper methods that act as a wrapper around the value at `conn.assigns.current_user`.

Hope you enjoyed exploring this with me, and I'll be back soon as I keep working through building this app!