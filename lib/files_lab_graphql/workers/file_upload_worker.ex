defmodule FilesLabGraphql.Workers.FileUploadWorker do
  use Oban.Worker, max_attempts: 3, queue: :background
  alias FilesLabGraphqlWeb.Endpoint
  require Logger

  alias FilesLabGraphql.Media

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    with {:ok, temp_path} <- Map.fetch(args, "path"),
         {:ok, file_metadata} <- Map.fetch(args, "metadata") do
      # If both temp_path and file_metadata are successfully fetched
      Logger.info("Starting file process")
      process_file(temp_path, file_metadata)
      Logger.info("Finished file process")
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

    #simulate a process that might take a good amount to get done
    :timer.sleep( Enum.random(5000..9000))

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

    path = "/uploads/#{Path.basename(dest)}"

    Media.create_file(Map.merge(file_metadata, %{"path" => path}))
    |> case do
      {:ok, file} ->
        Absinthe.Subscription.publish(Endpoint, file, file_processed: "*")
    end
  end
end
