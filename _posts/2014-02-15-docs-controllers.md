---
layout: docs
title: Controllers
permalink: /docs/controllers/
---

# Controllers

All controller actions should have an arity of 2, with the first argument being a `Plug.Conn` representing the current connection and the second argument being a `Keyword` list of any parameters captured in the route path; both of these arguments are passed to the controller action from the router when a request is received.

To illustrate: if your router receives a `GET` request for `/2`, and your router has a route that points a `GET` for `/:id` to `YourApplication.Controller.Main.show`, your controller's `show` will receive a `Plug.Conn` as its first argument and `[id: 2]` as its second argument.  Similarly, if your router receives a `POST` request for `/2?title=foo&body=Hello%20world`, and has a route that points a `POST` for `/:id` to `YourApplication.Controller.Main.update`, your controller's `update` will receive a `Plug.Conn` as its first argument (where `conn.params` is `%{"title" => "foo", "body" => "Hello world"}`) and `[id: 2]` as its second argument.

Sugar bundles these response helpers to assist in sending a response:

- `render/2` - `conn`, `template` - sends a normal response.
- `halt!/1` - `conn` - ends the response.
- `not_found/1` - `conn` - sends a 404 (Not found) response.
- `json/2` - `conn`, `data` - sends a normal response with
  `data` encoded as JSON.
- `raw/1` - `conn` - sends response as-is. It is expected
  that status codes, headers, body, etc have been set by
  the controller action.

#### Example

```elixir
defmodule Hello do
  use Sugar.Controller

  def index(conn, []) do
    render conn, "showing index controller"
  end
  
  def show(conn, args) do
    render conn, "showing page \#{args[:id]}"
  end
  
  def update(conn, args) do
    %{"title" => title, "body" => body} = conn.params
    render conn, "edited page #{args[:id]} with title: #{title}, body: #{body}"
  end
  
  def create(conn, []) do
    render conn, "page created"
  end

  def get_json(conn, []) do
    json conn, %{message: "foobar"}
  end
end
```
