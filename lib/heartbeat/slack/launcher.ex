defmodule Heartbeat.Slack.Launcher do
  use GenServer

  @moduledoc """
  This module starts a slack bot RTM process
  """

  @spec start_link([term]) :: {:ok, pid}
  def start_link(opts) do
    opts = Keyword.merge([name: __MODULE__], opts)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @spec init(any) :: {:ok, %{rtm_bot_pid: pid}}
  def init(_) do
    update_time()

    {:ok, pid} =
      Slack.Bot.start_link(
        Heartbeat.Slack.Handler,
        [],
        Application.get_env(:heartbeat, :slack_token)
      )

    {:ok, %{rtm_bot_pid: pid}}
  end

  @spec update_time() :: nil
  defp update_time do
    if !Nerves.Time.synchronized?() do
      Process.sleep(1000)
      update_time()
    end
  end
end
