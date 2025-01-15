defmodule BckGammonApp.GameTest do
  use ExUnit.Case
  alias BckGammonApp.Board
  alias BckGammonApp.{Player, Feyga, FeygaPlayer, Strategy}
  # import ExUnit.CaptureIO

  test "play game" do
    player1 = Player.init(:black, :forward)
    player2 = Player.init(:yellow, :backward)
    game = Feyga.init_game(player1, player2, true)
    players = game.players


    Enum.reduce_while(1..5000, game, fn _, acc_game ->
      case Feyga.play_turn(acc_game, acc_game.active_player) do
        {:ok, updated_game} ->
          analysis = BckGammonApp.BoardAnalyzer.analyze_board(updated_game)
          # IO.puts(inspect(Board.print_board(updated_game.board)))
          updated_game.board |> dbg()
          # IO.puts(inspect(analysis))
          analysis |> dbg()
          if Enum.all?(analysis.state, fn %BckGammonApp.State{state: state} -> state == :collecting end) do
            {:halt, updated_game}  # Σταματάμε όταν όλοι οι παίκτες είναι στο collecting state
          else
            {:cont, updated_game}  # Συνεχίζουμε το παιχνίδι
          end

        {:error, reason} ->
          IO.puts("Error: #{inspect(reason)}")
          {:cont, acc_game}
      end
    end)
    # analyze_black = BckGammonApp.BoardAnalyzer.analyze_board(game)
    # analyze_black |> dbg()
    # 1..15
    # |> Enum.reduce(game, fn _, acc_game ->
    #   case Feyga.play_turn(acc_game, acc_game.active_player) do
    #     {:ok, updated_game} ->
    #       updated_game |> dbg()
    #       updated_game

    #     {:error, reason} ->
    #       IO.puts("Error: #{inspect(reason)}")
    #       acc_game
    #   end
    # end)



    # # Εκτέλεση 10 γύρων για κάθε παίκτη
    # 1..15
    # |> Enum.reduce(game, fn _, game ->
    #   {dice1, dice2} = Feyga.roll_dice()

    #   # Παίζει ο μαύρος παίκτης
    #   {:ok, game} = Feyga.move_checker(game, 1, dice1 + dice2, :black)
    #   analyze_black = BckGammonApp.BoardAnalyzer.analyze_board(game)

    #   IO.puts("Black state: #{inspect(analyze_black.state)}")
    #   # player1.roll()
    #   {dice1, dice2} = Feyga.roll_dice()

    #   # Παίζει ο κίτρινος παίκτης
    #   {:ok, game} = Feyga.move_checker(game, 24, 24 - (dice1 + dice2), :yellow)
    #   analyze_yellow = BckGammonApp.BoardAnalyzer.analyze_board(game)

    #   IO.puts("Yellow state: #{inspect(analyze_yellow.state)}")


    #   # Εκτύπωση του board μετά από κάθε γύρο
    #   Board.print_board(game.board)

    #   game
    # end)
  end

  # test "play game" do
  #   player1 = Player.init(:black, :forward)
  #   player2 = Player.init(:yellow, :backward)
  #   game = Feyga.init_game(player1, player2)

  #   {dice1, dice2} = Feyga.roll_dice()

  #   analyze = BckGammonApp.BoardAnalyzer.analyze_board(game)
  #   {:ok, game} = Feyga.move_checker(game, 1, dice1 + dice2, :black)
  #   analyze = BckGammonApp.BoardAnalyzer.analyze_board(game)

  #   {dice1, dice2} = Feyga.roll_dice()

  #   {:ok, game} = Feyga.move_checker(game, 24, 24 - (dice1 + dice2), :yellow)
  #   analyze = BckGammonApp.BoardAnalyzer.analyze_board(game)

  #   Board.print_board(game)
  #   #a = Strategy.determine_movements_score(game, player1, roll)
  #   #//aa = FeygaPlayer.play_turn(game, player1)
  #   # analyze = BckGammonApp.NewBoard.analyze_board(aa)
  #   #aa |> dbg()

  # end
end
