defmodule FilesLabGraphql.Media.FileAgent do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  # Function to store the Plug.Upload struct temporarily
  def claim_file(agent_pid, upload) do
    Agent.update(agent_pid, fn state ->
      [upload | state] |> IO.inspect(label: "Tickle from far")
    end)
  end

  def get_state do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
