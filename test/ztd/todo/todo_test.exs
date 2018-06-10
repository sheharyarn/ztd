defmodule ZTD.Tests.Todo do
  use ZTD.Tests.Support.Case
  alias ZTD.Todo



  describe "all/0" do
    test "returns empty list when no todo items exist" do
      assert Todo.all == []
    end


    test "returns pending items first, and done items at the end" do
      Todo.Item.insert!(title: "Done 1",    done: true)
      Todo.Item.insert!(title: "Pending 1", done: false)
      Todo.Item.insert!(title: "Pending 2", done: false)
      Todo.Item.insert!(title: "Done 2",    done: true)

      items = Todo.all |> Enum.map(&(&1.title))
      assert items == ["Pending 1", "Pending 2", "Done 1", "Done 2"]
    end
  end



  describe "insert/1" do
    test "returns :ok for valid params" do
      assert {:ok, _} = Todo.insert(%{title: "Buy Milk"})
      assert 1 = length(Todo.Item.all)

      assert {:ok, _} = Todo.insert(%{title: "Buy Eggs", done: true})
      assert 2 = length(Todo.Item.all)
    end


    test "return :error for invalid params" do
      assert {:error, changeset} = Todo.insert(%{title: nil})
      assert error_message(changeset, :title) =~ ~r/can't be blank/
    end
  end
end
