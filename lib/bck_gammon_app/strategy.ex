defmodule BckGammonApp.Strategy do
  alias BckGammonApp.Board

  defstruct [
    :board_analysis,
    :board,
    :opponent_color,
    :player_color,
    :player_distribution,
    :opponent_distribution
  ]

  def board_analysis(board, player_color) do
    opponent_color = Board.get_opponents_color(board, player_color)
    board_analysis = Board.analyze_board(board)
    player_distribution = Board.count_checkers(board, player_color)
    opponent_distribution = Board.count_checkers(board, opponent_color)
    %BckGammonApp.Strategy{
      board: board,
      player_color: player_color,
      board_analysis: board_analysis,
      opponent_color: opponent_color,
      player_distribution: player_distribution,
      opponent_distribution: opponent_distribution
    }
  end



  def determine_strategy(board, player) do
    analysis = board_analysis(board, player)
    BckGammonApp.Helpers.max_position(analysis.player_distribution)
    stage =
      case BckGammonApp.Helpers.max_position(analysis.player_distribution)  do
        0 -> :early_stage
        1 -> :mid_stage
        2 -> :mid_stage
        _ -> :final_stage
      end

    determine_stage_strategy(analysis, stage)
  end

  def determine_movements_score(positions, player, roll) do
    # calculate posible moves for each checker and determine scores
    # both for each roll, and for roll as summary
    # returns possible
    IO.inspect(positions)
    player_distribution = Board.count_checkers(positions, player.color)
    IO.inspect(player_distribution)
  end

  def calculate_movement_score(positions, index, rolls) do

    # If the ending position is available 1
    # If starting position has more than one checker 2 is added to weight
    # if ending position contributs to create_blockage 3 is added to weight
    # If ending position, contributes to break_blockage 4 is added to weight
    # If the ending position is not available 0
    new_position = 4
    score  = 1
    {:not_allowed, new_position}
    #else
    {:ok, new_position, score }
  end



  defp determine_stage_strategy(strategy, :early_stage) do
    if should_break_six_position_block?(strategy.opponent_distribution) do
      :break_opponent_block
    else
      {:try_fill_second_stage, strategy}
    end
  end

  defp determine_stage_strategy(strategy, :mid_stage) do
    IO.inspect(strategy)
  end

  defp determine_stage_strategy(strategy, :final_stage) do
    IO.inspect(strategy)

  end

  defp should_break_six_position_block?(opponent_distribution) do
    Enum.at(opponent_distribution, 2) >= 4
  end


end
