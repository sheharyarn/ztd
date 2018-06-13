defmodule ZTD.Todo do
  import ZTD.Todo.Config, only: [adapter: 0]


  @moduledoc """
  Provides an interface to add, update, delete and
  mark items done/undone. Selects the correct adapter
  and delegates the method call to it.

  NOTE:
  If the application grows complex in the future, it
  would make sense to turn this into a behaviour and
  define a __using__ macro which implements it and
  verifies if all callbacks have been implemented.
  """




  @doc "Get all todos"
  def all do
    adapter().all()
  end



  @doc "Insert new todo"
  def insert(%{} = params) do
    adapter().insert(params)
  end



  @doc "Update a todo"
  def update(id, %{} = params) do
    adapter().update(id, params)
  end



  @doc "Delete a todo"
  def delete(id) do
    adapter().delete(id)
  end



end
