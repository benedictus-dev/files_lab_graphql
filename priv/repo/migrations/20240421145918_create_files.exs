defmodule FilesLabGraphql.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :filename, :string
      add :content_type, :string
      add :path, :string

      timestamps()
    end
  end
end
