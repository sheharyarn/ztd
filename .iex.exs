alias ZTD.{Todo, Todo.Config, Todo.Engine, Todo.Worker}
alias ZTD.{Web, Web.Channels.TodoEvents}
alias ZTD.Repo
alias Ecto.Query

require Query


engine_queue    = Config.get(:amqp)[:engine_queue]
engine_exchange = Config.get(:amqp)[:engine_exchange]
worker_exchange = Config.get(:amqp)[:worker_exchange]


engine_channel = fn ->
  {:ok, connection} = AMQP.Connection.open
  {:ok, channel}    = AMQP.Channel.open(connection)

  AMQP.Exchange.declare(channel, engine_exchange, :direct)
  AMQP.Queue.declare(channel, engine_queue, durable: false)
  AMQP.Queue.bind(channel, engine_queue, engine_exchange)

  channel
end

engine_publish = fn channel, message ->
  AMQP.Basic.publish(channel, engine_exchange, engine_queue, message)
end

