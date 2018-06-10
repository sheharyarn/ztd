defmodule ZTD.Repo.Schema do

  @moduledoc """
  Custom Macro for initializing Schemas with
  sane defaults
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      use Ecto.Rut, repo: ZTD.Repo

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      import  Ecto.Changeset
      require Ecto.Query

      alias Ecto.Query
      alias ZTD.Repo
    end
  end

end

