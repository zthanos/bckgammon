defmodule BckGammonApp.Player do
  alias BckGammonApp.Player
  # alias Ecto.Query.Planner
  defstruct [:color, :starting_position, :direction, :state, rolls: [], checkers_on_hand: []]

  def init(color, direction) do
    pos =
      case direction do
        :forward -> 1
        _ -> 24
      end

    %BckGammonApp.Player{
      color: color,
      direction: direction,
      state: :moving,
      starting_position: pos,
      rolls: [],
      checkers_on_hand: []
    }
  end

  def set_revoking_state(player) do
    %{player | state: :revoking}
  end

  def set_moving_state(player) do
    %{player | state: :moving}
  end

  def get_state(player) do
    if(Player.game_won?(player)) do
      %{player | state: :won}
    end

    player.state
  end

  def add_roll(player, roll) do
    %{player | rolls: [roll | player.rolls]}
  end

  def roll_history(player) do
    Enum.each(player.rolls, fn roll ->
      IO.inspect(roll)
    end)
    player.rolls
  end

  def is_same_player?(%Player{color: color1}, %Player{color: color2}) do
    color1 == color2
  end

  def add_checker_on_hand(player) do
    %{player | checkers_on_hand: [player.color | player.checkers_on_hand]} |> dbg()
  end

  def game_won?(player), do: Enum.count(player.checkers_on_hand) == 15
  def get_rolls(player), do: player.rolls
end
