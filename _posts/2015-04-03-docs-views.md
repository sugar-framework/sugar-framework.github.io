---
layout: docs
title: Views
permalink: /docs/views/
---

# Views

Sugar features a number of ways to render views, including both HTML (via EEx) and JSON.

## EEx

Sugar - more specifically, the `Sugar.Controller` module - ships with a `render/4` function that will automatically render a specified EEx template to the specified connection when called.  For example, in your application's main controller:

```elixir
defmodule YourProject.Controllers.Main do
  use Sugar.Controller
  
  def index do
    conn |> render(:index)
  end
end
```

The above will cause Sugar to render and send an EEx template located in `lib/your_project/views/main/index.html.eex` (you can configure this in your `config.exs`, however; just set the `:sugar, :views_dir` key to whatever tickles your fancy).  In fact, you don't even need to specify which template to render; as long as you're using standard RESTful template names in the right locations, Sugar will happily guess which template to render based on your controller module's name and the method called, like so:

```elixir
  def index do
    # will render `lib/your_project/views/main/index.html.eex`
    conn |> render
  end
```

What if you want to pass some arguments to the template, though?  Well, you can do that, too:

```elixir
  def show(params) do
    conn |> render(:show, [foo: find_a_foo(params[:id])])
  end
```

## Calliope

`render/4` (as described above) will actually detect and process Haml documents with Calliope if they exist.  Thus, if Haml is more your thing, you can use the same exact code as described above for EEx templates while using Haml templates in `lib/your_project/views/#{your_controller}` and it'll work perfectly!

## Static files

If you have any HTML files that aren't templated in any way, Sugar will gladly find and send them.  Just use the `static/2` function, like so:

```elixir
  def index do
    conn |> static("index.html")
  end
```

`static/2` looks in the `priv/static` folder of your project's source code.  You can also use `Plug.Static` in your router to serve an entire folder of static files, like so:

```elixir
defmodule YourProject.Router do
  ...
  plug Plug.Static, at: "/static", from: :your_project
end
```

The above will make any files in your app's `priv/static` folder accessible to clients via the `/static` path (so, the file `priv/static/my_style.css` could be accessed from `/static/my_style.css`).  For more details on how to use `Plug.Static`, see [Plug's documentation site](http://hexdocs.pm/plug/Plug.Static.html).

## JSON

Sugar has built-in support for rendering JSON representations of things using the `json/2` function.  For example:

```elixir
defmodule YourProject.Controllers.Main do
  use Sugar.Controller
  
  def show_json(params) do
  # outputs `{foo: "This is foo.", bar: "This is bar."}`
    conn |> json([foo: "This is foo.", bar: "This is bar."])
  end
end
```
