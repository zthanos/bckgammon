defmodule BckGammonApp.Board do
  alias BckGammonApp.Board

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

  def count_checkers(board, color) do
    sections = Board.get_sections(board)

    a = Enum.map(sections, fn section ->
      Enum.reduce(section, 0, fn %{occupied: checkers}, acc ->
        acc + Enum.count(checkers, fn checker -> checker == color end)


      end)
    end)
    IO.inspect(a)
  end

  def get_max_section(distribution) do
    Enum.with_index(distribution)
    |> Enum.max_by(fn {count, _index} -> count end)
    |> elem(1)
  end

  def get_opponents_color(board, player_color) do
    used_colors =
      board
      |> Enum.flat_map(fn %{occupied: checkers} -> checkers end)
      |> Enum.uniq()

    Enum.find(used_colors, fn color -> color != player_color end)
  end

  def add_checker(board, position, color) do
    List.update_at(board, position - 1, fn %{index: idx, occupied: occupied} ->
      %{index: idx, occupied: [color | occupied]}
    end)
  end

  def get_sections(board), do: Enum.chunk_every(board, 6)

  def get_section_range(section) do
    case section do
      1 -> 1..6
      2 -> 7..12
      3 -> 13..18
      4 -> 19..24
    end
  end

  def analyze_board(board) do
    positions_by_volume =
      board
      |> Enum.reduce([], fn %{index: idx, occupied: checkers}, acc ->
        row = %{index: idx, color: List.first(checkers), count: length(checkers)}
        [row | acc]
      end)

    consecutive_positions = find_consecutive_positions(positions_by_volume)

    %{positions_by_volume: positions_by_volume, consecutive_positions: consecutive_positions}
  end

  def get_consecutive_ranges(board) do
    positions_by_color =
      Enum.reduce(board, %{}, fn %{index: idx, occupied: checkers}, acc ->
        Enum.reduce(checkers, acc, fn color, color_acc ->
          Map.update(color_acc, color, [idx], fn pos_list -> [idx | pos_list] end)
        end)
      end)

    Enum.map(positions_by_color, fn {color, positions} ->
      {color, find_consecutive_ranges(Enum.sort(positions))}
    end)
  end

  defp find_consecutive_positions(analyzed) do
    # Group positions by color
    grouped_by_color = Enum.group_by(analyzed, fn %{color: color} -> color end)

    # For each color, find the consecutive positions
    Enum.map(grouped_by_color, fn {color, positions} ->
      # Extract only the indexes of positions and sort them
      position_indexes = Enum.map(positions, & &1.index) |> Enum.sort()

      # Find consecutive ranges
      ranges = find_consecutive_ranges(position_indexes)
      {color, ranges}
    end)
  end

  # Helper to find consecutive ranges in a list of sorted positions
  defp find_consecutive_ranges(positions) do
    positions
    |> Enum.chunk_while(
      [],
      fn x, acc ->
        case acc do
          [] -> {:cont, [x]}
          # Continue the range
          [h | _] = list when x == h + 1 -> {:cont, [x | list]}
          # Start a new range
          list -> {:cont, Enum.reverse(list), [x]}
        end
      end,
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
    # Ensure ranges are in the correct order
    |> Enum.map(&Enum.reverse/1)
  end

  def board_to_matrix(positions, color1, color2) do
    positions
    |> Enum.chunk_every(6)
    |> Enum.with_index(1)
    |> Enum.map(fn {section_positions, section_no} ->
      {color1_total, color2_total} = calculate_section_totals(section_positions, color1, color2)

      %{
        section_no: section_no,
        color1_total: color1_total,
        color2_total: color2_total,
        positions: section_positions
      }
    end)
  end

  defp calculate_color_totals(positions, color) do
    a =
    Enum.map(positions, fn section ->
      Enum.reduce(section, 0, fn %{occupied: checkers}, acc ->
        # Προσθέτουμε τον αριθμό των "checkers" του χρώματος "color" στον συσσωρευτή (acc)
        acc + Enum.count(checkers, fn checker -> checker == color end)
      end)
    end)
    IO.inspect(a)
    # Enum.reduce(positions, 0, fn x, acc ->
    #   [h | _] = x.occupied
    #   a = {h, length(x.occupied)}
    #   [_, remaining] = Enum.to_list(positions)
    #   ^acc = remaining
    # end)


    # Enum.reduce_while(positions, fn x, acc ->
    #   a = x
    #   if Enum.any?(a.occupied == :black, do:
    #     ^acc = acc + length(x.checkers)
    #   else
    #      {:halt, acc}
    #   end

    # end)
  end

  defp calculate_section_totals(section_posititions, color1, color2) do
    aa = count_checkers(section_posititions, :yellow)
    {5, 15}
    # color2_total = Enum.reduce(section_posititions, {0, 0}, fn %{color: color, count: count} ->
    #   case color do
    #     ^color1 -> {color1_total + count, color2_total}
    #     ^color2 -> {color1_total, color2_total + count}
    #     _ -> {color1_total, color2_total}
    #   end
    # end)
  end

  def print_board(board) do
    Enum.each(board, fn %{index: idx, occupied: occupied} ->
      IO.puts("Position #{idx}: #{inspect(occupied)}")
    end)
  end
end
