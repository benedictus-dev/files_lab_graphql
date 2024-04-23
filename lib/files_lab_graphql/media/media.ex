defmodule FilesLabGraphql.Media do
  alias FilesLabGraphql.Media.File
  alias FilesLabGraphql.Repo

  def list_files do
    Repo.all(File)
  end

  def get_file!(id), do: Repo.get!(File, id)

  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  def change_file(%File{} = file) do
    File.changeset(file, %{})
  end
end
