defmodule ZTD.Todo.Item do
  use ZTD.Repo.Schema


  schema "todo_items" do
    field :title, :string
    field :done,  :boolean, default: false

    timestamps()
  end


  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :done])
    |> validate_required([:title, :done])
  end
end
