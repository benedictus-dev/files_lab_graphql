defmodule FilesLabGraphql.Workers.FileUploadWorker do
  use Oban.Worker, max_attempts: 3, queue: :background
  require Logger

  alias FilesLabGraphql.Media.File, as: Media

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    with {:ok, temp_path} <- Map.fetch(args, "path"),
         {:ok, file_metadata} <- Map.fetch(args, "metadata") do
      # If both temp_path and file_metadata are successfully fetched
      Logger.info("Starting execution")
      process_file(temp_path, file_metadata)
      Logger.info("Finished execution")
      :ok
    else
      :error ->
        # Log an error and return an error tuple if any fetch fails
        Logger.error("Missing necessary arguments in job")
        {:error, :invalid_arguments}
    end
  end

  defp process_file(temp_path, file_metadata) do
    # copy files temp dir file to priv/static/uploads where they can be served
    :timer.sleep(50000)

    dest =
      Path.join([
        "priv",
        "static",
        "uploads",
        "#{Ecto.UUID.generate()}-#{file_metadata["filename"]}"
      ])

    File.cp(temp_path, dest)

    # Cleanup file after processing
    File.rm(temp_path)

    path = "/uploads/#{Path.basename(dest)}" |> IO.inspect(label: "URl path")

    Media.changeset(%Media{}, Map.merge(file_metadata, %{"path" => path}))
    |> IO.inspect(label: "Checking Changeset")
  end
end
