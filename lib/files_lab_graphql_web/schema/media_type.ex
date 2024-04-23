defmodule FilesLabGraphqlWeb.Schema.MediaType do
  use Absinthe.Schema.Notation

  @desc "Represents details about a file object."
  object :file do
    @desc "The name of the file as stored on the server."
    field :filename, :string

    @desc "The MIME type of the file, determining the file format."
    field :content_type, :string

    @desc "The path where the file is stored within the server's filesystem."
    field :path, :string
  end
end
