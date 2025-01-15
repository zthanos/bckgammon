defmodule BckGammonApp.GameTest do
  use ExUnit.Case
  alias BckGammonApp.Board
  alias BckGammonApp.{Player, Feyga, FeygaPlayer, Strategy}
  # import ExUnit.CaptureIO

  test "play game" do
    player1 = Player.init(:black, :forward)
    player2 = Player.init(:yellow, :backward)
    game = Feyga.init_game(player1, player2)
    players = game.players
    # analyze_black = BckGammonApp.BoardAnalyzer.analyze_board(game)
    # analyze_black |> dbg()
    p1_turn = Feyga.play_turn(game, player1)
    p1_turn |> dbg()
    # p1_turn = Feyga.play_turn(p1_turn, player2)
    # p1_turn |> dbg()
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
