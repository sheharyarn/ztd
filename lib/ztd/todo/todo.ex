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



  @doc "Update a todo"
  def update(id, %{} = params) do
    id
    |> Item.get!
    |> Item.update(params)
  end



  @doc """
  Delete a todo

  Using a where clause so it doesn't raise errors for
  stale structs
  """
  def delete(id) do
    Item
    |> Query.where([i], i.id == ^id)
    |> Repo.delete_all
    :ok
  end

end
