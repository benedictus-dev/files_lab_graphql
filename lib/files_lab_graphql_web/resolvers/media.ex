defmodule FilesLabGraphqlWeb.Resolvers.Media do
  alias FilesLabGraphql.Workers.FileUploadWorker
  alias FilesLabGraphql.FileAgent
  alias FileNameGenerator

  def multi_file(_, %{files: files}, _) do
    files
    |> Enum.each(fn upload ->
      # Give away the file ownership to ensure it's not deleted
      Plug.Upload.give_away(upload, get_file_agent())
    end)

    response =
      files
      |> Enum.map(fn %Plug.Upload{filename: filename, path: path, content_type: content_type} ->
        %{
          "metadata" => %{filename: filename, content_type: content_type},
          "path" => path
        }
        |> FileUploadWorker.new()
        |> Oban.insert()
        |> case do
          {:ok, _job} ->
            filename

          {:error, _reason} ->
            "error"
        end
      end)

    {:ok, response}
  end

  defp get_file_agent() do
    Process.whereis(FileAgent)
  end
end
