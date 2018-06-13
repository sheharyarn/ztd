defmodule ZTD.Application do
  use Application


  @doc "Start application supervision tree"
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ZTD.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ZTD.Web.Endpoint, []),
      # Start your own worker by calling: ZTD.Worker.start_link(arg1, arg2, arg3)
      # worker(ZTD.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ZTD.Supervisor]
    Supervisor.start_link(children, opts)
  end


  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ZTD.Web.Endpoint.config_change(changed, removed)
    :ok
  end

end
