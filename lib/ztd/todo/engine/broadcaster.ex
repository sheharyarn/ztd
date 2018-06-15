defmodule ZTD.Todo.Engine.Broadcaster do
  use GenServer

  alias ZTD.Todo.Event
  alias ZTD.Todo.Config
  alias ZTD.Web.Channels

  @exchange Config.get(:amqp)[:broadcast_exchange]
  @routing  Config.get(:amqp)[:broadcast_routing]


  @moduledoc """
  Keeps a RabbitMQ connection open to a fanout exchange
  where each worker is connected to. When messages are
  broadcasted, they're sent to all workers, and also to
  all the Phoenix channels (locally, on each instance).
  """




  ## Public API
  ## ----------


  @doc "Open the connection"
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end


  @doc "Broadcast event on the fanout exchange"
  def broadcast!(%Event{} = event) do
    GenServer.cast(__MODULE__, {:broadcast, event})
  end





  ## Callbacks
  ## ---------


  # Initialize State
  @doc false
  def init(:ok) do
    # Create Connection & Channel
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel}    = AMQP.Channel.open(connection)

    # Declare Fanout Exchange
    AMQP.Exchange.declare(channel, @exchange, :fanout)

    {:ok, channel}
  end



  # Handle cast for :broadcast
  @doc false
  def handle_cast({:broadcast, event}, channel) do
    message = Event.encode!(event)

    # Broadcast on both Websocket and RabbitMQ
    Channels.TodoEvents.broadcast!(event)
    AMQP.Basic.publish(channel, @exchange, @routing, message)

    {:noreply, channel}
  end



  # Discard all info messages
  @doc false
  def handle_info(_message, state) do
    {:noreply, state}
  end


end
