defmodule ZTD.Web.Channels.TodoEvents do
  use Phoenix.Channel
  alias ZTD.Todo


  # Connect to Channel
  # ------------------

  def join("todo_events", _payload, socket) do
    {:ok, socket}
  end




  # Handle Events
  # -------------

  def handle_in("update", payload, socket) do
    %{id: id} = item = parse(payload)
    Todo.update(id, item)
    {:noreply, socket}
  end




  # Private Helpers
  # ---------------

  defp parse(payload) do
    %{data: item} =
      BetterParams.symbolize_merge(payload, drop_string_keys: true)

    item
  end

end
