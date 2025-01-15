defmodule BckGammonApp.Helpers do
  def max_position(values) do
    values
    |> Enum.with_index()
    |> Enum.max_by(fn {value, _index} -> value end)
    |> elem(1)
  end
end
