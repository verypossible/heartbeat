defmodule Heartbeat.Pixel do
  alias RpiRgbLedMatrex.Matrix
  use GenServer

  @moduledoc """
  This module controls the state of a single pixel
  """

  defmodule State do
    @moduledoc false
    defstruct [:coords, intensity: 0]
  end

  # Public API
  @doc """
  Start and link a GenServer.

  Parameters:
   * `coords` a tuple representing the `x` and `y` coordinates of the pixel
  """
  @spec start_link({integer, integer}) :: {:ok, pid}
  def start_link(coords), do: GenServer.start_link(__MODULE__, coords)

  @doc """
  Checks if the pixel is on.

  Parameters:
   * `pid`
  """
  @spec on?(pid) :: boolean
  def on?(pid), do: GenServer.call(pid, :on?)

  @doc """
  Turns the pixel on and then dims it out over ~5 seconds

  Parameters:
   * `pid`
  """
  @spec flash(pid) :: :ok
  def flash(pid), do: GenServer.cast(pid, :flash)

  # gen_server callbacks
  def init({x, y} = coords) do
    IO.inspect(x)
    IO.inspect(y)
    state = %State{coords: coords}
    {:ok, state}
  end

  def handle_call(:on?, _from, %{intensity: intensity} = state),
    do: {:reply, intensity != 0, state}

  def handle_cast(:flash, state) do
    {:noreply, %{state | intensity: 255}, {:continue, :flash}}
  end

  def handle_continue(:flash, state) do
    Kernel.send(self(), :dim)
    {:noreply, state}
  end

  def handle_info(:dim, %{intensity: intensity, coords: coords} = state) do
    IO.inspect(intensity)
    Matrix.set_pixel(Tuple.duplicate(intensity, 3), coords)
    {:noreply, %{state | intensity: dim(intensity)}}
  end

  defp dim(intensity) do
    dim_val = intensity - 1

    if dim_val > 0 do
      Process.send_after(self(), :dim, 10)
    end

    dim_val
  end
end
