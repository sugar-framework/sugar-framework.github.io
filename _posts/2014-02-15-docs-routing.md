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

Along with defining routes, the router can also contain two other configurations: plugs and filters. Both of these allow for the modification of response on a much broader scale than what is possible with a single controller action.

Plugs are either called before the request is matched and routed or called with the ability to wrap the request with functionality before and after the request is matched and routed, all dependent on the plug's definition. All plugs follow the specification for composable modules in between web applications as defined in the [elixir-lang/plug repo](https://github.com/elixir-lang/plug/blob/master/lib/plug.ex#L1).

Filters are called before and/or after the controller action is executed, all after the request is matched and routed.

## Example

```elixir
defmodule Router do
  use Sugar.Router
  plug Sugar.Plugs.HotCodeReload

  if Sugar.Config.get(:sugar, :show_debugger, false) do
    plug Plug.Debugger, otp_app: :your_project
  end

  plug Plug.Static, at: "/static", from: :you_project

  # Uncomment the following line for session store
  # plug Plug.Session, store: :etc, key: "sid", secure: true, table: :session

  # Define your routes here
  get "/", YourProject.Controllers.Main, :index
end
```
