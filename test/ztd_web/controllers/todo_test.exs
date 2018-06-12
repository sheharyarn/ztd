defmodule ZTD.Tests.Web.Controllers.Todo do
  use ZTD.Tests.Support.ConnCase

  alias ZTD.Todo


  describe "#index" do
    @path Router.todo_path(@endpoint, :index)

    setup context do
      {:ok, _} = Todo.insert(%{title: "Pending Item", done: false})
      {:ok, _} = Todo.insert(%{title: "Done Item",    done: true})
      context
    end

    test "renders the todo react component with todo items", %{conn: conn} do
      response =
        conn
        |> get(@path)
        |> html_response(200)

      assert response =~ ~r/data-react-class=.Components.Todo/
      assert response =~ ~r/Pending Item/
      assert response =~ ~r/Done Item/
    end
  end

end
