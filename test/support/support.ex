defmodule ZTD.Tests.Support do
  @moduledoc """
  Helper Methods for Tests
  """


  @doc "Setup Ecto for each test"
  def setup_ecto(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ZTD.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ZTD.Repo, {:shared, self()})
    end

    :ok
  end

end
