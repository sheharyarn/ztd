defmodule ZTD.Tests.Web.Channels.TodoEvents do
  use ZTD.Tests.Support.ChannelCase

  alias ZTD.Todo.Item
  alias ZTD.Web.Channels.TodoEvents


  @channel TodoEvents
  @room "todo_events"
  @relay "event"



  setup do
    {:ok, _, socket} =
      "user_id"
      |> socket(%{})
      |> subscribe_and_join(@channel, @room)

    [socket: socket]
  end



  # TODO:
  # Have separate tests for broadcasts


  describe "#handle_in" do
    @event "insert"
    test "inserts new items on insert event", %{socket: socket} do
      assert length(Item.all) == 0

      new = %{title: "get milk"}
      push(socket, @event, %{data: new})
      assert_broadcast!(@event, %{data: %{title: new.title}})
      Support.wait

      assert [item] = Item.all
      assert item.title == new.title
    end


    @event "update"
    test "updates existing items", %{socket: socket} do
      old = Item.insert!(title: "done item", done: true)
      new = %{id: old.id, title: "pending", done: false}

      push(socket, @event, %{data: new})
      assert_broadcast!(@event, %{data: %{title: new.title}})
      Support.wait

      assert item = Item.get(old.id)
      assert item.title == new.title
      assert item.done == new.done
    end


    @event "delete"
    test "deletes existing items", %{socket: socket} do
      item_1 = Item.insert!(title: "done item", done: true)
      item_2 = Item.insert!(title: "pending item", done: false)

      push(socket, @event, %{data: %{id: item_1.id}})
      assert_broadcast!(@event, %{data: %{id: item_1.id}})
      Support.wait

      refute Item.get(item_1.id)
      assert Item.get(item_2.id)
    end
  end




  # Private Helpers
  # ---------------

  defp assert_broadcast!(event, payload \\ %{}) do
    payload = Map.put(payload, :type, String.to_atom(event))
    assert_broadcast(@relay, payload)
  end

end
