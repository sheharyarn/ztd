defmodule ZTD.Tests.Web.Channels.TodoEvents do
  use ZTD.Tests.Support.ChannelCase

  alias ZTD.Todo.Item
  alias ZTD.Web.Channels.TodoEvents


  @channel  TodoEvents
  @room     "todo_events"


  setup do
    {:ok, _, socket} =
      "user_id"
      |> socket(%{})
      |> subscribe_and_join(@channel, @room)

    [socket: socket]
  end



  describe "#handle_in" do
    @item  %{title: "get milk"}
    @event "insert"
    test "inserts new items on insert event", %{socket: socket} do
      assert length(Item.all) == 0

      push(socket, @event, %{data: @item})
      Support.wait

      assert [item] = Item.all
      assert item.title == @item.title
    end
  end

end
