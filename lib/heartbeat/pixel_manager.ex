defmodule Heartbeat.PixelManager do
  alias Heartbeat.Pixel
  use GenServer
  require Logger

  @moduledoc """
  This module controls the state of a single pixel
  """

  defmodule State do
    @moduledoc false
    defstruct [:rows, :columns, :all_coords, :matrix]
  end

  # Public API
  @doc """
  Start and link a GenServer.

  Parameters:
   * `rows` an integer representing the number of rows in matrix
   * `columns` an integer representing the number of columns in matrix
  """
  @spec start_link({integer, integer}) :: {:ok, pid}
  def start_link({rows, columns}),
    do: GenServer.start_link(__MODULE__, %{rows: rows, columns: columns}, name: __MODULE__)

  @doc """
  Prints out a copy of the matrix. Mostly for debugging.
  """
  @spec print_matrix() :: atom
  def print_matrix() do
    GenServer.call(__MODULE__, :show)
  end

  @doc """
  Returns the pixel pid at the provided coords

  Parameters:
   * `row` the integer "x coordinate" we will use to look up the pixel
   * `row` the integer "y coordinate" we will use to look up the pixel
  """
  @spec get_pixel(integer, integer) :: pid
  def get_pixel(row, column) do
    GenServer.call(__MODULE__, {:get_pixel, row, column})
  end

  @doc """
  Returns the first pixel that is not in the on state.
  Where first is defined as right-to-left then top-to-bottom.
  """
  @spec firstOffPixel() :: pid
  def firstOffPixel() do
    GenServer.call(__MODULE__, {:get_off_pixel})
  end

  def handle_call(:show, _from, state) do
    inspect(state.matrix)
    |> Logger.info()

    {:reply, :ok, state}
  end

  def handle_call({:get_pixel, row, column}, _from, state) do
    {:reply, state.matrix[row][column], state}
  end

  def handle_call({:get_off_pixel}, _from, state) do
    {row, column} = find_first(state.all_coords, state.matrix)

    {:reply, state.matrix[row][column], state}
  end

  defp find_first(coords, matrix) do
    Enum.find(coords, fn {r, c} -> !(matrix[r][c] |> Pixel.on?()) end)
  end

  def init(%{rows: rows, columns: columns}) do
    state = %State{
      rows: rows,
      columns: columns,
      all_coords: all_coords(rows, columns),
      matrix: gen_matrix(rows, columns)
    }

    {:ok, state}
  end

  defp all_coords(rows, columns) do
    Enum.flat_map(0..rows, fn x ->
      Enum.map(0..columns, fn y ->
        {x, y}
      end)
    end)
  end

  defp gen_matrix(rows, columns) do
    for row <- 0..rows, into: %{}, do: {row, gen_columns(row, columns)}
  end

  defp gen_columns(row, columns) do
    for column <- 0..columns, into: %{}, do: {column, Pixel.start_link({column, row}) |> elem(1)}
  end
end
