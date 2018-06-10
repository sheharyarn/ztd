defmodule ZTD.Tests.Support.Case do
  use ExUnit.CaseTemplate


  using do
    quote do
    end
  end


  setup tags do
    ZTD.Tests.Support.setup_ecto(tags)
  end

end
