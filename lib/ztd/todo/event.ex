defmodule ZTD.Todo.Event do
  defmodule InvalidError, do: defexception [:message]

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

  def new(type, _data) do
    raise Event.InvalidError, message: "Invalid type: #{inspect type}"
  end



  @doc "Encode event to string"
  def encode!(%Event{} = event) do
    Poison.encode!(event)
  end


  @doc "Decode string back to event"
  def decode!(string) when is_binary(string) do
    contents =
      string
      |> Poison.decode!
      |> BetterParams.symbolize_merge(drop_string_keys: true)

    contents.type
    |> String.to_existing_atom
    |> new(contents.data)
  rescue
    _ ->
      raise Event.InvalidError, message: "Can't parse event: #{inspect string}"
  end

end
