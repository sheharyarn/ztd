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

Demo:

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

This package is available as open source under the terms of the [MIT License][license].

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
