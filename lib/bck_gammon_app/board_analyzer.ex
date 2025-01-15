defmodule BckGammonApp.BoardAnalyzer do
  alias BckGammonApp.{State, Consecutive}

  def analyze_board(game) do
    {consecutives, totals} =
      Enum.reduce(game.board, {[], %{}}, fn %{index: idx, occupied: checkers}, {acc, totals} ->
        color = List.first(checkers)
        count = length(checkers)

        # Ενημέρωση των συνολικών πούλιων ανά χρώμα
        updated_totals = Map.update(totals, color, count, &(&1 + count))

        # Αν το χρώμα είναι το ίδιο με το active_color, ενημερώνουμε το τρέχον τμήμα
        case acc do
          [%{color: ^color, checkers_per_position: cpp} = last | rest] ->
            new_last = %{
              last
              | count: last.count + count,
                consecutive: last.consecutive + 1,
                checkers_per_position: cpp ++ [count]
            }

            {[new_last | rest], updated_totals}

          _ ->
            new_segment = %Consecutive{
              starting_position: idx,
              color: color,
              count: count,
              consecutive: 1,
              checkers_per_position: [count]
            }

            {[new_segment | acc], updated_totals}
        end
      end)

    consecutives = Enum.reverse(consecutives)
    player_states = determine_states(game.players, game.board)

    %{
      state: player_states,
      consecutives: consecutives
    }
  end

  defp determine_states(players, board) do
    Enum.map(players, fn player ->
      positions = Enum.filter(board, fn %{occupied: checkers} -> player.color in checkers end)

      {start_section, collecting_section} = get_player_sections(player.direction)

      state =
        cond do
          all_in_section?(positions, start_section) -> :start
          all_in_section?(positions, collecting_section) -> :collecting
          true -> :positioning
        end

      %BckGammonApp.State{color: player.color, state: state}
    end)
  end

  defp get_player_sections(:forward), do: {1, 4}
  defp get_player_sections(:backward), do: {4, 1}

  defp all_in_section?(positions, section) do
    section_range = BckGammonApp.Board.get_section_range(section)
    Enum.all?(positions, fn %{index: idx} -> idx in section_range end)
  end
end
