defmodule BckGammonApp.Board do
  def init_board() do
    Enum.map(1..24, fn idx ->
      %{index: idx, occupied: []}
    end)
  end

  def update_position(board, position, color, count) do
    List.update_at(board, position - 1, fn %{index: idx, occupied: occupied} ->
      %{index: idx, occupied: List.duplicate(color, count) ++ occupied}
    end)
  end

  def move_checker(board, from_position, to_position, color) do
    board = remove_checker(board, from_position, color)
    add_checker(board, to_position, color)
  end

  def remove_checker(board, position, color) do
    List.update_at(board, position - 1, fn %{index: idx, occupied: occupied} ->
      %{index: idx, occupied: List.delete(occupied, color)}
    end)
  end

  def add_checker(board, position, color) do
    List.update_at(board, position - 1, fn %{index: idx, occupied: occupied} ->
      %{index: idx, occupied: [color | occupied]}
    end)
  end

  def print_board(board) do
    Enum.each(board, fn %{index: idx, occupied: occupied} ->
      IO.puts("Position #{idx}: #{inspect(occupied)}")
    end)
  end

end
