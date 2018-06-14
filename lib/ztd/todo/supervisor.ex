defmodule ZTD.Todo.Supervisor do
  use Supervisor

  alias  ZTD.Todo.Config
  import Supervisor.Spec


  @moduledoc """
  Manages the Todo Supervision Tree and starts the
  appropriate Mode Adapter (Engine/Worker) depending
  on the specified env config

  NOTE:
  If the application grows too complex, consider
  creating sub-supervisors for both Engine and Worker
  within their Adapters
  """




  ## Public API
  ## ----------


  @doc "Start the Todo Supervisor"
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end





  ## Callbacks
  ## ---------


  def init(:ok) do
    Config.mode()
    |> children()
    |> Supervisor.init(strategy: :one_for_one)
  end





  ## Children Spec
  ## -------------


  # Children for Engine Mode
  defp children(:engine) do
    [
      supervisor(ZTD.Repo, []),
      worker(ZTD.Todo.Engine.Listener, []),
    ]
  end


  # Children for Worker Mode
  defp children(:worker) do
    [
      worker(ZTD.Todo.Worker.Broadcaster, []),
    ]
  end



  # Raise error for other modes
  defp children(_mode) do
    raise "Supervision Tree not defined for specified mode"
  end


end
