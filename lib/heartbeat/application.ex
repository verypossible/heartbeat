defmodule Heartbeat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Heartbeat.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      RpiRgbLedMatrex.Matrix,
      {Heartbeat.PixelManager, {32, 32}},
      {Heartbeat.Slack.Launcher, []}
    ]
  end

  def children(_target) do
    [
      RpiRgbLedMatrex.Matrix,
      {Heartbeat.PixelManager, {32, 32}},
      {Heartbeat.Slack.Launcher, []}
    ]
  end
end
