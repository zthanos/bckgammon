defmodule BckGammonApp.FeygaPlayer do
  alias BckGammonApp.Board
  alias BckGammonApp.{Player, Feyga}

  def play_turn(board, player) do
    roll = Feyga.roll_dice()
    # state = Player.get_state(player) |> dbg()

    play(board, player.state, player, roll)
  end

  defp play(board, :moving, player, roll) do
    a = Board.board_to_matrix(board, :black, :yellow)
    strategy = BckGammonApp.Strategy.determine_strategy(board, player.color)
    IO.inspect(a)
    case strategy do
      {:try_fill_second_stage, analysis} -> occupy_last_empty(analysis, 1, roll, player.color)
      :break_opponent_block -> occupy_first_empty(board, 2, roll, player.color)
      _ -> strategy
    end
  end

  defp occupy_last_empty(strategy, _positions, _roll, _player_color) do
    # candidate_positions =
    #   Enum.filter(positions, fn %{count: count, color: color} ->
    #     color == player_color and count > 2 and section_of_position(from_section, positions)
    #   end)

    # Enum.map(candidate_positions, fn %{index: from_index} ->
    #   to_index = from_index + roll
    #   target_position = find_position_by_index(positions, to_index)

    #   case target_position do
    #     nil ->
    #       {:error, :invalid_target_position}

    #     %{count: _} ->
    #       move_result = perform_move(positions, from_index, to_index, player_color)
    #       move_result
    #   end
    # end)

    IO.inspect(strategy)
    IO.puts("Here we go")
    {:ok}
  end

  def find_position_by_index(positions, index) do
    Enum.find(positions, fn %{index: idx} -> idx == index end)
  end


  def perform_move(positions, from_index, to_index) do
    updated_positions =
      Enum.map(positions, fn
        %{index: ^from_index, count: count} = pos ->
          %{pos | count: count - 1}

        %{index: ^to_index, count: count} = pos ->
          %{pos | count: count + 1}

        pos ->
          pos
      end)

    {:ok, updated_positions}
  end

  defp occupy_first_empty(_board, _section, _roll, _player_color) do
    {:ok}
  end

  # defp play(_board, :revoking, _player, _roll) do
  #   {:ok}
  # end

  # defp play(_board, :win, _player, _roll) do
  #   {:ok}

  # end
end

#   alias BckGammonApp.Feyga
#   alias BckGammonApp.Board
#   alias BckGammonApp.Player
#   alias BckGammonApp.Dice

#   # Play a turn by rolling the dice and deciding on the best move
#   def play_turn(board, player_color) do
#     {die1, die2} = roll_dice()

#     # Check if the player has won
#     if player_won?(board, player_color) do
#       {:win, board}
#     else
#       # Check if all checkers are in Part 4
#       if in_revoke_phase?(board, player_color) do
#         # Revoke checkers since all checkers are in Part 4
#         board =
#           case try_revoke_checker(board, player_color, die1) do
#             {:ok, updated_board} -> updated_board
#             {:error, _reason, board} -> board
#           end

#         board =
#           case try_revoke_checker(board, player_color, die2) do
#             {:ok, updated_board} -> updated_board
#             {:error, _reason, board} -> board
#           end

#         # After revoking, check if the player has won
#         if player_won?(board, player_color) do
#           {:win, board}
#         else
#           {:ok, board}
#         end
#       else
#         # Normal move phase, focusing on strategic movement and blocking
#         board =
#           case decide_move(board, player_color, die1) do
#             {:ok, updated_board} -> updated_board
#             {:error, _reason, board} -> board
#           end

#         board =
#           case decide_move(board, player_color, die2) do
#             {:ok, updated_board} -> updated_board
#             {:error, _reason, board} -> board
#           end

#         {:ok, board}
#       end
#     end
#   end

#   # Roll the dice
#   defp roll_dice do
#     {Dice.roll(), Dice.roll()}
#   end

#   # Check if all player's checkers are in Part 4 (positions 19-24)
#   defp in_revoke_phase?(board, player_color) do
#     player_positions = get_player_positions(board, player_color, 1)  # Get all player's positions
#     Enum.all?(player_positions, fn pos -> pos >= 19 and pos <= 24 end)  # All in Part 4
#   end

#   # Attempt to revoke a checker if all are in Part 4
#   defp try_revoke_checker(board, player_color, die) do
#     player_positions = get_player_positions(board, player_color, 1)

#     # First, try to revoke based on exact die rolls
#     case Enum.find(player_positions, fn pos -> pos == 25 - die end) do
#       nil ->
#         # If no exact match, find the closest checker to position 19
#         closest_position =
#           Enum.min_by(player_positions, fn pos -> pos end, fn -> nil end)

#         if closest_position != nil and die >= 25 - closest_position do
#           case Feyga.revoke_checker(board, closest_position, player_color) do
#             {:ok, updated_board} -> {:ok, updated_board}
#             {:error, _reason, board} -> {:error, "Cannot revoke", board}
#           end
#         else
#           {:error, "No checkers can be revoked with die roll #{die}", board}
#         end

#       exact_position ->
#         case Feyga.revoke_checker(board, exact_position, player_color) do
#           {:ok, updated_board} -> {:ok, updated_board}
#           {:error, _reason, board} -> {:error, "Cannot revoke", board}
#         end
#     end
#   end

#   # Check if the player has revoked all checkers
#   defp player_won?(board, player_color) do
#     player_positions = get_player_positions(board, player_color, 1)
#     Enum.empty?(player_positions)  # Player wins if they have no more checkers
#   end

#   # Function to get positions occupied by the player's checkers
#   defp get_player_positions(board, player_color, direction) do
#     positions =
#       Enum.filter(board, fn %{occupied: checkers} ->
#         Enum.any?(checkers, fn checker -> checker == player_color end)
#       end)
#       |> Enum.map(fn %{index: index} -> index end)

#     if direction == 1 do
#       Enum.sort(positions)
#     else
#       Enum.sort(positions, :desc)
#     end
#   end

#   # Determines the direction of movement for a player
#   defp get_player_direction(:black), do: 1  # Black moves forward (ascending)
#   defp get_player_direction(:yellow), do: -1  # Yellow moves backward (descending)
# end
