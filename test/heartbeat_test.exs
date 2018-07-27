defmodule HeartbeatTest do
  use ExUnit.Case
  doctest Heartbeat

  test "greets the world" do
    assert Heartbeat.hello() == :world
  end
end
