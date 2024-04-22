defmodule FilesLabGraphqlWeb.Resolvers.Media do
  alias FilesLabGraphql.Media.Workers.FileUploadWorker
  alias FilesLabGraphql.Media.FileAgent
  alias FileNameGenerator

  def multi_file(_, %{files: files}, _) do
    files
    |> Enum.each(fn upload ->
      # Give away the file ownership to ensure it's not deleted
      Plug.Upload.give_away(upload, get_file_agent())
    end)

    files
    |> Enum.each(fn %Plug.Upload{filename: filename, path: path, content_type: content_type} ->
      %{
        "metadata" => %{filename: filename, content_type: content_type},
        "path" => path
      }
      |> FileUploadWorker.new()
      |> Oban.insert()
    end)
    

    # # IO.inspect(files, label: "Streams")
    {:ok, ["", ""]}
  end

  defp get_file_agent() do
    case Process.whereis(FileAgent) do
      nil ->
        {:ok, pid} = FileAgent.start_link([])
        pid

      pid ->
        pid
    end
  end
end
