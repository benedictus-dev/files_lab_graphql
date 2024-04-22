defmodule FilesLabGraphql.Media.Helpers do
  def extract_metada(%Plug.Upload{} = upload) do
    metadata = %{
      path: upload.path,
      content_type: upload.content_type,
      filename: upload.filename
    }
  end

  def handle_upload(file_data) do
     # copy files temp dir file to priv/static/uploads where they can be served
    # url path:/upload/abc-1.png need to be assigned to file locations
    # file_location =
    #   consum

    # would it make sense to return a list of url paths
    # # extension = Path.extname(upload.filenam)
    # dest = Path.join(["priv", "static", "uploads", "#{FileNameGenerator.generate()}"])
    # File.cp(upload.path, dest)
    # url_path = "/uploads/#{Path.basename(dest)}"
  end
end
