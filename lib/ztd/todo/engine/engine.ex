defmodule ZTD.Todo.Engine do
  alias ZTD.Repo
  alias ZTD.Todo.Event
  alias ZTD.Todo.Engine.Schema
  alias ZTD.Todo.Engine.Broadcaster
  alias Ecto.Query

  require Query


  @moduledoc """
  Engine implementation for the Todo interface.
  Implements all methods defined in Todo module.
  """



  # Public API
  # ----------


  @doc "Get all todos"
  def all do
    Schema
    |> Query.order_by(asc: :inserted_at)
    |> Repo.all
  end



  @doc "Insert new todo"
  def insert(%{} = params) do
    params
    |> Schema.insert
    |> broadcast!(:insert)
  end



  @doc "Update a todo"
  def update(id, %{} = params) do
    id
    |> Schema.get!
    |> Schema.update(params)
    |> broadcast!(:update)
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

    broadcast!({:ok, %{id: id}}, :delete)
  end





  # Private Helpers
  # ---------------


  # Broadcast on success
  defp broadcast!({:ok, item}, type) do
    type
    |> Event.new(item)
    |> Broadcaster.broadcast!

    :ok
  end

  defp broadcast!(term, _type) do
    term
  end


end
