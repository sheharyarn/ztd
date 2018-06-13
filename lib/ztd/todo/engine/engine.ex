defmodule ZTD.Todo.Engine do
  alias ZTD.Repo
  alias ZTD.Todo.Engine.Schema
  alias Ecto.Query

  require Query


  @moduledoc """
  Provides an interface to add, update, delete and
  mark items done/undone.
  """



  @doc "Get all todos"
  def all do
    Schema
    |> Query.order_by(asc: :inserted_at)
    |> Repo.all
  end



  @doc "Insert new todo"
  def insert(%{} = params) do
    Schema.insert(params)
  end



  @doc "Update a todo"
  def update(id, %{} = params) do
    id
    |> Schema.get!
    |> Schema.update(params)
  end



  @doc """
  Delete a todo

  Using a where clause so it doesn't raise errors for
  stale structs
  """
  def delete(id) do
    Schema
    |> Query.where([i], i.id == ^id)
    |> Repo.delete_all
    :ok
  end

end
