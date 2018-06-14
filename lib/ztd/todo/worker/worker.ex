defmodule ZTD.Todo.Worker do
  alias ZTD.Todo.Event
  alias ZTD.Todo.Worker.Dispatcher


  @moduledoc """
  Worker implementation for the Todo interface.
  Implements all methods defined in the Todo module.

  Each action is wrapped in an event and dispatched
  to the engine.
  """



  @doc "Get all todos"
  def all do
    # TODO: Implement
    []
  end


  @doc "Insert new todo"
  def insert(%{} = params) do
    :insert
    |> Event.new(params)
    |> Dispatcher.send!
  end


  @doc "Update a todo"
  def update(id, %{} = params) do
    data = Map.put(params, :id, id)

    :update
    |> Event.new(data)
    |> Dispatcher.send!
  end


  @doc "Delete a todo"
  def delete(id) do
    :delete
    |> Event.new(%{id: id})
    |> Dispatcher.send!
  end

end
