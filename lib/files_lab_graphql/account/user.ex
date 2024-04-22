defmodule FilesLabGraphql.Account.User do
  alias FilesLabGraphql.Media.File
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string

    has_many :files, File
    timestamps()
  end

  def changeset(%__MODULE__{}= user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_length(:username, min: 3, max: 20)
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/, message: "is not a valid email")
    |> unique_constraint(:email, message: "This email is already registered.")
  end
end
