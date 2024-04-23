defmodule FilesLabGraphqlWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom
  import_types FilesLabGraphqlWeb.Schema.MediaType
  import_types FilesLabGraphqlWeb.Schema.AccountType
  alias FilesLabGraphqlWeb.Resolvers
  import_types Absinthe.Plug.Types

  query do
    field :user, :user do
    end
  end

  mutation do
    @desc "Uploads multiple files and queues them."
    field :upload_files, list_of(:string) do
      arg :files, non_null(list_of(non_null(:upload)))
      resolve &Resolvers.Media.multi_file/3
    end
  end

  subscription do
    @desc "Subscribes to updates on file."
    field :file_processed, :file do
      config(fn _args, _ ->
        {:ok, topic: "*"}
      end)
    end
  end
end
