defmodule ZTD.Todo.Worker.RPC do
  alias ZTD.Todo.Config


  @moduledoc """
  RPC Client interface to the engine. Sends rpc
  requests via RabbitMQ to the engine and waits
  for their response on an exclusive queue.

  NOTE:
  Highly inefficient over the network because it
  blocks until it receives response. Consider
  implementing a truly distributed version (but
  it would require each worker to have own
  state).

  Maybe also keep the connection/channel open.
  """


  @request_queue    Config.get(:amqp)[:engine_queue]
  @request_exchange Config.get(:amqp)[:engine_exchange]
  @timeout          2_000





  ## Public API
  ## ----------

  def all do
    rpc_request!("all")
  end





  ## Private Helpers
  ## ---------------


  # Generate a random correlation id
  defp generate_id do
    :erlang.unique_integer
    |> :erlang.integer_to_binary
    |> Base.encode64
  end


  # Open a Connection
  defp open_connection do
    {:ok, connection}      = AMQP.Connection.open
    {:ok, channel}         = AMQP.Channel.open(connection)
    {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)

    {connection, channel, queue}
  end


  # Perform an RPC Request
  defp rpc_request!(command) do
    id = generate_id()
    conn = {_, channel, queue} = open_connection()

    AMQP.Basic.consume(channel, queue, nil, no_ack: true)
    AMQP.Basic.publish(
      channel,
      @request_exchange,
      @request_queue,
      command,
      type: "rpc",
      reply_to: queue,
      correlation_id: id
    )

    wait_for_response(conn, id)
  end


  # Block until receive RPC response with matching id
  defp wait_for_response(conn, id) do
    receive do
      {:basic_deliver, payload, %{correlation_id: ^id}} ->
        Poison.decode!(payload)
    after
      @timeout -> raise "RPC Call Timed out"
    end
  end


end

