defmodule ZTD.Web.Channels.TodoEvents do
  use Phoenix.Channel

  alias ZTD.Todo
  alias ZTD.Web.Endpoint


  @allowed [:insert, :update, :delete]
  @channel "todo_events"
  @relay   "event"


  # Connect to Channel
  # ------------------

  def join(@channel, _payload, socket) do
    {:ok, socket}
  end




  # Handle Events
  # -------------


  def handle_in("insert", payload, socket) do
    item = parse(payload)
    Todo.insert(item)
    broadcast_event!(:insert, item)
    {:noreply, socket}
  end


  def handle_in("update", payload, socket) do
    item = %{id: id} = parse(payload)
    Todo.update(id, item)
    broadcast_event!(:update, item)
    {:noreply, socket}
  end


  def handle_in("delete", payload, socket) do
    item = %{id: id} = parse(payload)
    Todo.delete(id)
    broadcast_event!(:delete, item)
    {:noreply, socket}
  end




  # Private Helpers
  # ---------------

  defp parse(payload) do
    payload
    |> BetterParams.symbolize_merge(drop_string_keys: true)
    |> Map.get(:data)
  end


  defp broadcast_event!(type, item) when type in @allowed do
    payload = %{type: type, data: item}
    Endpoint.broadcast!(@channel, @relay, payload)
  end

end
