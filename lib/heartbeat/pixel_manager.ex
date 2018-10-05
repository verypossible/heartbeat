defmodule Heartbeat.PixelManager do
  alias Heartbeat.Pixel
  use GenServer

  @moduledoc """
  This module controls the state of a single pixel
  """

  defmodule State do
    @moduledoc false
    defstruct [:rows, :columns, :matrix]
  end

  # Public API
  @doc """
  Start and link a GenServer.

  Parameters:
   * `rows` an integer representing number of rows in matrix
   * `columns` an integer representing number of columns in matrix
  """
  @spec start_link(integer, integer) :: {:ok, pid}
  def start_link(rows, columns),
    do: GenServer.start_link(__MODULE__, %{rows: rows, columns: columns})

  def print_matrix(pid) do
    GenServer.call(pid, :show)
  end

  def get_pixel(pid, row, column) do
    GenServer.call(pid, {:get_pixel, row, column})
  end

  def handle_call(:show, _from, state) do
    IO.inspect(state.matrix)
    {:noreply, state}
  end

  def handle_call({:get_pixel, row, column}, _from, state) do
    {:reply, state.matrix[row][column], state}
  end

  def init(%{rows: rows, columns: columns}) do
    state = %State{rows: rows, columns: columns, matrix: gen_matrix(rows, columns)}
    {:ok, state}
  end

  defp gen_matrix(rows, columns) do
    for row <- 0..rows, into: %{}, do: {row, gen_columns(row, columns)}
  end

  defp gen_columns(row, columns) do
    for column <- 0..columns, into: %{}, do: {column, Pixel.start_link({column, row}) |> elem(1)}
  end
end
