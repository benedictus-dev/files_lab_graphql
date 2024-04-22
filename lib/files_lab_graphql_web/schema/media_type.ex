defmodule FilesLabGraphqlWeb.Schema.MediaType do
  use Absinthe.Schema.Notation

  object :file do
    field :filename, :string
    field :content_type, :string
    field :path, :string
  end
end
