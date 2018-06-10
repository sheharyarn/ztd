defmodule ZTD.Tests.Support do
  @moduledoc "Support methods for tests"


  @doc """
  Setup Ecto for each test

  If the test case interacts with the database, it cannot be async. For this
  reason, every test runs inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """
  def setup_ecto(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ZTD.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ZTD.Repo, {:shared, self()})
    end
    :ok
  end




  defmodule Schema do
    @doc """
    A helper that transform changeset errors to a map of messages.

        assert {:error, changeset} = Accounts.create_user(%{password: "short"})
        assert "password is too short" in errors_on(changeset).password
        assert %{password: ["password is too short"]} = errors_on(changeset)

    """
    def errors_on(changeset) do
      Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
        Enum.reduce(opts, message, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
    end


    def error_message(changeset, field) do
      case changeset.errors[field] do
        {message, _} -> message
        _something   -> nil
      end
    end

  end
end
