defmodule ZTD.Todo.Engine.Listener do
  use GenServer
  require Logger

  alias ZTD.Todo
  alias ZTD.Todo.Event
  alias ZTD.Todo.Config


  @moduledoc """
  Listens to events directly sent from workers to the
  engine. Performs the operations associated with the
  events using the main Engine module, which on success,
  broadcast them back to all workers. This acts as an
  acknowledgement, updating the workers Web UI state.

  NOTE:
  This is inefficient. For making this app "truly"
  distributed, consider having atleast a volatile state
  for each worker (maybe as a process?). This way we
  can reflect changes in UI instantly, and eventually
  support CQRS for partition tolerance.

  Also create a separate GenServer for handling RPC
  requests.
  """


  @queue    Config.get(:amqp)[:engine_queue]
  @exchange Config.get(:amqp)[:engine_exchange]
  @rpc      ""




  ## Public API
  ## ----------


  @doc "Open the connection"
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end




  ## Callbacks
  ## ---------


  # Initialize State
  @doc false
  def init(:ok) do
    # Create Connection & Channel
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel}    = AMQP.Channel.open(connection)

    # Declare Exchange & Queue
    AMQP.Exchange.declare(channel, @exchange, :direct)
    AMQP.Queue.declare(channel, @queue, durable: false)
    AMQP.Queue.bind(channel, @queue, @exchange, routing_key: @queue)

    # Start Consuming
    AMQP.Basic.consume(channel, @queue, nil, no_ack: true)

    {:ok, channel}
  end



  # Receive Messages
  @doc false
  def handle_info({:basic_deliver, payload, meta}, channel) do
    Logger.debug("Received Payload: #{inspect payload}")

    spawn fn ->
      consume(channel, payload, meta)
    end

    {:noreply, channel}
  end



  # Discard all other messages
  @doc false
  def handle_info(message, state) do
    Logger.debug("Received info: #{inspect message}")
    {:noreply, state}
  end





  ## Private Helpers
  ## ---------------


  # Consume RPC calls and respond accordingly
  defp consume(channel, command, %{type: "rpc"} = meta) do
    Logger.debug("Message Type: RPC Call")

    case command do
      "all" ->
        rpc_reply!(channel, meta, Todo.all)

      _ ->
        raise "Unknown RPC Command: #{inspect(command)}"
    end
  end


  # Consume event messages and perform appropriate actions
  defp consume(_channel, payload, %{type: "event"}) do
    Logger.debug("Message Type: Event Dispatch")
    %Event{type: type, data: data} = Event.decode!(payload)

    case type do
      :insert ->
        Todo.insert(data)

      :update ->
        Todo.update(data.id, data)

      :delete ->
        Todo.delete(data.id)

      _ ->
        raise "Don't know how to perform operation #{inspect(type)}"
    end

  rescue
    Event.InvalidError ->
      raise "Received invalid event data #{inspect(payload)}"
  end


  # Handle unknown message types
  defp consume(_channel, _payload, meta) do
    Logger.error("Unknown Message Type. Supplied Metadata: #{inspect(meta)}")
  end


  # Respond to an RPC call
  defp rpc_reply!(channel, meta, response) do
    AMQP.Basic.publish(
      channel,
      @rpc,
      meta.reply_to,
      response,
      correlation_id: meta.correlation_id
    )
  rescue
    _ -> raise "Could not reply to RPC request: #{inspect(meta)}"
  end


end
