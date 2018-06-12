defmodule ZTD.Web.Channels.TodoEvents do
  use Phoenix.Channel

  alias ZTD.Todo
  alias ZTD.Web.Endpoint


  @channel  "todo_events"
  @outgoing "event"
  @allowed  [:insert, :update, :delete]


  # Connect to Channel
  # ------------------

  def join(@channel, _payload, socket) do
    {:ok, socket}
  end




  # Handle Events
  # -------------


  def handle_in("insert", payload, socket) do
    item = parse(payload)
    {:ok, item} = Todo.insert(item)
    broadcast_event!(:insert, item)
    {:noreply, socket}
  end


  def handle_in("update", payload, socket) do
    item = %{id: id} = parse(payload)
    {:ok, item} = Todo.update(id, item)
    broadcast_event!(:update, item)
    {:noreply, socket}
  end


  def handle_in("delete", payload, socket) do
    item = %{id: id} = parse(payload)
    :ok = Todo.delete(id)
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
    Endpoint.broadcast!(@channel, @outgoing, payload)
  end

end
