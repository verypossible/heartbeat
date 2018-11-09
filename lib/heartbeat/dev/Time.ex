defmodule Heartbeat.Dev.Time do
  @moduledoc """
  The Time behavior interface.
  """
  @callback synchronized?() :: boolean
end
