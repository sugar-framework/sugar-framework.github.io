---
layout: docs
title: Routing
permalink: /docs/routing/
---

# Routing

`Sugar.Router` defines an alternate format for `Plug.Router` routing. Supports all HTTP methods that `Plug.Router` supports.

Routes are defined with the form:

    method route [guard], controller, action

`method` is `get`, `post`, `put`, `patch`, `delete`, or `options`, each responsible for a single HTTP method. `method` can also be `any`, which will match on all HTTP methods. `controller` is any valid Elixir module name, and `action` is any valid function defined in the `controller` module.

## Example

```elixir
defmodule Router do
  use Sugar.Router

  get "/", Hello, :index
  get "/pages/:id", Hello, :show
  post "/pages", Hello, :create
  put "/pages/:id" when id == 1, Hello, :show
end
```