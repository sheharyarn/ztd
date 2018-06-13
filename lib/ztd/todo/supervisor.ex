defmodule ZTD.Todo.Supervisor do
  use Supervisor
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


  @doc "Return the Application mode"
  def mode do
    mode =
      :env_var
      |> config()
      |> System.get_env
      |> normalize()

    case (mode in allowed_modes()) do
      true  -> mode
      false -> raise "Unknown Application Mode"
    end
  end


  @doc "Return the correct adapter for config"
  def adapter do
    config(:adapters) |> Keyword.get(mode())
  end






  ## Callbacks
  ## ---------


  def init(:ok) do
    mode()
    |> children()
    |> Supervisor.init(strategy: :one_for_one)
  end





  ## Private Helpers
  ## ---------------


  # Define children for application modes
  defp children(:engine) do
    [
      supervisor(ZTD.Repo, []),
    ]
  end

  defp children(_mode) do
    raise "Supervision Tree not defined for specified mode"
  end


  # Get Config
  defp config do
    Application.get_env(:ztd, :mode)
  end

  defp config(key, default \\ nil) when is_atom(key) do
    Keyword.get(config(), key, default)
  end


  defp allowed_modes do
    Keyword.keys(config(:adapters))
  end


  defp normalize(str) do
    "#{str}"
    |> String.downcase
    |> String.to_existing_atom
  end


end
