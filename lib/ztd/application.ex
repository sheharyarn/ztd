defmodule ZTD.Application do
  use Application


  @doc "Start application supervision tree"
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Todo Sub App
      supervisor(ZTD.Todo.Supervisor, []),

      # Web Server
      supervisor(ZTD.Web.Endpoint,    []),
    ]

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
