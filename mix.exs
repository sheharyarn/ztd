defmodule ZTD.Mixfile do
  use Mix.Project


  def project do
    [
      app: :ztd,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end


  def application do
    [
      mod: {ZTD.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end


  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]


  defp deps do
    [
      {:phoenix,              "~> 1.3.2"},
      {:phoenix_pubsub,       "~> 1.0"},
      {:phoenix_ecto,         "~> 3.2"},
      {:postgrex,             ">= 0.0.0"},
      {:gettext,              "~> 0.11"},
      {:cowboy,               "~> 1.0"},
      {:phoenix_html,         "~> 2.10"},
      {:phoenix_live_reload,  "~> 1.0", only: :dev},

      {:ecto_rut,             "~> 1.2.2"},
      {:better_params,        "~> 0.5.0"},
      {:react_phoenix,        "~> 0.5.2"},
      {:amqp,                 "~> 0.3.1"},
    ]
  end


  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
