defmodule BckGammonApp.Feyga do
  @behaviour BckGammonApp.Game

  alias BckGammonApp.{Board, Dice, Player}

  def init_board() do
    Board.init_board()
  end

  def init_game do
    # Create players with their colors and starting positions
    player1 = %Player{color: :black, starting_position: 1}
    player2 = %Player{color: :yellow, starting_position: 24}

    Board.init_board()
    |> Board.update_position(player1.starting_position, player1.color, 15)
    |> Board.update_position(player2.starting_position, player2.color, 15)
    |> IO.inspect(label: "Initial Board")
  end

  def move_checker(board, from_position, to_position, color) do
    case can_move_checker?(board, from_position, color) do
      true ->
        case can_place_checker?(board, to_position, color) do
          true -> {:ok, Board.move_checker(board, from_position, to_position, color)}
          false -> {:error, "Checker cannot be placed at position #{to_position}.", board}
        end
      false -> {:error, "No checkers of color #{color} at position #{from_position} to move.", board}
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
end
