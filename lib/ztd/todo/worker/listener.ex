defmodule ZTD.Todo.Worker.Listener do
  use GenServer
  require Logger

  alias ZTD.Todo.Event
  alias ZTD.Todo.Config
  alias ZTD.Web.Channels

  @exchange Config.get(:amqp)[:broadcast_exchange]
  @routing  Config.get(:amqp)[:broadcast_routing]
  @queue    ""


  @moduledoc """
  Creates a temporary queue bound to the fanout exchange,
  listening for events broadcasted from the engine. When
  messages are received they are then broadcasted to the
  clients connected on the Phoenix Channel as well.
  """




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
    AMQP.Exchange.declare(channel, @exchange, :fanout)
    {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, @queue, exclusive: true)
    AMQP.Queue.bind(channel, @queue, @exchange, routing_key: @routing)

    # Start Consuming
    AMQP.Basic.consume(channel, queue, nil, no_ack: true)

    {:ok, channel}
  end



  # Receive Messages
  @doc false
  def handle_info({:basic_deliver, payload, meta}, channel) do
    Logger.debug("Received RabbitMQ Message: #{inspect payload}")

    spawn fn ->
      consume(payload, meta)
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


  # Parse the event and perform the actions
  defp consume(payload, _meta) do
    payload
    |> Event.decode!
    |> Channels.TodoEvents.broadcast!
  rescue
    Event.InvalidError ->
      raise "Received invalid event data #{inspect(payload)}"
  end

end

