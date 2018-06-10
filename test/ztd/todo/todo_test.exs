defmodule ZTD.Tests.Todo do
  use ZTD.Tests.Support.Case

  alias ZTD.Todo
  alias ZTD.Todo.Item



  describe "all/0" do
    test "returns empty list when no todo items exist" do
      assert Todo.all == []
    end


    test "returns pending items first, and done items at the end" do
      Item.insert!(title: "Done 1",    done: true)
      Item.insert!(title: "Pending 1", done: false)
      Item.insert!(title: "Pending 2", done: false)
      Item.insert!(title: "Done 2",    done: true)

      items = Todo.all |> Enum.map(&(&1.title))
      assert items == ["Pending 1", "Pending 2", "Done 1", "Done 2"]
    end
  end



  describe "insert/1" do
    test "returns :ok for valid params" do
      assert {:ok, _} = Todo.insert(%{title: "Buy Milk"})
      assert 1 = length(Item.all)

      assert {:ok, _} = Todo.insert(%{title: "Buy Eggs", done: true})
      assert 2 = length(Item.all)
    end


    test "return :error for invalid params" do
      assert {:error, changeset} = Todo.insert(%{title: nil})
      assert error_message(changeset, :title) =~ ~r/can't be blank/
    end
  end



  describe "update/2" do
    setup do
      [item: Item.insert!(title: "Some Item")]
    end


    test "can update the title of an item", %{item: item} do
      assert {:ok, item} = Todo.update(item.id, %{title: "New Name"})
      assert item.title == "New Name"
    end


    test "can mark items done", %{item: item} do
      assert {:ok, item} = Todo.update(item.id, %{done: true})
      assert item.done == true
    end
  end



  describe "delete/1" do
    setup do
      [item: Item.insert!(title: "Some Item")]
    end


    test "deletes an item if it exists", %{item: item} do
      assert :ok = Todo.delete(item.id)
      assert 0 = length(Item.all)
    end


    test "does nothing if the item does not exist" do
      unknown_id = Ecto.UUID.generate
      assert :ok = Todo.delete(unknown_id)
      assert 1 = length(Item.all)
    end
  end

end
