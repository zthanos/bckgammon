defmodule BckGammonApp.Player do
  defstruct [:color, :starting_position, :direction, :state, rolls: []]

  # Initializes a new player
  def init(color, direction) do
    pos = case direction do
      :forward -> 1
      _ -> 24
    end
    %BckGammonApp.Player{
      color: color,
      direction: direction,
      state: :moving,  # Default state is 'moving'
      starting_position: pos,
      rolls: []        # Initialize an empty list for rolls
    }
  end

  # Set revoking state for the player
  def set_revoking_state(player) do
    %{player | state: :revoking}
  end

  # Set moving state for the player
  def set_moving_state(player) do
    %{player | state: :moving}
  end

  # Add a roll to the player's roll list
  def add_roll(player, roll) do
    %{player | rolls: [roll | player.rolls]}
  end

  # Print roll history or return it as a list
  def roll_history(player) do
    Enum.each(player.rolls, fn roll ->
      IO.inspect(roll)
    end)
  end

  # Alternatively, return the list of rolls directly
  def get_rolls(player), do: player.rolls
end
