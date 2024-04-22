defmodule FilesLabGraphqlWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom
  import_types FilesLabGraphqlWeb.Schema.MediaType
  import_types FilesLabGraphqlWeb.Schema.AccountType
  alias FilesLabGraphqlWeb.Resolvers
  import_types Absinthe.Plug.Types

  query do
    # field :metadata,list_of(:file) do
    #   resolve &Resolvers.Media.list_files/3
    # end

    field :user, :user do
      # arg :id, non_null(:id)
      resolve &Resolvers.Account.find_user/3
    end
  end

  mutation do
    field :upload_files, list_of(:string) do
      arg :files, non_null(list_of(non_null(:upload)))
      resolve &Resolvers.Media.multi_file/3
    end
  end

end
