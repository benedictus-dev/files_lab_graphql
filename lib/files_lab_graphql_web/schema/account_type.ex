defmodule FilesLabGraphqlWeb.Schema.AccountType do
  use Absinthe.Schema.Notation

  @desc "A user of the file"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
  end
end
