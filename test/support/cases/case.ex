defmodule ZTD.Tests.Support.Case do
  use ExUnit.CaseTemplate

  @moduledoc """
  Default Test Case with important aliases/imports
  """


  using do
    quote do
      alias ZTD.Repo
      alias ZTD.Tests.Support

      alias Ecto.Query
      alias Ecto.Changeset

      require Query
      import Support.Schema
    end
  end


  setup tags do
    ZTD.Tests.Support.setup_ecto(tags)
  end

end
