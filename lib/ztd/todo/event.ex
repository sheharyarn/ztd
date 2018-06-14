defmodule ZTD.Todo.Event do
  alias ZTD.Todo.Event

  @moduledoc """
  Event representing some sort of change to the Todo List
  """


  defstruct [:type, :data]
  @allowed_types [:insert, :update, :delete]



  @doc "Create new change event"
  def new(type, data) when type in @allowed_types do
    %Event{type: type, data: data}
  end


end
