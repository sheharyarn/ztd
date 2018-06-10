defmodule ZTD.Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todo_items" do
    field :title, :string
    field :done, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :done])
    |> validate_required([:title, :done])
  end
end
