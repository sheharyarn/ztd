defmodule ZTD.Tests.Support.ChannelCase do
  use ExUnit.CaseTemplate

  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """


  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      alias ZTD.Tests.Support

      # The default endpoint for testing
      @endpoint ZTD.Web.Endpoint
    end
  end


  setup tags do
    ZTD.Tests.Support.setup_ecto(tags)
  end

end
