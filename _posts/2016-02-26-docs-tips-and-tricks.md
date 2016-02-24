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
