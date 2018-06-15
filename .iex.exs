alias ZTD.{Todo, Todo.Config, Todo.Engine, Todo.Worker}
alias ZTD.{Web, Web.Channels.TodoEvents}
alias ZTD.Repo
alias Ecto.Query

require Query


request_queue    = Config.get(:amqp)[:request_queue]
request_exchange = Config.get(:amqp)[:request_exchange]
broadcast_exchange = Config.get(:amqp)[:broadcast_exchange]


engine_channel = fn ->
  {:ok, connection} = AMQP.Connection.open
  {:ok, channel}    = AMQP.Channel.open(connection)

  AMQP.Exchange.declare(channel, request_exchange, :direct)
  AMQP.Queue.declare(channel, request_queue, durable: false)
  AMQP.Queue.bind(channel, request_queue, request_exchange)

  channel
end

engine_publish = fn channel, message ->
  AMQP.Basic.publish(channel, request_exchange, request_queue, message)
end

