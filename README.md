ZTD
===

[![Build Status][shield-travis]][travis-ci]
[![License][shield-license]][hexpm]

> Todo App written in Elixir/Phoenix using RabbitMQ

This is a small experiment using RabbitMQ. The app is designed to be run in
one of two modes; `Engine` and `Worker`. When run in Engine mode, the app
stores and reads items from disk. When run in Worker mode, the app doesn't
have it's own state, instead it listens to events from the worker and
dispatches events to it when actions are performed.

See the demo:

[![ZTD Demo Video][demo-thumb]][demo-video]

<br>




## Set up



## Running the App



## Implementation Details



## Testing and Contributing

The app consists of a very modest test suite. You can run them with mix:

```bash
mix test
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
  [github-fork]:      https://github.com/sheharyarn/ztd/fork

  [demo-thumb]:       https://i.imgur.com/wfYayRul.png
  [demo-video]:       https://to.shyr.io/2tebNiP
