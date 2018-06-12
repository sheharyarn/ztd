defmodule ZTD.Web.Channels.TodoEvents do
  use Phoenix.Channel


  # Connect to Channel
  # ------------------

  def join("todo_events", _payload, socket) do
    {:ok, socket}
  end




  # Handle Events
  # -------------

  def handle_in("update", payload, socket) do
    require Logger
    Logger.error inspect payload
    {:reply, {:ok, payload}, socket}
    {:noreply, socket}
  end

end
