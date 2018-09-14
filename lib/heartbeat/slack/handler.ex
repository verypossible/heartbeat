defmodule Heartbeat.Slack.Handler do
  alias RpiRgbLedMatrex.Matrix
  use Slack

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    IO.inspect(message)
    Matrix.fill({255, 255, 255})
    Process.sleep(1000)
    Matrix.clear()
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")
    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
