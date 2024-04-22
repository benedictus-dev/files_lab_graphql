defmodule FilesLabGraphqlWeb.Resolvers.Media do
  alias FilesLabGraphql.Media.Workers.FileUploadWorker
  alias FilesLabGraphql.Media.FileAgent
  alias FileNameGenerator

  def multi_file(_, %{files: files}, _) do
    #Prevent {:error, {:already_started, #PID<x.x.x>}}
    {:ok, agent_pid} = FileAgent.start_link([])

    files
    |> Enum.each(fn upload ->
      # Then give away the file ownership to ensure it's not deleted
      Plug.Upload.give_away(upload, agent_pid)
    end)

    # FileAgent.get_state() |> IO.inspect(label: "Agent state")
    files
    |> Enum.each(fn %Plug.Upload{filename: filename, path: path, content_type: content_type} ->
      %{
        "metadata" => %{filename: filename, content_type: content_type},
        "path" => path
      }
      |> FileUploadWorker.new()
      |> Oban.insert()
    end)
    |> IO.inspect(label: "Response From Scheduling ")

    # IO.inspect(files, label: "Streams")
    {:ok, ["", ""]}
  end
end
