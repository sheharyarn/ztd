defmodule ZTD.Todo.Config do
  @moduledoc """
  Interface for getting Todo Configs
  """

  @app_name   :ztd
  @config_key :todo





  ## Public API
  ## ----------


  @doc "Get Todo Config"
  def get do
    Application.get_env(@app_name, @config_key)
  end


  @doc "Get Todo config for a specific key"
  def get(key, default \\ nil) when is_atom(key) do
    get() |> Keyword.get(key, default)
  end


  @doc "Return the Application mode"
  def mode do
    mode =
      :env_var
      |> get()
      |> System.get_env
      |> normalize()
      |> fallback_to_default()

    case (mode in allowed_modes()) do
      true  -> mode
      false -> raise "Unknown Application Mode"
    end
  end


  @doc "Return the correct adapter for config"
  def adapter do
    get(:adapters) |> Keyword.get(mode())
  end





  ## Private Helpers
  ## ---------------


  defp allowed_modes do
    Keyword.keys(get(:adapters))
  end

  defp normalize(str) do
    "#{str}"
    |> String.downcase
    |> String.to_existing_atom
  end

  defp fallback_to_default(mode) do
    case mode do
      mode when mode in ["", :"", nil] ->
        get(:default)

      mode -> mode
    end
  end

end
