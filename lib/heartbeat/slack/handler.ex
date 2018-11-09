defmodule Heartbeat.Slack.Handler do
  alias Heartbeat.{PixelManager, Pixel}
  use Slack
  require Logger

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, _slack, state) do
    inspect(message)
    |> Logger.info()

    PixelManager.firstOffPixel()
    |> Pixel.flash()

    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, _text, _channel}, _slack, state) do
    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
