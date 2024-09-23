# defmodule BckGammon.OldBoard do
#   defstruct [
#     # A map to represent each board position and the checkers on it.
#     position: %{},
#     # Player 1's home checkers.
#     home_player1: [],
#     # Player 2's home checkers.
#     home_player2: [],
#     # Pieces sent to the bar (when hit).
#     bar: []
#   ]

#   def new() do
#     %__MODULE__{
#       position: initial_positions(),
#       home_player1: [],
#       home_player2: [],
#       bar: []
#     }
#   end

#   # Function to set up the initial backgammon positions
#   defp initial_positions do
#     # Initialize the board's positions based on backgammon rules
#     %{
#       # Player 1 starts with 2 checkers on position 1
#       1 => {:player1, 15},
#       # Player 2 starts with 5 checkers on position 6
#       24 => {:player2, 15},
#     }
#   end

#   # Function to display the board as ASCII art
#   def display_board(_board) do
#     IO.puts "╔═════════════════════════════════════════════════════════╗"
#     IO.puts "║  ())))))))))))))          ║             (((((((((((((() ║"
#     IO.puts "╠═══════════════════════════╬═════════════════════════════╣"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "╠═══════════════════════════╬═════════════════════════════╣"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "║                           ║                             ║"
#     IO.puts "╚═══════════════════════════╩═════════════════════════════╝"

#     # IO.puts "+-------------------------------------------------------+"
#     # IO.puts "| 12  11  10   9   8   7   |   6   5   4   3   2   1    |"
#     # IO.puts render_row(board, 12..7) <> " | " <> render_row(board, 6..1)
#     # IO.puts "|                         |                            |"
#     # IO.puts "|-------------------------|----------------------------|"
#     # IO.puts "|                         |                            |"
#     # IO.puts render_row(board, 13..18) <> " | " <> render_row(board, 19..24)
#     # IO.puts "| 13  14  15  16  17  18   |  19  20  21  22  23  24    |"
#     # IO.puts "+-------------------------------------------------------+"
#   end

#   # Helper function to render the row of positions
#   defp render_row(board, range) do
#     range
#     |> Enum.map(fn pos -> render_position(board, pos) end)
#     |> Enum.join(" ")
#   end

#   # Helper function to render a single position on the board
#   defp render_position(%{position: positions}, pos) do
#     case Map.get(positions, pos) do
#       {:player1, count} -> String.duplicate("O", min(count, 5)) |> pad_checker_display()
#       {:player2, count} -> String.duplicate("X", min(count, 5)) |> pad_checker_display()
#       # Empty position
#       _ -> "   "
#     end
#   end

#   # Pads the checker display to always be 3 characters wide
#   defp pad_checker_display(checkers) do
#     String.pad_trailing(checkers, 3)
#   end
# end


# defmodule BckGammon.Position_old do
#   defstruct ~w(index, checker_id)a
# end

# defmodule BckGammon.Checker do
#   defstruct ~w(player, checker_id position)a
# end



# # defmodule BckGammon.Board do
# #   alias BckGammon.Player

# #   defstruct [
# #     :player1,
# #     :player2,
# #     :positions
# #   ]

# #   def init_player(player, positioning) do
# #     pos = case positioning do
# #       :start -> 1
# #       :end -> 13
# #     end

# #     # Create 15 checkers, all starting at the same position
# #     checkers =
# #       Enum.map(1..15, fn idx ->
# #         %{player: player, checker_id: idx, position: pos}
# #       end)

# #     %Player{positioning: positioning, checkers: checkers}
# #   end

# #   def init_board() do
# #     positions = []

# #     player1 = init_player(:player1, :start)
# #     player2 = init_player(:player2, :end)

# #     positions = place_checkers(positions, player1.checkers)
# #     positions = place_checkers(positions, player2.checkers)

# #     %BckGammon.Board{
# #       player1: player1,
# #       player2: player2,
# #       positions: positions
# #     }
# #   end

# #   def move_checker(:start, position, move_by) do
# #     target_position = position + move_by
# #     case target_position do
# #      24 -> {:error, :out_of_bounds}

# #     end

# #   end

# #   def can_place(board, player, position) do
# #     valid  = position >= 1 and position <= 24
# #   end

# #   def move_checker(:end, position, move_by) do

# #   end

# #   defp place_checkers(positions, checkers) do
# #     Enum.reduce(checkers, positions, fn checker, acc_positions ->
# #       List.update_at(acc_positions, checker.position - 1, fn checkers_at_pos ->
# #         [checker | checkers_at_pos]
# #       end)
# #     end)
# #   end
# # end
