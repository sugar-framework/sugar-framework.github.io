---
layout: docs
title: Testing
permalink: /docs/testing/
---

# Testing

## Controllers

Consider the following controller:

```elixir
defmodule MyController do
  use Sugar.Controller

  @doc false
  def index(conn, []) do
    # Somehow get our content

    # Render our "mycontroller/index.html.eex" view
    render conn
  end
end
```

The following can be used to test the above controller:

```elixir
## This is mostly from the Plug documentation over testing plugs.
## It's slightly modified for this case.
defmodule MyControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "returns hello world" do
    # Create a test connection
    conn = conn(:get, "/")
    opts = MyController.init [ action: :index, args: %{} ]

    # Invoke the controller
    conn = MyController.call(conn, opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello world"
  end
end
```
