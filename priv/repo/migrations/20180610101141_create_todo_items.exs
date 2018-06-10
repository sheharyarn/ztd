defmodule ZTD.Repo.Migrations.CreateTodoItems do
  use Ecto.Migration

  def change do
    create table(:todo_items, primary_key: false) do
      add :id,      :binary_id, primary_key: true
      add :title,   :string,    null: false
      add :done,    :boolean,   null: false, default: false

      timestamps()
    end
  end

end
