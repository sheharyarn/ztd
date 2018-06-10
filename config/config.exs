# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ztd,
  namespace: ZTD,
  ecto_repos: [ZTD.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :ztd, ZTD.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q6jgvP5PBpizrwNmRpmL+jufEpjbTV9JjEH+FC6HngbYlk2EThFD2CHKSAZ85jOy",
  render_errors: [view: ZTD.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZTD.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
