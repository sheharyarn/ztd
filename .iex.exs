alias ZTD.{Todo, Todo.Config, Todo.Engine, Todo.Worker}
alias ZTD.Repo
alias Ecto.Query

require Query


engine_queue    = Config.get(:amqp)[:engine_queue]
engine_exchange = Config.get(:amqp)[:engine_exchange]
worker_exchange = Config.get(:amqp)[:worker_exchange]


