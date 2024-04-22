defmodule FilesLabGraphql.Repo do
  use Ecto.Repo,
    otp_app: :files_lab_graphql,
    adapter: Ecto.Adapters.Postgres
end
