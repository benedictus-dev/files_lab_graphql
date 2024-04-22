defmodule FilesLabGraphql.Media.Workers.FileUploadWorker do
  use Oban.Worker, max_attempts: 3, queue: :background
  require Logger

  alias FilesLabGraphql.Media.File, as: Media
  # create a worker to process it file
  # move from temp to static
  # persist file
  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do

    Logger.info("Starting execution")

    temp_path = args["path"]
    file_metadata = args["metadata"]

    process_file(temp_path, file_metadata)

    Logger.info("Finished execution")
    :ok
  end

  defp process_file(temp_path, file_metadata) do
    # copy files temp dir file to priv/static/uploads where they can be served
    # would it make sense to return a list of url paths
    :timer.sleep(50000)

    dest =
      Path.join([
        "priv",
        "static",
        "uploads",
        "#{Ecto.UUID.generate()}-#{file_metadata["filename"]}"
      ])

    File.cp(temp_path, dest)
    |> IO.inspect(label: "Rate")

    # Cleanup file after processing
    File.rm(temp_path) |> IO.inspect(label: "File removal")

    path = "/uploads/#{Path.basename(dest)}" |> IO.inspect(label: "URl path")

    Media.changeset(%Media{}, Map.merge(file_metadata, %{"path" => path}))
    |> IO.inspect(label: "Checking Changeset")
  end
end
