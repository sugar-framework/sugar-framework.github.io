---
layout: docs
title: Tips and Tricks
permalink: /docs/tips-and-tricks/
---

# Tips and Tricks

Just a few assorted tricks of the trade for doing "real-world" work with Sugar.  The examples provided assume you've created a Sugar project called `YourProject` by following the Getting Started guide.

## Uploads

The best way to go about this is to use `Plug.Parsers` and `Plug.Upload`.  In your router (`lib/your_project/router.ex`):

```elixir
defmodule YourProject.Router do
  use Sugar.Router
  
  # ... other router stuff
  
  plug Plug.Parsers, parsers: [ Plug.Parsers.URLENCODED,
                                Plug.Parsers.MULTIPART ]
  
  # ... other router stuff
  
  get  "/uploads", YourProject.Controllers.Upload, :index
  post "/uploads", YourProject.Controllers.Upload, :create  # for example
end
```

Then, in your controller (`lib/your_project/controllers/upload.ex`):

```elixir
defmodule YourProject.Controllers.Main do
  use Sugar.Controller
  
  def index(conn, _) do
    conn |> render
  end
  
  def create(conn, _) do
    # For example:
    %Plug.Upload{filename: filename, path: path} = conn.params["file"]
    path |> File.read! |> do_something(filename)  # or whatever
    conn |> redirect("/uploads")                  # or whatever
  end
end
```

And finally, in your view (`lib/your_project/views/upload/index.html.eex`):

```html
<html>
<body>
  <form enctype="multipart/form-data" action="/uploads" method="post">
    <input type="file" name="file">
    <input type="submit">
  </form>
</body>
</html>
```

## Phoenix Compatibility

Both Sugar and Phoenix build on top of Plug, so there's not a whole lot that needs to be done; most of the time, things should Just Work™.  If they don't (and a workaround isn't described here), feel free to submit a bug.

### Controller

If your Sugar controller needs to use a plug that expects to be used in a Phoenix controller (notably, one that acts on Phoenix controller actions), the fix is pretty simple.  In your controller (`lib/your_project/controllers/phoo_bar.ex`):

```elixir
defmodule YourProject.Controllers.PhooBar do
  use Sugar.Controller
  
  plug :phoenix_compat
  plug SomePlugThatExpectsPhoenixActions
  
  # ... other controller stuff
  
  def phoenix_compat(conn, _) do
    private = conn.private |> Map.merge(%{
      phoenix_controller: conn.private[:controller],
      phoenix_action:     conn.private[:action] })
    
    %Plug.Conn{ conn | private: private }
  end
end
```

## Authentication

Sugar ships with a `Sugar.Plugs.EnsureAuthenticated` plug that'll (unless configured with a handler that does something else) redirect clients to a login page if the client isn't currently logged in.  Using it is dead-simple.

First, in your router (`lib/your_project/router.ex`), assuming that you're using an ETS-based session store (you should probably roll your own or go with encrypted cookies for production apps, at least per [Plug's own documentation](http://hexdocs.pm/plug/Plug.Session.ETS.html)):

```elixir
defmodule YourProject.Router do
  use Sugar.Router
  
  # ... other router stuff
  
  # Uncomment the following line for session store
  plug Plug.Session, store: :ets, key: "sid", secure: true, table: :session
  
  # ... other router stuff
  
  # This can be anything that brings the user to a login page
  get "/login", YourProject.Controllers.Login, :new
end
```

Next, you'll want to create an Ecto repo (like `YourProject.Repos.Main`) and a user model (like `YourProject.Models.User`), since `Sugar.Plugs.EnsureAuthenticated` assumes these to exist and behave like Ecto repos/models (but doesn't really care, so long as `YourProject.Models.User` is a struct with an `:id` field and `YourProject.Repos.Main` has a `get/2` function that returns such a struct).

Finally, in the controller that you want to restrict (`lib/your_project/controllers/foo_bar.ex`):

```elixir
defmodule YourProject.Controllers.FooBar do
  use Sugar.Controller
  
  plug Sugar.Plugs.EnsureAuthenticated
  
  def some_action(conn, _) do
    user = conn.assigns[:current_user]          # %YourProject.Models.User{ ... }
    conn |> render(current_user: current_user)  # or something
  end
end
```

Now, users will only be able to access that controller action if they're logged in (otherwise, they'll be redirected to the `/login` route).  See the [`Sugar.Plugs` README](https://github.com/sugar-framework/plugs) for more details.
