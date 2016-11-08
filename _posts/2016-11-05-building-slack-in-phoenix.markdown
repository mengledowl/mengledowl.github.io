---
layout: post
title:  "Jumper: A Simple Slack Clone In Phoenix And Elixir"
date:   2016-11-05
categories: elixir phoenix
---
I've been really interested in learning Phoenix/Elixir lately, so I've decided to build a Slack clone that I'm calling "Jumper" just to learn my way around the language/framework. I'm not sure how far I'll take it, but for now, I'm diving into it with the goal of making a functional IRC style web app with channels and user accounts. You can view the source code [here](https://github.com/mengledowl/jumper).

The first goal is registration and authentication.

I want to really learn the ins and outs here, so while I could have used a library, I chose to roll it by hand. To get me started, I [followed a great tutorial](http://nithinbekal.com/posts/phoenix-authentication/) on it and filled in the blanks by writing tests (if you decide to follow along, make sure you follow that first for some context). As I finished up, I came across an interesting issue though...

## The "Memoization" Problem

You can see here a helper method used to grab the current user from the session store:

{% highlight elixir %}
def current_user(conn) do
	id = Plug.Conn.get_session(conn, :current_user)
	if id, do: Jumper.Repo.get(User, id)
end
{% endhighlight %}

I'm uncomfortable with this. Any time we hit this function, we're also going to hit the database with a query, which isn't very efficient. Take a look at the request:

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

Notice the select query on `users` being done twice? That's because I'm calling `current_user/0` twice and it queries each time. Not very efficient.

In ruby this would be simple to solve with something like:

{% highlight elixir %}
def current_user
	[...]
	@current_user ||= User.find(id)
	[...]
end
{% endhighlight %}

This is referred to as **[memoization](https://en.wikipedia.org/wiki/Memoization)**, which basically says "if we haven't set this `@current_user` variable yet, then we want to execute this code to set it". The next time we hit this method, we don't have to hit the database again.

Elixir, however, is a *functional* language where ruby is object-oriented. This means we don't have objects or a concept of state in elixir, which makes for an interesting dilemma when attempting to memoize this query. If elixir has no concept of state, then how do we solve this?

## Introducing: Plug and assigns

After talking to some folks in the Elixir Slack [^1], I realized this is best done using `Plug` to run the query once and store the result in `assigns`. What are these exactly?

According to the Plug repository on github:

> Plug is:
>
> 1. A specification for composable modules between web applications
> 2. Connection adapters for different web servers in the Erlang VM

More simply put, for our purposes it allows us to intercept the request and set a value on `conn` that can be accessed from anywhere *without having to run the query again*.

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

The important bit is in `call/2`, where we get the user and then set the `:current_user` assign value on the `conn` to the `current_user` value we found in the line prior. Now we can access this cached value via `conn.assigns.current_user`.

Let's add this plug to the end of our pipeline so we hit it during the request cycle.

{% highlight elixir %}
# web/route.ex

pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Jumper.AssignUser
  end
{% endhighlight %}

Next we need to modify `Session.logged_in?` to check the `assigns` value:

{% highlight elixir %}
# web/models/session.ex

def logged_in?(conn), do: !!conn.assigns[:current_user]
{% endhighlight %}

We need to be able to access our `logged_in?/1` method from the view, so we should import it in `web/web.ex`. In `view/0` under the `quote` block, we add:

{% highlight elixir %}
# web/web.ex

import Jumper.Session, only: [logged_in?: 1]
{% endhighlight %}

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

## Cleaning It Up

I don't like that every time I want to use the current user, I have to access it through `assigns.current_user`. It feels dirty. So let's go back to our `Session` module and repurpose our `current_user/1` function:

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
{% endhighlight %}

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

[^1]: Special thanks to @david.antaramian, @vy, @micmus, and @mbriggs guiding me in the right direction on Plug and providing examples so I could understand.