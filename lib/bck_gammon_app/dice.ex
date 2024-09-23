defmodule BckGammonApp.Dice do
  def roll do
    Enum.random(1..6)
  end

  def roll_multiple(n) when n > 0 do
    Enum.take_random(1..6, n)
  end
end
