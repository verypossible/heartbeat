defmodule Heartbeat.Time do
  @moduledoc """
  A dev mock for Nerves.Time.
  """

  @behaviour Heartbeat.Dev.Time

  @impl Heartbeat.Dev.Time
  def synchronized?(), do: true
end
