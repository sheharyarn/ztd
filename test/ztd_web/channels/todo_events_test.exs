defmodule ZTD.Tests.Web.Channels.TodoEvents do
  use ZTD.Tests.Support.ChannelCase


  @channel ZTD.Web.Channels.TodoEvents
  @room "todo_events"


  setup do
    {:ok, _, socket} =
      "user_id"
      |> socket(%{})
      |> subscribe_and_join(@channel, @room)

    [socket: socket]
  end

end
