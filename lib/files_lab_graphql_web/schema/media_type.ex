defmodule FilesLabGraphqlWeb.Schema.MediaType do
  use Absinthe.Schema.Notation

  object :file do
    field :id, :id
    field :filename, :string
    # field :filetype, :string
    # field :filesize, :integer
    field :url, :string
    # field :status, :string
    # field that points back to our :user type
    # field :creator, :user
  end

end
