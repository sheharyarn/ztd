defmodule ZTD.Todo do
  alias ZTD.Repo
  alias ZTD.Todo.Item
  alias Ecto.Query

  require Query

  @moduledoc """
  Provides an interface to add, update, delete and
  mark items done/undone.
  """


  @doc "Get all todos"
  def all do
    Item
    |> Query.order_by(asc: :done)
    |> Repo.all
  end



  @doc "Insert new todo"
  def insert(%{} = params) do
    Item.insert(params)
  end

end
