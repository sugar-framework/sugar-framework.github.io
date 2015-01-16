---
layout: docs
title: Getting Started
permalink: /getting-started/
---

# Getting Started

<section id="create-a-mix-project"></section>
## Create a Mix project

First of all, what is Mix? According to the [Introduction to Mix](http://elixir-lang.org/getting_started/mix/1.html) page on [elixir-lang.org](http://elixir-lang.org/),

> Mix is a build tool that provides tasks for creating, compiling, testing (and soon releasing) Elixir projects. Mix is inspired by the Leiningen build tool for Clojure and was written by one of its contributors.

That sounds super, doesn't it? At the end of the day, you will use Mix for a number of reasons in your project. The first way we will use Mix today is to have it create our initial project for us with `mix new [project name]`.

```
$ mix new your_project
* creating README.md
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/your_project.ex
* creating lib/your_project
* creating lib/your_project/supervisor.ex
* creating test
* creating test/test_helper.exs
* creating test/your_project_test.exs

Your mix project was created successfully.
You can use mix to compile it, test it, and more:

    cd your_project
    mix compile
    mix test

Run `mix help` for more information.

$ cd your_project
$ ls -la
total 32
drwxr-xr-x  11 shane  staff   374 Feb 14 16:40 .
drwxr-xr-x  23 shane  staff   782 Feb 14 16:25 ..
-rw-r--r--   1 shane  staff    34 Feb 14 16:25 .gitignore
-rw-r--r--   1 shane  staff    36 Feb 14 16:25 README.md
drwxr-xr-x   4 shane  staff   136 Feb 14 16:25 lib
-rw-r--r--   1 shane  staff   583 Feb 14 16:31 mix.exs
drwxr-xr-x   4 shane  staff   136 Feb 14 16:25 test
```

<section id="add-in-sugar"></section>
## Add in Sugar

See that `mix.exs` file Mix generated for us? It contains project-level configurations, one of which is the project dependencies. We need to ensure Sugar is returned by the `deps/0` function, such as:

```elixir
def deps do
  [ {:sugar, github: "sugar-framework/sugar"} ]
end
```

If you're running Elixir v0.13.2 or higher, [hex](https://hex.pm/) is the preferred way of adding the dependency. For a general overview of this process, checkout the [hex usage page](https://hex.pm/docs/usage). Here's the tuple needed for hex:

```elixir
def deps do
  [ { :sugar, "~> 0.4.2" } ]
end
```

so open it up, add one of the tuples for Sugar, and save it. With that done, we're going to use Mix to pull down a copy of Suagr and its dependencies and compile them, using `mix do deps.get, deps.compile`. This could also be accomplished in two commands, `mix deps.get` and `mix deps.compile`, but `mix do` allows us to chain commands, one after the other. This process can take a bit of time depending on the speed of your internet connection and computer.

```
$ mix do deps.get, deps.compile
* Getting sugar (git://github.com/sugar-framework/sugar.git)
Cloning into '/Volumes/Data/Code/elixir/your_project/deps/sugar'...
remote: Counting objects: 564, done.
remote: Compressing objects: 100% (255/255), done.
remote: Total 564 (delta 334), reused 464 (delta 277)
Receiving objects: 100% (564/564), 68.83 KiB | 0 bytes/s, done.
Resolving deltas: 100% (334/334), done.
Checking connectivity... done
* Getting mime (git://github.com/dynamo/mime.git)
Cloning into '/Volumes/Data/Code/elixir/your_project/deps/mime'...
remote: Reusing existing pack: 46, done.
remote: Total 46 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (46/46), 29.10 KiB | 0 bytes/s, done.
Resolving deltas: 100% (14/14), done.
Checking connectivity... done
* Getting cowboy (git://github.com/extend/cowboy.git)
Cloning into '/Volumes/Data/Code/elixir/your_project/deps/cowboy'...
remote: Reusing existing pack: 5810, done.
...
# The rest of the project dependencies are downloaded and compiled
...
* Compiling sugar
Compiled lib/mix/tasks/sugar/gen/router.ex
Compiled lib/mix/tasks/sugar/gen/config.ex
Compiled lib/mix/tasks/server.ex
Compiled lib/mix/tasks/sugar/gen/controller.ex
Compiled lib/sugar.ex
Compiled lib/mix/tasks/sugar/init.ex
Compiled lib/mix/tasks/sugar/gen/view.ex
Compiled lib/sugar/app.ex
Compiled lib/sugar/supervisor.ex
Compiled lib/sugar/controller.ex
Compiled lib/sugar/router.ex
Generated sugar.app
```

If everything goes to plan, no errors will be raised, and `Generated sugar.app` will be displayed, letting you know all of the dependencies have been compiled correctly.

With `mix` being the extensible build tool that it is, developers often add specialized `mix` tasks to their projects, adding functionality that makes using the project easier. Sugar is no exception. Let's see what's available.

```
$ mix help
mix                      # Run the default task (current: mix run)
mix archive              # Archive this project into a .ez file
mix clean                # Clean generated application files
mix cmd                  # Executes the given command
mix compile              # Compile source files
mix deps                 # List dependencies and their status
mix deps.clean           # Remove the given dependencies' files
mix deps.compile         # Compile dependencies
mix deps.get             # Get all out of date dependencies
mix deps.unlock          # Unlock the given dependencies
mix deps.update          # Update the given dependencies
mix dialyzer             # Runs dialyzer with default or project-defined flags.
mix dialyzer.plt         # Builds PLT with default erlang applications included.
mix do                   # Executes the tasks separated by comma
mix escriptize           # Generates an escript for the project
mix help                 # Print help information for tasks
mix local                # List local tasks
mix local.install        # Install a task or an archive locally
mix local.rebar          # Install rebar locally
mix local.uninstall      # Uninstall local tasks or archives
mix new                  # Create a new Elixir project
mix run                  # Run the given file or expression
mix server               # Runs Sugar and children
mix sugar.gen.config     # Creates Sugar config files
mix sugar.gen.controller # Creates Sugar controller files
mix sugar.gen.router     # Creates Sugar router files
mix sugar.gen.view       # Creates Sugar view files
mix sugar.init           # Creates Sugar support files
mix test                 # Run a project's tests
iex -S mix               # Start IEx and run the default task
```

All of the `mix` tasks available to your project will be listed along with a short description of what it does. Note that all of the Sugar tasks start with `sugar.*`.

Since `sugar.init` add in the necessary files for Sugar, let's run it.

```
$ mix sugar.init
* creating lib/your_project/config.ex
* creating lib/your_project/router.ex
* creating lib/your_project/controllers
* creating lib/your_project/controllers/main.ex
* creating lib/your_project/models
* creating lib/your_project/views
* creating lib/your_project/views/main/index.html.eex
* creating priv
* creating priv/static
```

Awesome! Now we have our config module, a router, our first controller, and a view. The `sugar.init` task follows a few conventions regarding module names and file locations. For instance, `lib/your_project/controllers/main.ex` contains the `YourProject.Controllers.Main` module. Take a look around your project if you're unfamiliar with Elixir. Don't worry. We'll be here when you get back.

<section id="configure-your-router"></section>
## Configure Your Router

A web application wouldn't serve much of a purpose if it couldn't map URLs to a particular function or set of expressions. It would essentially sit there, thinking it was doing its job when it was really doing anything but.

Enter the router. You define the routes for your web application, and the router makes sure the application does what it's supposed to when a user hits a page.

Let's see what Sugar put in our router.

```elixir
defmodule Router do
  use Sugar.Router, plugs: [
    { Plugs.HotCodeReload, [] },
    { Plug.Static, at: "/static", from: :my_app },

    # Uncomment the following line for session store
    # { Plug.Session, store: :ets, key: "sid", secure: true, table: :session },

    # Uncomment the following line for request logging,
    # and add 'applications: [:exlager],' to the application
    # Keyword list in your mix.exs
    # { Plugs.Logger, [] }
  ]

  before_filter Filters, :set_headers

  # Define your routes here
  get "/", Main, :index
end
```

Routes are defined with the form `method route [guard], controller, action`, so when `get "/", YourProject.Controllers.Main, :index` is used in the router, we are telling our application to call the `index` function (action) defined in the `YourProject.Controllers.Main` module (controller) whenever the `"/"` URL is accessed.

Along with defining routes, the router can also contain two other configurations: plugs and filters. Both of these allow for the modification of response on a much broader scale than what is possible with a single controller action.

To see the different ways routes can be defined, checkout the documentation on [routing](/docs/routing/).

<section id="add-a-controller"></section>
## Add a Controller

One controller isn't enough to properly organize your application, you say? Good to hear! I suppose you'd like to know how to create a new controller, right? Well, look no further than your friend Mix.

```
$ mix sugar.gen.controller pages
* creating lib/your_project/controllers/pages.ex
```

Success! A new `YourProject.Controller.Pages` controller has been created for you.

```elixir
defmodule YourProject.Controllers.Pages do
  use Sugar.Controller

  def index(conn, []) do
    raw conn |> resp(200, "Hello world")
  end
end
```

Now it's your turn to take this controller and mould it to do your will. Check out the [controllers documentation](/docs/controllers/) for more information about controllers.

<!--
<section id="add-a-view"></section>
## Add a View
-->
