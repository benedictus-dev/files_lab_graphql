defmodule FilesLabGraphqlWeb.Schema.AccountType do
  use Absinthe.Schema.Notation
  alias FilesLabGraphqlWeb.Resolvers
  @desc "A user of the file"


  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    # field :metadata, list_of(:file) do
    #   resolve &Resolvers.Media.list_files/3
    # end
  end
end
