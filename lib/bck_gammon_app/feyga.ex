defmodule BckGammonApp.Feyga do
  @behaviour BckGammonApp.Game

  alias BckGammonApp.{Feyga, Board, Dice, Player}

  defstruct [:board, :players, :active_player]

  def init_board() do
    Board.init_board()
  end

  def init_game do
    # Create players with their colors and starting positions
    player1 = %Player{color: :black, starting_position: 1}
    player2 = %Player{color: :yellow, starting_position: 24}

    init_game(player1, player2)
  end

  def init_game(player1, player2, active_player1 \\ true) do
    board =
      Board.init_board()
      |> Board.update_position(player1.starting_position, player1.color, 15)
      |> Board.update_position(player2.starting_position, player2.color, 15)

    set_active =
      if active_player1 do
        player1
      else
        player2
      end

    %BckGammonApp.Feyga{
      board: board,
      players: [player1, player2],
      active_player: set_active
    }
  end

  def move_checker(game, from_position, to_position, player) do
    case can_move_checker?(game.board, from_position, player.color) do
      true ->
        case can_place_checker?(game.board, to_position, player.color) do
          true ->
            updated_players =
              Enum.map(game.players, fn p ->
                if p.color == player.color do
                  %{
                    p
                    | rolls: player.rolls,
                      checkers_on_hand: player.checkers_on_hand,
                      state: player.state
                  }
                else
                  p
                end
              end)

            updated_game = %{
              board: Board.move_checker(game.board, from_position, to_position, player.color),
              players: updated_players,
              active_player: player
            }

            {:ok, updated_game}

          false ->
            {:error, "Checker cannot be placed at position #{to_position}.", game}
        end

      false ->
        {:error, "No checkers of color #{player.color} at position #{from_position} to move.",
         game}
    end
  end

  def roll_dice do
    {Dice.roll(), Dice.roll()}
  end

  def revoke_checker(board, position, color) do
    List.update_at(board, position - 1, fn %{index: idx, occupied: occupied} ->
      %{index: idx, occupied: List.delete(occupied, color)}
    end)
  end

  defp can_move_checker?(board, position, color) do
    case Enum.at(board, position - 1) do
      %{occupied: []} -> false
      %{occupied: [first | _]} when first == color -> true
      _ -> false
    end
  end

  defp can_place_checker?(board, position, color) do
    case Enum.at(board, position - 1) do
      %{occupied: []} -> true
      %{occupied: [first | _]} when first == color -> true
      _ -> false
    end
  end

  defp execute_move(game, roll, player) do
    analysis = BckGammonApp.BoardAnalyzer.analyze_board(game)

    # Φιλτράρουμε τις θέσεις που ανήκουν στον παίκτη
    positions =
      Enum.filter(analysis.consecutives, fn %{color: color, count: count} ->
        color == player.color and count > 0
      end)

    # Ταξινομούμε τις θέσεις με βάση την κατεύθυνση του παίκτη
    sorted_positions =
      case player.direction do
        :forward -> positions
        :backward -> Enum.reverse(positions)
      end

    Enum.reduce_while(sorted_positions, {:error, :no_available_move}, fn %{starting_position: from_position}, _acc ->
      to_position = move_to_position(from_position, roll, player)

      case play_turn(game, player, roll, [%{from_position: from_position, to_position: to_position}]) do
        {:ok, updated_game} -> {:halt, {:ok, updated_game}}
        {:error, _reason} -> {:cont, {:error, :no_available_move}}
      end
    end)
  end



  def play_turn(game, player) do
    play_turn(game, player, Dice.roll_multiple(2))
  end

  def play_turn(current_game, player, roll, positions) do
    player = Player.add_roll(player, roll)
    #    game |> dbg()
    updated_game =
      Enum.reduce_while(positions, current_game, fn %{from_position: from, to_position: to},
                                                    acc ->
        case move_checker(acc, from, to, player) do
          {:ok, updated_game} -> {:cont, updated_game}
          {:error, reason, _info} -> {:halt, {:error, reason}}
        end
      end)

    case updated_game do
      {:error, reason} ->
        # IO.puts("Move failed: #{inspect(reason)}")
        {:error, reason}

      game_state ->
        new_active_player = switch_active_player(game_state.active_player, game_state.players)
        updated_game_state = %{game_state | active_player: new_active_player}

        # updated_game_state |> dbg()
        {:ok, updated_game_state}
    end
  end

  def play_turn(game, player, [f, t]) do
    if Player.is_same_player?(game.active_player, player) do
      case execute_move(game, f, player) do
        {:ok, game_after_first_move} ->
          execute_move(game_after_first_move, t, player)

        {:error, :no_available_move} ->
          IO.puts("No available move for player #{player.color}")
          {:ok, game} # Τερματίζουμε τη σειρά χωρίς να κάνουμε άλλη κίνηση

        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, :not_players_turn}
    end
  end




  defp get_first_occupied_position(analysis, player) do
    direction = player.direction

    # Φιλτράρουμε τις θέσεις με βάση το χρώμα του παίκτη
    positions =
      Enum.filter(analysis.consecutives, fn %{color: color, count: count} ->
        color == player.color and count > 0
      end)

    case {direction, positions} do
      {:forward, [first | _]} -> first.starting_position
      {:backward, positions} when length(positions) > 0 -> List.last(positions).starting_position
      _ -> {:error, :no_available_checker}
    end
  end



  defp move_to_position(from_position, roll, %{direction: :forward}), do: from_position + roll
  defp move_to_position(from_position, roll, %{direction: :backward}), do: from_position - roll

  defp switch_active_player(current_player, players) do
    Enum.find(players, fn player -> player.color != current_player.color end)
  end
end
