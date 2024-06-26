defmodule FilesLabGraphql.Media.File do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(filename content_type path)a

  schema "files" do
    field :filename, :string
    field :content_type, :string
    field :path, :string
    timestamps()
  end

  def changeset(%__MODULE__{} = file, attrs \\ %{}) do
    file
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
