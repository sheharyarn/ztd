ZTD
===

[![Build Status][shield-travis]][travis-ci]
[![License][shield-license]][github]

> Todo App written in Elixir/Phoenix using RabbitMQ

This is a small experiment using RabbitMQ. The app is designed to be run in
one of two modes; `Engine` and `Worker`. When run in Engine mode, the app
stores and reads items from disk. When run in Worker mode, the app doesn't
have it's own state, instead it listens to events from the engine and
dispatches events to it when actions are performed.

**Demo:**

[![ZTD Demo Video][demo-thumb]][demo-video]

<br>




## Setup

Following dependencies are required:

 - Erlang 20+
 - Elixir 1.6+
 - Postgres
 - RabbitMQ

Compile Application and Assets:

```bash
$ mix do deps.get, compile
$ mix do ecto.create, ecto.migrate
$ cd assets && npm install
```

<br>




## Running the App

To start the app in `Engine` mode:

```bash
$ PORT=4000 APP_MODE=engine mix phx.server
```

To start it in `Worker` mode:

```bash
$ PORT=5000 APP_MODE=worker mix phx.server
```

You can also use [`foreman`][foreman] to run multiple instances easily.
This will start the engine on port `4000` and 4 workers on ports `5001`,
`5002`, `5003` & `5004`:

```bash
$ gem install foreman
$ foreman start
```

<br>




## Implementation Details

The application exports one main module `Todo`, whose implementation is
further organized into two adapters `Engine` and `Worker`. Depending on
the mode the application is started in, the supervisor only boots those
processes, and the Todo module delegates the function calls to the
appropriate adapter. Since the Web UI only directly interacts with the
`Todo` module, so it does not concern itself with the implementation.

When the application is running in the Engine mode, it stores and reads
items from the Postgres database. Actions performed via the Todo
interface are wrapped in an `Event` struct, and when successful, are
broadcasted both on all open Phoenix channels as well as on a RabbitMQ
fanout exchange.

When run in Worker mode, the app does not have its own state, volatile
or non-volatile. This is by design. It gets initial list of items via
an RPC call implmented over RabbitMQ and listens for events on the
fanout exchange. When actions are performed, they are again wrapped as
events and dispatched to the Engine where when successfully performed,
are broadcasted and received backed by all workers. This also acts as
an acknowledgement.

Admittedly, the app is not "truly distributed" since each worker does
not have its own state, and does not have any kind of partition
tolerance. Other than that, something like CQRS would be a great way
to ensure consistency.

<br>




## Testing and Contributing

The app consists of a very modest test suite. You can run them with mix:

```bash
$ mix test
```

You can also help by contributing to the project:

 - [Fork][github-fork], Enhance, Send PR
 - Lock issues with any bugs or feature requests
 - Implement something from Roadmap
 - Spread the word :heart:

<br>




## License

The code is available as open source under the terms of the [MIT License][license].

<br>




  [shield-license]:   https://img.shields.io/github/license/sheharyarn/ztd.svg
  [shield-travis]:    https://img.shields.io/travis/sheharyarn/ztd/master.svg
  [travis-ci]:        https://travis-ci.org/sheharyarn/ztd

  [license]:          https://opensource.org/licenses/MIT
  [foreman]:          https://github.com/ddollar/foreman
  [github]:           https://github.com/sheharyarn/ztd/
  [github-fork]:      https://github.com/sheharyarn/ztd/fork

  [demo-thumb]:       https://i.imgur.com/wfYayRul.png
  [demo-video]:       https://to.shyr.io/2tebNiP
