defmodule ZTD.Todo.Worker.Broadcaster do
  use GenServer

  alias ZTD.Todo.Event
  alias ZTD.Todo.Config

  @moduledoc """
  Keeps a RabbitMQ connection open to the engine. Sends
  todo events to the engine where it is responsible for
  persisting it and broadcasting the event to all
  connected workers (including self). This acts as an
  acknowledgement and the state is updated.
  """


  @queue    Config.get(:amqp)[:engine_queue]
  @exchange Config.get(:amqp)[:engine_exchange]





  ## Public API
  ## ----------


  @doc "Open the connection"
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end


  @doc "Send event to Engine"
  def send!(%Event{} = event) do
    GenServer.cast(__MODULE__, {:send, event})
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
    AMQP.Queue.bind(channel, @queue, @exchange)

    {:ok, channel}
  end



  # Handle cast for :send!
  @doc false
  def handle_cast({:send, event}, channel) do
    message = Event.encode!(event)
    :ok = AMQP.Basic.publish(channel, @exchange, @queue, message)

    {:noreply, channel}
  end



  # Discard all info messages
  @doc false
  def handle_info(_message, state) do
    {:noreply, state}
  end


end
