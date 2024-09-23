defmodule BckGammonApp.Game do
  @callback init_board() :: any()
  @callback move_checker(any(), integer(), integer(), atom()) :: any()
  @callback roll_dice() :: {integer(), integer()}
  @callback revoke_checker(integer(), atom()) :: any()
end
