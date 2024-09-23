defmodule BckGammonApp.PlayerTest do
  use ExUnit.Case
  alias BckGammonApp.Player
  import ExUnit.CaptureIO

  # Test player initialization
  test "initialize a player with color and direction" do
    player = Player.init(:black, 1)

    assert player.color == :black
    assert player.direction == 1
    assert player.state == :moving
    assert player.rolls == []
  end

  # Test setting revoking state
  test "set player state to revoking" do
    player = Player.init(:black, 1)
    player = Player.set_revoking_state(player)

    assert player.state == :revoking
  end

  # Test setting moving state
  test "set player state to moving" do
    player = Player.init(:black, 1)
    player = Player.set_revoking_state(player)
    player = Player.set_moving_state(player)

    assert player.state == :moving
  end

  # Test adding a roll to the player's roll list
  test "add roll to player's rolls" do
    player = Player.init(:black, 1)
    player = Player.add_roll(player, {6, 4})

    assert player.rolls == [{6, 4}]
  end

  # Test adding multiple rolls
  test "add multiple rolls to player's rolls" do
    player = Player.init(:black, 1)
    player = Player.add_roll(player, {6, 4})
    player = Player.add_roll(player, {3, 5})

    assert player.rolls == [{3, 5}, {6, 4}]
  end

  # Test roll history output (prints each roll)
  test "check roll history prints rolls" do
    player = Player.init(:black, 1)
    player = Player.add_roll(player, {6, 4})
    player = Player.add_roll(player, {3, 5})

    assert capture_io(fn -> Player.roll_history(player) end) =~ "{6, 4}"
    assert capture_io(fn -> Player.roll_history(player) end) =~ "{3, 5}"
  end

  # Test getting the list of rolls
  test "get list of rolls" do
    player = Player.init(:black, 1)
    player = Player.add_roll(player, {6, 4})
    player = Player.add_roll(player, {3, 5})

    rolls = Player.get_rolls(player)
    assert rolls == [{3, 5}, {6, 4}]
  end
end
