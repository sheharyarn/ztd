defmodule ZTD.Web.Channels.TodoEvents do
  use Phoenix.Channel

  alias ZTD.Todo
  alias ZTD.Todo.Event
  alias ZTD.Web.Endpoint


  @channel "todo_events"
  @relay   "event"





  # Public API
  # ----------


  @doc """
  Broadcasts a Todo Event to all connected clients
  on the channel

  NOTE:
  This method is being called from the main Todo
  modules, which may cause weird issues in situations
  where the Endpoint process hasn't been started but
  this method is called. Consider wrapping this in
  another module which verifies the Endpoint process
  has already been started as part of the supervision
  tree.
  """
  def broadcast!(%Event{} = event) do
    Endpoint.broadcast!(@channel, @relay, event)
  end





  # Callbacks
  # ---------


  # Join Channel

  def join(@channel, _payload, socket) do
    {:ok, socket}
  end



  # Handle Events

  def handle_in("insert", payload, socket) do
    item = parse(payload)
    Todo.insert(item)
    {:noreply, socket}
  end


  def handle_in("update", payload, socket) do
    item = %{id: id} = parse(payload)
    Todo.update(id, item)
    {:noreply, socket}
  end


  def handle_in("delete", payload, socket) do
    item = %{id: id} = parse(payload)
    Todo.delete(id)
    {:noreply, socket}
  end




  # Private Helpers
  # ---------------

  defp parse(payload) do
    payload
    |> BetterParams.symbolize_merge(drop_string_keys: true)
    |> Map.get(:data)
  end


end
