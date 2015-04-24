---
layout: docs
title: Controllers
permalink: /docs/controllers/
---

# Controllers

All controller actions should have an arrity of 2, with the first argument being a `Plug.Conn` representing the current connection and the second argument being a `Keyword` list of any parameters captured in the route path.

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
  
  def create(conn, []) do
    render conn, "page created"
  end

  def get_json(conn, []) do
    json conn, %{message: "foobar"}
  end
end
```