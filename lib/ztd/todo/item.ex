defmodule ZTD.Todo.Item do
  use ZTD.Repo.Schema



  ## Schema
  ## ------

  @fields_required [:title]
  @fields_optional [:done]
  @fields_all (@fields_optional ++ @fields_required)


  schema "todo_items" do
    field :title, :string
    field :done,  :boolean, default: false

    timestamps()
  end




  ## Public API
  ## ----------


  @doc "Create Changeset"
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @fields_all)
    |> validate_required(@fields_required)
  end

end
