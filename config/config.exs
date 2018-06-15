use Mix.Config


# General Application Config
config :ztd,
  namespace: ZTD,
  ecto_repos: [ZTD.Repo],
  generators: [binary_id: true]


# Todo Settings / Mode Adapters
config :ztd, :todo,
  env_var: "APP_MODE",
  default: :engine,
  adapters: [
    engine: ZTD.Todo.Engine,
    worker: ZTD.Todo.Worker,
  ],
  amqp: [
    request_queue:    "ztd.todo.requests.queue",
    request_exchange: "ztd.todo.requests.exchange",
    broadcast_exchange: "ztd.todo.broadcasts.exchange",
    broadcast_routing:  "ztd.todo.broadcasts.routing",
  ]


# Endpoint
config :ztd, ZTD.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q6jgvP5PBpizrwNmRpmL+jufEpjbTV9JjEH+FC6HngbYlk2EThFD2CHKSAZ85jOy",
  render_errors: [view: ZTD.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZTD.PubSub, adapter: Phoenix.PubSub.PG2]


# Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
