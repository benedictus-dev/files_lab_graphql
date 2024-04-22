defmodule FilesLabGraphql.Application do
  alias FilesLabGraphql.Media.FileAgent
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FilesLabGraphqlWeb.Telemetry,
      FilesLabGraphql.Repo,
      {Oban, Application.fetch_env!(:files_lab_graphql, Oban)},
      {DNSCluster, query: Application.get_env(:files_lab_graphql, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FilesLabGraphql.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FilesLabGraphql.Finch},
      {FileAgent,name: FileAgent},
      # Start a worker by calling: FilesLabGraphql.Worker.start_link(arg)
      # {FilesLabGraphql.Worker, arg},
      # Start to serve requests, typically the last entry
      FilesLabGraphqlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FilesLabGraphql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FilesLabGraphqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
