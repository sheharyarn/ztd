defmodule ZTD.Tests.Todo.Engine do
  use ZTD.Tests.Support.Case

  alias ZTD.Todo.Engine



  describe "all/0" do
    test "returns empty list when no todo items exist" do
      assert Engine.all == []
    end


    test "returns items in ascending order of creation date" do
      Engine.Schema.insert!(title: "Done 1",    done: true)
      Engine.Schema.insert!(title: "Pending 1", done: false)
      Engine.Schema.insert!(title: "Pending 2", done: false)
      Engine.Schema.insert!(title: "Done 2",    done: true)

      items = Engine.all |> Enum.map(&(&1.title))
      assert items == ["Done 1", "Pending 1", "Pending 2", "Done 2"]
    end
  end



  describe "insert/1" do
    test "returns :ok for valid params" do
      assert {:ok, _} = Engine.insert(%{title: "Buy Milk"})
      assert 1 = length(Engine.Schema.all)

      assert {:ok, _} = Engine.insert(%{title: "Buy Eggs", done: true})
      assert 2 = length(Engine.Schema.all)
    end


    test "return :error for invalid params" do
      assert {:error, changeset} = Engine.insert(%{title: nil})
      assert error_message(changeset, :title) =~ ~r/can't be blank/
    end
  end



  describe "update/2" do
    setup do
      [item: Engine.Schema.insert!(title: "Some Engine.Schema")]
    end


    test "can update the title of an item", %{item: item} do
      assert {:ok, item} = Engine.update(item.id, %{title: "New Name"})
      assert item.title == "New Name"
    end


    test "can mark items done", %{item: item} do
      assert {:ok, item} = Engine.update(item.id, %{done: true})
      assert item.done == true
    end
  end



  describe "delete/1" do
    setup do
      [item: Engine.Schema.insert!(title: "Some Engine.Schema")]
    end


    test "deletes an item if it exists", %{item: item} do
      assert :ok = Engine.delete(item.id)
      assert 0 = length(Engine.Schema.all)
    end


    test "does nothing if the item does not exist" do
      unknown_id = Ecto.UUID.generate
      assert :ok = Engine.delete(unknown_id)
      assert 1 = length(Engine.Schema.all)
    end
  end

end
