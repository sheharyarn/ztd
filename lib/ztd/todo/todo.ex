defmodule ZTD.Todo do
  use Supervisor


  @moduledoc """
  Manages the Todo Supervision Tree and starts the
  appropriate Mode Adapter (Engine/Worker) depending
  on the specified env config
  """




  ## Public API
  ## ----------


  @doc "Start the Todo Supervisor"
  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end


  @doc "Return the Application mode"
  def mode do
    mode =
      :env_var
      |> config()
      |> System.get_env
      |> normalize()

    if mode in allowed_modes() do
      mode
    else
      raise "Unknown Application Mode"
    end
  end


  @doc "Return the correct adapter for config"
  def adapter do
    config(:adapters) |> Keyword.get(mode())
  end





  ## Private Helpers
  ## ---------------

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
